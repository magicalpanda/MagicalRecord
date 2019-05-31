//
//  Created by Tony Arnold on 25/03/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordTestBase.h"
#import "SingleEntityWithNoRelationships.h"

@interface NSManagedObjectContextMagicalSavesTests : MagicalRecordTestBase

@end

@implementation NSManagedObjectContextMagicalSavesTests

- (void)testSaveToSelfOnlyWhenSaveIsSynchronous
{
    NSManagedObjectContext *parentContext = [NSManagedObjectContext MR_defaultContext];
    NSManagedObjectContext *childContext = [NSManagedObjectContext MR_contextWithParent:parentContext];

    XCTestExpectation *childContextSavedExpectation = [self expectationWithDescription:@"Child Context Did Save"];

    __block NSManagedObjectID *insertedObjectID;
    __block SingleEntityWithNoRelationships *insertedObject;

    [childContext performBlockAndWait:^{
        insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:childContext];

        XCTAssertTrue(insertedObject.hasChanges);

        NSError *obtainIDsError;
        BOOL obtainIDsResult = [childContext obtainPermanentIDsForObjects:@[insertedObject] error:&obtainIDsError];

        XCTAssertTrue(obtainIDsResult);
        XCTAssertNil(obtainIDsError);

        insertedObjectID = [insertedObject objectID];

        XCTAssertNotNil(insertedObjectID);
        XCTAssertFalse(insertedObjectID.isTemporaryID);
        
        [childContext MR_saveOnlySelfAndWait];

        [childContextSavedExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0f handler:nil];

    XCTestExpectation *parentContextSavedExpectation = [self expectationWithDescription:@"Parent Context Did Save"];
    childContextSavedExpectation = [self expectationWithDescription:@"Child Context Did Save"];

    [parentContext performBlockAndWait:^{
        NSManagedObject *parentContextFetchedObject = [parentContext objectRegisteredForID:insertedObjectID];

        // Saving a child context moves the saved changes up to the parent, but does
        //  not save them, leaving the parent context with changes
        XCTAssertNotNil(parentContextFetchedObject);
        XCTAssertTrue(parentContextFetchedObject.hasChanges);

        [childContext performBlockAndWait:^{
            NSManagedObject *childContextFetchedObject = [childContext objectRegisteredForID:insertedObjectID];

            // The child context should not have changes after the save
            XCTAssertNotNil(childContextFetchedObject);
            XCTAssertFalse(childContextFetchedObject.hasChanges);

            [childContextSavedExpectation fulfill];
        }];

        [parentContextSavedExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testSaveToSelfOnlyWhenSaveIsAsynchronous
{
    NSManagedObjectContext *parentContext = [NSManagedObjectContext MR_defaultContext];
    NSManagedObjectContext *childContext = [NSManagedObjectContext MR_contextWithParent:parentContext];

    XCTestExpectation *childContextExpectation = [self expectationWithDescription:@"Child Context Completed Work"];
    XCTestExpectation *childContextSaveExpectation = [self expectationWithDescription:@"Child Context Saved"];
    XCTestExpectation *parentContextExpectation = [self expectationWithDescription:@"Parent Context Completed Work"];

    [childContext performBlock:^{
        SingleEntityWithNoRelationships *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:childContext];

        XCTAssertTrue(insertedObject.hasChanges);

        NSError *obtainIDsError;
        BOOL obtainIDsResult = [childContext obtainPermanentIDsForObjects:@[insertedObject] error:&obtainIDsError];

        XCTAssertTrue(obtainIDsResult);
        XCTAssertNil(obtainIDsError);

        NSManagedObjectID *insertedObjectID = [insertedObject objectID];

        XCTAssertNotNil(insertedObjectID);
        XCTAssertFalse(insertedObjectID.isTemporaryID);

        [childContext MR_saveOnlySelfWithCompletion:^(BOOL contextDidSave, NSError *error) {
            XCTAssertTrue(contextDidSave);
            XCTAssertNil(error);

            [childContext performBlock:^{
                // The child context should not have changes after the save
                XCTAssertFalse(childContext.hasChanges);

                [childContextSaveExpectation fulfill];
            }];

            [parentContext performBlock:^{
                NSManagedObject *parentContextFetchedObject = [parentContext objectRegisteredForID:insertedObjectID];

                // Saving a child context moves the saved changes up to the parent, but does
                //  not save them, leaving the parent context with changes
                XCTAssertNotNil(parentContextFetchedObject);
                XCTAssertTrue(parentContextFetchedObject.hasChanges);

                [parentContextExpectation fulfill];
            }];
        }];

        [childContextExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testSaveToSelfOnlyWhenSaveIsAsynchronousCallsMainThreadOnCompletion
{
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
    NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:defaultContext];

    XCTAssertTrue(inserted.hasChanges);

    XCTestExpectation *contextSavedExpectation = [self expectationWithDescription:@"Context Did Save"];

    [defaultContext MR_saveOnlySelfWithCompletion:^(BOOL contextDidSave, NSError *error) {
        XCTAssertTrue(NSThread.isMainThread);

        [contextSavedExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testSaveToPersistentStoreWhenSaveIsSynchronous
{
    NSManagedObjectContext *parentContext = [NSManagedObjectContext MR_defaultContext];
    NSManagedObjectContext *childContext = [NSManagedObjectContext MR_contextWithParent:parentContext];

    __block NSManagedObjectID *insertedObjectID;
    __block SingleEntityWithNoRelationships *insertedObject;

    [childContext performBlockAndWait:^{
        insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:childContext];

        XCTAssertTrue(insertedObject.hasChanges);

        NSError *obtainIDsError;
        BOOL obtainIDsResult = [childContext obtainPermanentIDsForObjects:@[insertedObject] error:&obtainIDsError];

        XCTAssertTrue(obtainIDsResult);
        XCTAssertNil(obtainIDsError);

        insertedObjectID = [insertedObject objectID];

        XCTAssertNotNil(insertedObjectID);
        XCTAssertFalse(insertedObjectID.isTemporaryID);
    }];

    [childContext MR_saveToPersistentStoreAndWait];

    [parentContext performBlockAndWait:^{
        NSError *fetchExistingObjectFromParentContextError;
        NSManagedObject *parentContextFetchedObject = [parentContext existingObjectWithID:insertedObjectID error:&fetchExistingObjectFromParentContextError];

        // Saving to the persistent store should save to all parent contexts,
        //  leaving no changes
        XCTAssertNil(fetchExistingObjectFromParentContextError);
        XCTAssertNotNil(parentContextFetchedObject);
        XCTAssertFalse(parentContextFetchedObject.hasChanges);
    }];

    [childContext performBlockAndWait:^{
        NSManagedObject *childContextFetchedObject = [childContext objectRegisteredForID:insertedObjectID];

        // The child context should not have changes after the save
        XCTAssertNotNil(childContextFetchedObject);
        XCTAssertFalse(childContextFetchedObject.hasChanges);
    }];
}

- (void)testSaveToPersistentStoreWhenSaveIsAsynchronous
{
    NSManagedObjectContext *parentContext = [NSManagedObjectContext MR_defaultContext];
    NSManagedObjectContext *childContext = [NSManagedObjectContext MR_contextWithParent:parentContext];

    XCTestExpectation *childContextExpectation = [self expectationWithDescription:@"Child Context Completed Work"];
    XCTestExpectation *childContextSavedExpectation = [self expectationWithDescription:@"Child Context Saved"];

    [childContext performBlock:^{
        SingleEntityWithNoRelationships *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:childContext];

        XCTAssertTrue(insertedObject.hasChanges);

        NSError *obtainIDsError;
        BOOL obtainIDsResult = [childContext obtainPermanentIDsForObjects:@[insertedObject] error:&obtainIDsError];

        XCTAssertTrue(obtainIDsResult);
        XCTAssertNil(obtainIDsError);

        NSManagedObjectID *insertedObjectID = [insertedObject objectID];

        XCTAssertNotNil(insertedObjectID);
        XCTAssertFalse(insertedObjectID.isTemporaryID);

        [childContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
            XCTAssertTrue(contextDidSave);
            XCTAssertNil(error);

            [parentContext performBlockAndWait:^{
                NSError *fetchExistingObjectFromParentContextError;
                NSManagedObject *parentContextFetchedObject = [parentContext existingObjectWithID:insertedObjectID error:&fetchExistingObjectFromParentContextError];

                // Saving to the persistent store should save to all parent contexts,
                //  leaving no changes
                XCTAssertNil(fetchExistingObjectFromParentContextError);
                XCTAssertNotNil(parentContextFetchedObject);
                XCTAssertFalse(parentContextFetchedObject.hasChanges);
            }];

            [childContext performBlockAndWait:^{
                // The child context should not have changes after the save
                XCTAssertFalse(childContext.hasChanges);
            }];

            [childContextSavedExpectation fulfill];
        }];

        [childContextExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testThatSavedObjectsHavePermanentIDs
{
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];

    [defaultContext performBlockAndWait:^{
        SingleEntityWithNoRelationships *entity = [SingleEntityWithNoRelationships MR_createEntityInContext:defaultContext];

        XCTAssertTrue([entity objectID].isTemporaryID);

        [defaultContext MR_saveOnlySelfAndWait];

        XCTAssertFalse([entity objectID].isTemporaryID);
    }];
}

@end
