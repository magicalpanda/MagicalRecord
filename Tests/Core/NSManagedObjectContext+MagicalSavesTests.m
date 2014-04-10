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

    SingleEntityWithNoRelationships *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:childContext];

    expect([insertedObject hasChanges]).to.beTruthy();

    NSError *obtainIDsError;
    BOOL obtainIDsResult = [childContext obtainPermanentIDsForObjects:@[insertedObject] error:&obtainIDsError];

    expect(obtainIDsResult).to.beTruthy();
    expect(obtainIDsError).to.beNil();

    NSManagedObjectID *insertedObjectID = [insertedObject objectID];

    expect(insertedObjectID).toNot.beNil();
    expect([insertedObjectID isTemporaryID]).to.beFalsy();

    [childContext MR_saveOnlySelfAndWait];

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
    NSManagedObjectContext *parentContext = [NSManagedObjectContext MR_defaultContext];
    NSManagedObjectContext *childContext = [NSManagedObjectContext MR_contextWithParent:parentContext];

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
    expect(childContextFetchedObject).willNot.beNil();
    expect([childContextFetchedObject hasChanges]).will.beFalsy();
}

- (void)testSaveToSelfOnlyWhenSaveIsAsynchronousCallsMainThreadOnCompletion
{
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];

    __block BOOL completionBlockCalled = NO;
    __block BOOL completionBlockIsOnMainThread = NO;

    NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:defaultContext];

    expect([inserted hasChanges]).to.beTruthy();

    [defaultContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        completionBlockCalled = YES;
        completionBlockIsOnMainThread = [NSThread isMainThread];
    }];

    expect(completionBlockCalled).will.beTruthy();
    expect(completionBlockIsOnMainThread).will.beTruthy();
}

- (void)testSaveToPersistentStoreWhenSaveIsSynchronous
{
    NSManagedObjectContext *parentContext = [NSManagedObjectContext MR_defaultContext];
    NSManagedObjectContext *childContext = [NSManagedObjectContext MR_contextWithParent:parentContext];

    SingleEntityWithNoRelationships *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:childContext];

    expect([insertedObject hasChanges]).to.beTruthy();

    NSError *obtainIDsError;
    BOOL obtainIDsResult = [childContext obtainPermanentIDsForObjects:@[insertedObject] error:&obtainIDsError];

    expect(obtainIDsResult).to.beTruthy();
    expect(obtainIDsError).to.beNil();

    NSManagedObjectID *insertedObjectID = [insertedObject objectID];

    expect(insertedObjectID).toNot.beNil();
    expect([insertedObjectID isTemporaryID]).to.beFalsy();

    [childContext MR_saveToPersistentStoreAndWait];

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
    NSManagedObjectContext *parentContext = [NSManagedObjectContext MR_defaultContext];
    NSManagedObjectContext *childContext = [NSManagedObjectContext MR_contextWithParent:parentContext];

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
    expect(childContextFetchedObject).willNot.beNil();
    expect([childContextFetchedObject hasChanges]).will.beFalsy();
}

- (void)testThatSavedObjectsHavePermanentIDs
{
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
    SingleEntityWithNoRelationships *entity = [SingleEntityWithNoRelationships MR_createEntityInContext:defaultContext];
    
    expect([[entity objectID] isTemporaryID]).to.beTruthy();
    
    [defaultContext MR_saveOnlySelfAndWait];
    
    expect([[entity objectID] isTemporaryID]).to.beFalsy();
}

@end
