//
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.

#import "MagicalRecordTestBase.h"
#import "SingleEntityWithNoRelationships.h"

@interface NSManagedObjectContextMagicalSavesTests : MagicalRecordTestBase

@end

@implementation NSManagedObjectContextMagicalSavesTests

- (void)testSaveToSelfOnlyWhenSaveIsSynchronous
{
    NSManagedObjectContext *parentContext = self.stack.context;
    NSManagedObjectContext *childContext = [NSManagedObjectContext MR_privateQueueContext];
    childContext.parentContext = parentContext;

    XCTestExpectation *childContextSavedExpectation = [self expectationWithDescription:@"Child Context Did Save"];

    __block NSManagedObjectID *insertedObjectID;

    [childContext performBlockAndWait:^{
        SingleEntityWithNoRelationships *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:childContext];
        XCTAssertTrue(insertedObject.hasChanges);

        NSError *obtainIDsError;
        BOOL obtainIDsResult = [childContext obtainPermanentIDsForObjects:@[ insertedObject ] error:&obtainIDsError];
        XCTAssertTrue(obtainIDsResult);
        XCTAssertNil(obtainIDsError);

        insertedObjectID = [insertedObject objectID];
        XCTAssertNotNil(insertedObjectID);
        XCTAssertFalse(insertedObjectID.isTemporaryID);

        NSError *saveError;
        BOOL saveResult = [childContext MR_saveOnlySelfAndWaitWithError:&saveError];
        XCTAssertTrue(saveResult);
        XCTAssertNil(saveError);
        [childContextSavedExpectation fulfill];
    }];

    XCTestExpectation *parentContextSavedExpectation = [self expectationWithDescription:@"Parent Context Did Save"];
    childContextSavedExpectation = [self expectationWithDescription:@"Child Context Did Save"];

    [parentContext performBlockAndWait:^{
        NSManagedObject *parentContextFetchedObject = [parentContext objectRegisteredForID:insertedObjectID];

        XCTAssertNotNil(parentContextFetchedObject);
        XCTAssertTrue(parentContextFetchedObject.hasChanges, @"Saving a child context moves the saved changes up to the parent, but does not save them, leaving the parent context with changes");

        [childContext performBlockAndWait:^{
            NSManagedObject *childContextFetchedObject = [childContext objectRegisteredForID:insertedObjectID];

            XCTAssertNotNil(childContextFetchedObject);
            XCTAssertFalse(childContextFetchedObject.hasChanges, @"The child context should not have changes after the save");

            [childContextSavedExpectation fulfill];
        }];

        [parentContextSavedExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *_Nullable error) {
        if (error)
        {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testSaveToSelfOnlyWhenSaveIsAsynchronous
{
    NSManagedObjectContext *parentContext = self.stack.context;
    NSManagedObjectContext *childContext = [NSManagedObjectContext MR_privateQueueContext];
    childContext.parentContext = parentContext;

    XCTestExpectation *childContextExpectation = [self expectationWithDescription:@"Child Context Completed Work"];
    XCTestExpectation *childContextSaveExpectation = [self expectationWithDescription:@"Child Context Saved"];
    XCTestExpectation *parentContextExpectation = [self expectationWithDescription:@"Parent Context Completed Work"];

    [childContext performBlock:^{
        SingleEntityWithNoRelationships *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:childContext];
        XCTAssertTrue(insertedObject.hasChanges);

        NSError *obtainIDsError;
        BOOL obtainIDsResult = [childContext obtainPermanentIDsForObjects:@[ insertedObject ] error:&obtainIDsError];
        XCTAssertTrue(obtainIDsResult);
        XCTAssertNil(obtainIDsError);

        NSManagedObjectID *insertedObjectID = [insertedObject objectID];
        XCTAssertNotNil(insertedObjectID);
        XCTAssertFalse(insertedObjectID.isTemporaryID);

        [childContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
            XCTAssertTrue(success);
            XCTAssertNil(error);

            [childContext performBlock:^{
                XCTAssertFalse(childContext.hasChanges, @"Child context should not have changes after the save has completed");
                [childContextSaveExpectation fulfill];
            }];

            [parentContext performBlock:^{
                NSManagedObject *parentContextFetchedObject = [parentContext objectRegisteredForID:insertedObjectID];
                XCTAssertNotNil(parentContextFetchedObject);
                XCTAssertTrue(parentContextFetchedObject.hasChanges, @"Saves from child contexts should leave changes in the parent");
                [parentContextExpectation fulfill];
            }];

        }];

        [childContextExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *_Nullable error) {
        if (error)
        {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testSaveToSelfOnlyWhenSaveIsAsynchronousCallsCorrectThreadOnCompletion
{
    NSManagedObjectContext *stackContext = self.stack.context;

    __block BOOL completionBlockCalled = NO;
    __block BOOL completionBlockIsOnCallingThread = NO;

    NSManagedObject *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:stackContext];
    XCTAssertTrue(insertedObject.hasChanges);

    NSThread *callingThread = [NSThread currentThread];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for asynchronous context to save"];

    [stackContext MR_saveOnlySelfWithCompletion:^(__unused BOOL success, __unused NSError *error) {
        completionBlockCalled = YES;
        completionBlockIsOnCallingThread = [[NSThread currentThread] isEqual:callingThread];
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];

    XCTAssertTrue(completionBlockCalled);
    XCTAssertTrue(completionBlockIsOnCallingThread);
}

- (void)testSaveToPersistentStoreWhenSaveIsSynchronous
{
    NSManagedObjectContext *parentContext = self.stack.context;
    NSManagedObjectContext *childContext = [NSManagedObjectContext MR_privateQueueContext];
    childContext.parentContext = parentContext;

    __block NSManagedObjectID *insertedObjectID;

    [childContext performBlockAndWait:^{
        SingleEntityWithNoRelationships *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:childContext];

        XCTAssertTrue(insertedObject.hasChanges);

        NSError *obtainIDsError;
        BOOL obtainIDsResult = [childContext obtainPermanentIDsForObjects:@[ insertedObject ] error:&obtainIDsError];

        XCTAssertTrue(obtainIDsResult);
        XCTAssertNil(obtainIDsError);

        insertedObjectID = [insertedObject objectID];

        XCTAssertNotNil(insertedObjectID);
        XCTAssertFalse(insertedObjectID.isTemporaryID);
    }];

    NSError *saveError;
    BOOL saveResult = [childContext MR_saveToPersistentStoreAndWaitWithError:&saveError];
    XCTAssertTrue(saveResult);
    XCTAssertNil(saveError);

    [parentContext performBlockAndWait:^{
        NSError *fetchExistingObjectFromParentContextError;
        NSManagedObject *parentContextFetchedObject = [parentContext existingObjectWithID:insertedObjectID error:&fetchExistingObjectFromParentContextError];

        XCTAssertNil(fetchExistingObjectFromParentContextError);
        XCTAssertNotNil(parentContextFetchedObject);
        XCTAssertFalse(parentContextFetchedObject.hasChanges, @"Saving to the persistent store should save to all parent contexts, leaving no changes");
    }];

    [childContext performBlockAndWait:^{
        NSManagedObject *childContextFetchedObject = [childContext objectRegisteredForID:insertedObjectID];

        XCTAssertNotNil(childContextFetchedObject);
        XCTAssertFalse(childContextFetchedObject.hasChanges, @"The child context should not have changes after the save");
    }];
}

- (void)testSaveToPersistentStoreWhenSaveIsAsynchronous
{
    NSManagedObjectContext *parentContext = self.stack.context;
    NSManagedObjectContext *childContext = [NSManagedObjectContext MR_privateQueueContext];
    childContext.parentContext = parentContext;

    XCTestExpectation *childContextExpectation = [self expectationWithDescription:@"Child Context Completed Work"];
    XCTestExpectation *childContextSavedExpectation = [self expectationWithDescription:@"Child Context Saved"];

    [childContext performBlock:^{
        SingleEntityWithNoRelationships *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:childContext];
        XCTAssertTrue(insertedObject.hasChanges);

        NSError *obtainIDsError;
        BOOL obtainIDsResult = [childContext obtainPermanentIDsForObjects:@[ insertedObject ] error:&obtainIDsError];
        XCTAssertTrue(obtainIDsResult);
        XCTAssertNil(obtainIDsError);

        NSManagedObjectID *insertedObjectID = [insertedObject objectID];
        XCTAssertNotNil(insertedObjectID);
        XCTAssertFalse(insertedObjectID.isTemporaryID);

        [childContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            XCTAssertTrue(success);
            XCTAssertNil(error);

            [parentContext performBlockAndWait:^{
                NSError *fetchExistingObjectFromParentContextError;
                NSManagedObject *parentContextFetchedObject = [parentContext existingObjectWithID:insertedObjectID error:&fetchExistingObjectFromParentContextError];

                XCTAssertNil(fetchExistingObjectFromParentContextError);
                XCTAssertNotNil(parentContextFetchedObject);
                XCTAssertFalse(parentContextFetchedObject.hasChanges, @"Saving to the persistent store should save to all parent contexts, leaving no changes");
            }];

            [childContext performBlockAndWait:^{
                XCTAssertFalse(childContext.hasChanges, @"The child context should not have changes after the save");
            }];

            [childContextSavedExpectation fulfill];
        }];

        [childContextExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *_Nullable error) {
        if (error)
        {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testThatSavedObjectsHavePermanentIDs
{
    NSManagedObjectContext *stackContext = self.stack.context;
    SingleEntityWithNoRelationships *entity = [SingleEntityWithNoRelationships MR_createEntityInContext:stackContext];
    XCTAssertTrue(entity.objectID.isTemporaryID, @"Object ID should be temporary before the object has been saved");

    NSError *saveError;
    BOOL saveResult = [stackContext MR_saveOnlySelfAndWaitWithError:&saveError];
    XCTAssertTrue(saveResult);
    XCTAssertNil(saveError);

    XCTAssertFalse(entity.objectID.isTemporaryID, @"Object ID should not be temporary after the object has been saved");
}

@end
