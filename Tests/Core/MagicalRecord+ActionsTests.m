//
//  Created by Tony Arnold on 25/03/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordTestBase.h"
#import "SingleEntityWithNoRelationships.h"

@interface MagicalRecordActionsTests : MagicalRecordTestBase

@end

@implementation MagicalRecordActionsTests

#pragma mark - Synchronous Saves

- (void)testSynchronousSaveActionSaves
{
    __block NSManagedObjectID *objectId;

    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        expect([inserted hasChanges]).to.beTruthy();

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    }];

    expect(objectId).toNot.beNil();

    NSError *fetchError;
    NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] existingObjectWithID:objectId error:&fetchError];

    expect(fetchedObject).toNot.beNil();
    expect(fetchError).to.beNil();
    expect([fetchedObject hasChanges]).to.beFalsy();
}

- (void)testSynchronousSaveActionMakesInsertedEntitiesAvailableInTheDefaultContext
{
    __block NSManagedObjectID *objectId;

    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        expect([inserted hasChanges]).to.beTruthy();

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    }];

    expect(objectId).toNot.beNil();

    NSError *fetchError;
    NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] existingObjectWithID:objectId error:&fetchError];

    expect(fetchedObject).toNot.beNil();
    expect(fetchError).to.beNil();
    expect([fetchedObject hasChanges]).to.beFalsy();
}

- (void)testSynchronousSaveActionMakesUpdatesToEntitiesAvailableToTheDefaultContext
{
    __block NSManagedObjectID *objectId;
    __block NSManagedObject *fetchedObject;

    NSString *const kTestAttributeKey = @"booleanTestAttribute";

    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        [inserted setValue:@YES forKey:kTestAttributeKey];

        expect([inserted hasChanges]).to.beTruthy();

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    }];

    fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];
    expect([fetchedObject valueForKey:kTestAttributeKey]).to.beTruthy();

    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *changed = [localContext objectWithID:objectId];

        [changed setValue:@NO forKey:kTestAttributeKey];
    }];

    fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];

    // Async since the merge to the main thread context after persistence
    expect([fetchedObject valueForKey:kTestAttributeKey]).will.beFalsy();
}

#pragma mark - Asynchronous Saves

- (void)testAsynchronousSaveActionSaves
{
    __block BOOL saveSuccessState = NO;
    __block NSError *saveError;
    __block NSManagedObjectID *objectId;
    __block NSManagedObject *existingObject;
    __block NSError *existingObjectError;

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        expect([inserted hasChanges]).to.beTruthy();

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    } completion:^(BOOL success, NSError *error) {
        saveSuccessState = success;
        saveError = error;
        existingObject = [[NSManagedObjectContext MR_rootSavingContext] existingObjectWithID:objectId error:&existingObjectError];
    }];

    expect(saveSuccessState).will.beTruthy();
    expect(saveError).will.beNil();
    expect(existingObjectError).will.beNil();
    expect(existingObject).willNot.beNil();
    expect([existingObject hasChanges]).will.beFalsy();
}

- (void)testAsynchronousSaveActionCallsCompletionBlockOnTheMainThread
{
    __block BOOL completionBlockCalled = NO;
    __block BOOL completionBlockIsOnMainThread = NO;

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        expect(inserted).toNot.beNil();
    } completion:^(BOOL success, NSError *error) {
        // Ignore the success state — we only care that this block is executed on the main thread
        completionBlockCalled = YES;
        completionBlockIsOnMainThread = [NSThread isMainThread];
    }];

    expect(completionBlockCalled).will.beTruthy();
    expect(completionBlockIsOnMainThread).will.beTruthy();
}

- (void)testAsynchronousSaveActionMakesInsertedEntitiesAvailableInTheDefaultContext
{
    __block BOOL saveSuccessState = NO;
    __block NSManagedObjectID *objectId;
    __block NSManagedObject *fetchedObject;

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        expect([inserted hasChanges]).to.beTruthy();

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    } completion:^(BOOL success, NSError *error) {
        saveSuccessState = success;
        fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];
    }];

    expect(saveSuccessState).will.beTruthy();
    expect(fetchedObject).willNot.beNil();
    expect([fetchedObject hasChanges]).will.beFalsy();
}

- (void)testAsynchronousSaveActionMakesUpdatesToEntitiesAvailableToTheDefaultContext
{
    __block NSManagedObjectID *objectId;
    __block NSManagedObject *fetchedObject;

    NSString *const kTestAttributeKey = @"booleanTestAttribute";

    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        [inserted setValue:@YES forKey:kTestAttributeKey];

        expect([inserted hasChanges]).to.beTruthy();

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    }];

    fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];
    expect([fetchedObject valueForKey:kTestAttributeKey]).to.beTruthy();

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSManagedObject *changed = [localContext objectWithID:objectId];
        
        [changed setValue:@NO forKey:kTestAttributeKey];
    } completion:^(BOOL success, NSError *error) {
        fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];
    }];
    
    expect([fetchedObject valueForKey:kTestAttributeKey]).will.beFalsy();
}

- (void)testCurrentThreadSynchronousSaveActionSaves
{
    __block NSManagedObjectID *objectId;

    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        expect([inserted hasChanges]).to.beTruthy();

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    }];

    expect(objectId).toNot.beNil();

    NSError *fetchError;
    NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] existingObjectWithID:objectId error:&fetchError];

    expect(fetchedObject).toNot.beNil();
    expect(fetchError).to.beNil();
    expect([fetchedObject hasChanges]).to.beFalsy();
}

- (void)testCurrentThreadAsynchronousSaveActionSaves
{
    __block BOOL               saveSuccessState = NO;
    __block NSError           *saveError;
    __block NSManagedObjectID *objectId;

    [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        expect([inserted hasChanges]).to.beTruthy();

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    } completion:^(BOOL success, NSError *error) {
        saveSuccessState = success;
        saveError = error;
    }];

    expect(saveSuccessState).will.beTruthy();
    expect(saveError).will.beNil();
    expect(objectId).willNot.beNil();

    NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];

    expect(fetchedObject).willNot.beNil();
    expect([fetchedObject hasChanges]).will.beFalsy();
}

- (void)testCurrentThreadAsynchronousSaveActionCallsCompletionBlockOnTheMainThread
{
    __block BOOL completionBlockCalled = NO;
    __block BOOL completionBlockIsOnMainThread = NO;

    [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
        [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];
    } completion:^(BOOL success, NSError *error) {
        // Ignore the success state — we only care that this block is executed on the main thread
        completionBlockCalled = YES;
        completionBlockIsOnMainThread = [NSThread isMainThread];
    }];

    expect(completionBlockCalled).will.beTruthy();
}

@end
