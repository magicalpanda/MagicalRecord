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

    SingleEntityWithNoRelationships *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:childContext];
    XCTAssertTrue(insertedObject.hasChanges);

    [childContext performBlockAndWait:^{
        NSError *obtainIDsError;
        BOOL obtainIDsResult = [childContext obtainPermanentIDsForObjects:@[ insertedObject ] error:&obtainIDsError];
        XCTAssertTrue(obtainIDsResult);
        XCTAssertNil(obtainIDsError);
    }];

    NSManagedObjectID *insertedObjectID = [insertedObject objectID];
    XCTAssertNotNil(insertedObjectID);
    XCTAssertFalse(insertedObjectID.isTemporaryID);

    NSError *saveError;
    BOOL saveResult = [childContext MR_saveOnlySelfAndWaitWithError:&saveError];
    XCTAssertTrue(saveResult);
    XCTAssertNil(saveError);

    NSManagedObject *parentContextFetchedObject = [parentContext objectRegisteredForID:insertedObjectID];

    XCTAssertNotNil(parentContextFetchedObject);
    XCTAssertTrue(parentContextFetchedObject.hasChanges, @"Saving a child context moves the saved changes up to the parent, but does not save them, leaving the parent context with changes");

    [childContext performBlockAndWait:^{
        NSManagedObject *childContextFetchedObject = [childContext objectRegisteredForID:insertedObjectID];

        XCTAssertNotNil(childContextFetchedObject);
        XCTAssertFalse(childContextFetchedObject.hasChanges, @"The child context should not have changes after the save");
    }];
}

- (void)testSaveToSelfOnlyWhenSaveIsAsynchronous
{
    NSManagedObjectContext *parentContext = self.stack.context;
    NSManagedObjectContext *childContext = [NSManagedObjectContext MR_privateQueueContext];
    childContext.parentContext = parentContext;

    SingleEntityWithNoRelationships *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:childContext];
    XCTAssertTrue(insertedObject.hasChanges);

    [childContext performBlockAndWait:^{
        NSError *obtainIDsError;
        BOOL obtainIDsResult = [childContext obtainPermanentIDsForObjects:@[ insertedObject ] error:&obtainIDsError];
        XCTAssertTrue(obtainIDsResult);
        XCTAssertNil(obtainIDsError);
    }];

    NSManagedObjectID *insertedObjectID = [insertedObject objectID];
    XCTAssertNotNil(insertedObjectID);
    XCTAssertFalse(insertedObjectID.isTemporaryID);

    __block NSManagedObject *parentContextFetchedObject;
    __block NSManagedObject *childContextFetchedObject;

    XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for asynchronous context to save"];

    [childContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        XCTAssertTrue(success);
        XCTAssertNil(error);

        [parentContext performBlockAndWait:^{
            parentContextFetchedObject = [parentContext objectRegisteredForID:insertedObjectID];
        }];

        childContextFetchedObject = [childContext objectRegisteredForID:insertedObjectID];

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];

    XCTAssertNotNil(parentContextFetchedObject);
    XCTAssertTrue(parentContextFetchedObject.hasChanges, @"Saves from child contexts should leave changes in the parent");

    [childContext performBlockAndWait:^{
        XCTAssertFalse(childContext.hasChanges, @"Child context should not have changes after the save has completed");
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

    SingleEntityWithNoRelationships *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:childContext];
    XCTAssertTrue(insertedObject.hasChanges);

    [childContext performBlockAndWait:^{
        NSError *obtainIDsError;
        BOOL obtainIDsResult = [childContext obtainPermanentIDsForObjects:@[ insertedObject ] error:&obtainIDsError];
        XCTAssertTrue(obtainIDsResult);
        XCTAssertNil(obtainIDsError);
    }];

    NSManagedObjectID *insertedObjectID = [insertedObject objectID];
    XCTAssertNotNil(insertedObjectID);
    XCTAssertFalse(insertedObjectID.isTemporaryID);

    [childContext performBlockAndWait:^{
        NSError *saveError;
        BOOL saveResult = [childContext MR_saveToPersistentStoreAndWaitWithError:&saveError];
        XCTAssertTrue(saveResult);
        XCTAssertNil(saveError);
    }];

    NSError *fetchExistingObjectFromParentContextError;
    NSManagedObject *parentContextFetchedObject = [parentContext existingObjectWithID:insertedObjectID error:&fetchExistingObjectFromParentContextError];
    XCTAssertNil(fetchExistingObjectFromParentContextError);
    XCTAssertNotNil(parentContextFetchedObject);
    XCTAssertFalse(parentContextFetchedObject.hasChanges, @"Saving to the persistent store should save to all parent contexts, leaving no changes");

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

    SingleEntityWithNoRelationships *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:childContext];
    XCTAssertTrue(insertedObject.hasChanges);

    [childContext performBlockAndWait:^{
        NSError *obtainIDsError;
        BOOL obtainIDsResult = [childContext obtainPermanentIDsForObjects:@[ insertedObject ] error:&obtainIDsError];
        XCTAssertTrue(obtainIDsResult);
        XCTAssertNil(obtainIDsError);
    }];

    NSManagedObjectID *insertedObjectID = [insertedObject objectID];
    XCTAssertNotNil(insertedObjectID);
    XCTAssertFalse(insertedObjectID.isTemporaryID);

    __block NSManagedObject *parentContextFetchedObject;
    __block NSManagedObject *childContextFetchedObject;
    __block NSError *fetchExistingObjectFromParentContextError;

    XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for asynchronous context to save"];

    [childContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        XCTAssertTrue(success);
        XCTAssertNil(error);

        parentContextFetchedObject = [parentContext existingObjectWithID:insertedObjectID error:&fetchExistingObjectFromParentContextError];
        childContextFetchedObject = [childContext objectRegisteredForID:insertedObjectID];

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];

    XCTAssertNil(fetchExistingObjectFromParentContextError);
    XCTAssertNotNil(parentContextFetchedObject);
    XCTAssertFalse(parentContextFetchedObject.hasChanges, @"Saving to the persistent store should save to all parent contexts, leaving no changes");

    [childContext performBlockAndWait:^{
        XCTAssertFalse(childContext.hasChanges, @"The child context should not have changes after the save");
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
