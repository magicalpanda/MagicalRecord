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
    NSManagedObjectContext *parentContext = self.stack.context;
    NSManagedObjectContext *childContext = [NSManagedObjectContext MR_privateQueueContext];
    childContext.parentContext = parentContext;

    SingleEntityWithNoRelationships *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:childContext];

    expect([insertedObject hasChanges]).to.beTruthy();

    NSError *obtainIDsError;
    BOOL obtainIDsResult = [childContext obtainPermanentIDsForObjects:@[insertedObject] error:&obtainIDsError];

    expect(obtainIDsResult).to.beTruthy();
    expect(obtainIDsError).to.beNil();

    NSManagedObjectID *insertedObjectID = [insertedObject objectID];

    expect(insertedObjectID).toNot.beNil();
    expect([insertedObjectID isTemporaryID]).to.beFalsy();

    NSError *saveError;
    BOOL saveResult = [childContext MR_saveOnlySelfAndWaitWithError:&saveError];
    expect(saveResult).to.beTruthy();
    expect(saveError).to.beNil();

    NSManagedObject *parentContextFetchedObject = [parentContext objectRegisteredForID:insertedObjectID];

    // Saving a child context moves the saved changes up to the parent, but does
    //  not save them, leaving the parent context with changes
    expect(parentContextFetchedObject).toNot.beNil();
    expect([parentContextFetchedObject hasChanges]).to.beTruthy();

    NSManagedObject *childContextFetchedObject = [childContext objectRegisteredForID:insertedObjectID];

    // The child context should not have changes after the save
    expect(childContextFetchedObject).toNot.beNil();
    expect([childContextFetchedObject hasChanges]).to.beFalsy();
}

- (void)testSaveToSelfOnlyWhenSaveIsAsynchronous
{
    NSManagedObjectContext *parentContext = self.stack.context;
    NSManagedObjectContext *childContext = [NSManagedObjectContext MR_privateQueueContext];
    childContext.parentContext = parentContext;

    SingleEntityWithNoRelationships *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:childContext];

    expect([insertedObject hasChanges]).to.beTruthy();

    NSError *obtainIDsError;
    BOOL obtainIDsResult = [childContext obtainPermanentIDsForObjects:@[insertedObject] error:&obtainIDsError];

    expect(obtainIDsResult).to.beTruthy();
    expect(obtainIDsError).to.beNil();

    NSManagedObjectID *insertedObjectID = [insertedObject objectID];

    expect(insertedObjectID).toNot.beNil();
    expect([insertedObjectID isTemporaryID]).to.beFalsy();

    __block NSManagedObject *parentContextFetchedObject;
    __block NSManagedObject *childContextFetchedObject;

    [childContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        parentContextFetchedObject = [parentContext objectRegisteredForID:insertedObjectID];
        childContextFetchedObject = [childContext objectRegisteredForID:insertedObjectID];
    }];

    // Saving a child context moves the saved changes up to the parent, but does
    //  not save them, leaving the parent context with changes
    expect(parentContextFetchedObject).willNot.beNil();
    expect([parentContextFetchedObject hasChanges]).will.beTruthy();

    // The child context should not have changes after the save
    expect([childContext hasChanges]).will.beFalsy();
}

- (void)testSaveToSelfOnlyWhenSaveIsAsynchronousCallsCorrectThreadOnCompletion
{
    NSManagedObjectContext *stackContext = self.stack.context;

    __block BOOL completionBlockCalled = NO;
    __block BOOL completionBlockIsOnCallingThread = NO;

    NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:stackContext];

    expect([inserted hasChanges]).to.beTruthy();

    NSThread *callingThread = [NSThread currentThread];

    [stackContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        completionBlockCalled = YES;
        completionBlockIsOnCallingThread = [[NSThread currentThread] isEqual:callingThread];
    }];

    expect(completionBlockCalled).will.beTruthy();
    expect(completionBlockIsOnCallingThread).will.beTruthy();
}

- (void)testSaveToPersistentStoreWhenSaveIsSynchronous
{
    NSManagedObjectContext *parentContext = self.stack.context;
    NSManagedObjectContext *childContext = [NSManagedObjectContext MR_privateQueueContext];
    childContext.parentContext = parentContext;

    SingleEntityWithNoRelationships *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:childContext];

    expect([insertedObject hasChanges]).to.beTruthy();

    NSError *obtainIDsError;
    BOOL obtainIDsResult = [childContext obtainPermanentIDsForObjects:@[insertedObject] error:&obtainIDsError];

    expect(obtainIDsResult).to.beTruthy();
    expect(obtainIDsError).to.beNil();

    NSManagedObjectID *insertedObjectID = [insertedObject objectID];

    expect(insertedObjectID).toNot.beNil();
    expect([insertedObjectID isTemporaryID]).to.beFalsy();

    NSError *saveError;
    BOOL saveResult = [childContext MR_saveToPersistentStoreAndWaitWithError:&saveError];
    expect(saveResult).to.beTruthy();
    expect(saveError).to.beNil();

    NSError *fetchExistingObjectFromParentContextError;
    NSManagedObject *parentContextFetchedObject = [parentContext existingObjectWithID:insertedObjectID error:&fetchExistingObjectFromParentContextError];

    // Saving to the persistent store should save to all parent contexts,
    //  leaving no changes
    expect(fetchExistingObjectFromParentContextError).to.beNil();
    expect(parentContextFetchedObject).toNot.beNil();
    expect([parentContextFetchedObject hasChanges]).to.beFalsy();

    NSManagedObject *childContextFetchedObject = [childContext objectRegisteredForID:insertedObjectID];

    // The child context should not have changes after the save
    expect(childContextFetchedObject).toNot.beNil();
    expect([childContextFetchedObject hasChanges]).to.beFalsy();
}

- (void)testSaveToPersistentStoreWhenSaveIsAsynchronous
{
    NSManagedObjectContext *parentContext = self.stack.context;
    NSManagedObjectContext *childContext = [NSManagedObjectContext MR_privateQueueContext];
    childContext.parentContext = parentContext;

    SingleEntityWithNoRelationships *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:childContext];

    expect([insertedObject hasChanges]).to.beTruthy();

    NSError *obtainIDsError;
    BOOL obtainIDsResult = [childContext obtainPermanentIDsForObjects:@[insertedObject] error:&obtainIDsError];

    expect(obtainIDsResult).to.beTruthy();
    expect(obtainIDsError).to.beNil();

    NSManagedObjectID *insertedObjectID = [insertedObject objectID];

    expect(insertedObjectID).toNot.beNil();
    expect([insertedObjectID isTemporaryID]).to.beFalsy();

    __block NSManagedObject *parentContextFetchedObject;
    __block NSManagedObject *childContextFetchedObject;
    __block NSError *fetchExistingObjectFromParentContextError;

    [childContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        parentContextFetchedObject = [parentContext existingObjectWithID:insertedObjectID error:&fetchExistingObjectFromParentContextError];
        childContextFetchedObject = [childContext objectRegisteredForID:insertedObjectID];
    }];

    // Saving to the persistent store should save to all parent contexts,
    //  leaving no changes
    expect(fetchExistingObjectFromParentContextError).to.beNil();
    expect(parentContextFetchedObject).willNot.beNil();
    expect([parentContextFetchedObject hasChanges]).will.beFalsy();

    // The child context should not have changes after the save
    expect([childContext hasChanges]).will.beFalsy();
}

- (void)testThatSavedObjectsHavePermanentIDs
{
    NSManagedObjectContext *stackContext = self.stack.context;
    SingleEntityWithNoRelationships *entity = [SingleEntityWithNoRelationships MR_createEntityInContext:stackContext];

    expect([[entity objectID] isTemporaryID]).to.beTruthy();
    
    NSError *saveError;
    BOOL saveResult = [stackContext MR_saveOnlySelfAndWaitWithError:&saveError];
    expect(saveResult).to.beTruthy();
    expect(saveError).to.beNil();

    expect([[entity objectID] isTemporaryID]).to.beFalsy();
}

@end
