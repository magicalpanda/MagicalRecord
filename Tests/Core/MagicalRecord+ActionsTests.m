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
    MagicalRecordStack *currentStack = self.stack;
    NSManagedObjectContext *currentContext = currentStack.context;

    __block NSManagedObjectID *objectId;

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        expect([inserted hasChanges]).to.beTruthy();

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    }];

    expect(objectId).toNot.beNil();

    NSError *fetchError;
    NSManagedObject *fetchedObject = [currentContext existingObjectWithID:objectId error:&fetchError];

    expect(fetchedObject).toNot.beNil();
    expect(fetchError).to.beNil();
    expect([fetchedObject hasChanges]).to.beFalsy();
}

- (void)testSynchronousSaveActionMakesInsertedEntitiesAvailableInTheDefaultContext
{
    MagicalRecordStack *currentStack = self.stack;
    NSManagedObjectContext *currentContext = currentStack.context;

    __block NSManagedObjectID *objectId;

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        expect([inserted hasChanges]).to.beTruthy();

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    }];

    expect(objectId).toNot.beNil();

    NSError *fetchError;
    NSManagedObject *fetchedObject = [currentContext existingObjectWithID:objectId error:&fetchError];

    expect(fetchedObject).toNot.beNil();
    expect(fetchError).to.beNil();
    expect([fetchedObject hasChanges]).to.beFalsy();
}

- (void)testSynchronousSaveActionMakesUpdatesToEntitiesAvailableToTheDefaultContext
{
    MagicalRecordStack *currentStack = self.stack;
    NSManagedObjectContext *currentContext = currentStack.context;

    __block NSManagedObjectID *objectId;
    __block NSManagedObject *fetchedObject;

    NSString *const kTestAttributeKey = @"booleanTestAttribute";

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        [inserted setValue:@YES forKey:kTestAttributeKey];

        expect([inserted hasChanges]).to.beTruthy();

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    }];

    fetchedObject = [currentContext objectWithID:objectId];
    expect([fetchedObject valueForKey:kTestAttributeKey]).to.beTruthy();

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *changed = [localContext objectWithID:objectId];

        [changed setValue:@NO forKey:kTestAttributeKey];
    }];

    fetchedObject = [currentContext objectWithID:objectId];

    // Async since the merge to the main thread context after persistence
    expect([fetchedObject valueForKey:kTestAttributeKey]).will.beFalsy();
}

- (void)testSaveActionDoesNotAssignEntitiesWithoutAContextToAContext
{
    MagicalRecordStack *currentStack = self.stack;

    __block NSManagedObjectID *objectId;

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[SingleEntityWithNoRelationships MR_entityName] inManagedObjectContext:localContext];
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityWithDescription:entityDescription inContext:nil];

        expect([inserted hasChanges]).to.beFalsy();
        expect([inserted managedObjectContext]).to.beNil;
        
        objectId = [inserted objectID];
    }];

    expect([objectId isTemporaryID]).to.beTruthy;
}

#pragma mark - Asynchronous Saves

- (void)testAsynchronousSaveActionSaves
{
    MagicalRecordStack *currentStack = self.stack;
    NSManagedObjectContext *currentContext = currentStack.context;

    __block BOOL saveSuccessState = NO;
    __block NSError *saveError;
    __block NSManagedObjectID *objectId;
    __block NSManagedObject *existingObject;
    __block NSError *existingObjectError;

    [currentStack saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        expect([inserted hasChanges]).to.beTruthy();

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    } completion:^(BOOL success, NSError *error) {
        saveSuccessState = success;
        saveError = error;
        existingObject = [currentContext existingObjectWithID:objectId error:&existingObjectError];
    }];

    expect(saveSuccessState).will.beTruthy();
    expect(saveError).will.beNil();
    expect(existingObjectError).will.beNil();
    expect(existingObject).willNot.beNil();
    expect([existingObject hasChanges]).will.beFalsy();
}

- (void)testAsynchronousSaveActionMakesInsertedEntitiesAvailableInTheDefaultContext
{
    MagicalRecordStack *currentStack = self.stack;
    NSManagedObjectContext *currentContext = currentStack.context;

    __block BOOL saveSuccessState = NO;
    __block NSManagedObjectID *objectId;
    __block NSManagedObject *fetchedObject;

    [currentStack saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        expect([inserted hasChanges]).to.beTruthy();

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    } completion:^(BOOL success, NSError *error) {
        saveSuccessState = success;
        fetchedObject = [currentContext objectWithID:objectId];
    }];

    expect(saveSuccessState).will.beTruthy();
    expect(fetchedObject).willNot.beNil();
    expect([fetchedObject hasChanges]).will.beFalsy();
}

- (void)testAsynchronousSaveActionMakesUpdatesToEntitiesAvailableToTheDefaultContext
{
    MagicalRecordStack *currentStack = self.stack;
    NSManagedObjectContext *currentContext = currentStack.context;

    __block NSManagedObjectID *objectId;
    __block NSManagedObject *fetchedObject;

    NSString *const kTestAttributeKey = @"booleanTestAttribute";

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        [inserted setValue:@YES forKey:kTestAttributeKey];

        expect([inserted hasChanges]).to.beTruthy();

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    }];

    fetchedObject = [currentContext objectWithID:objectId];
    expect([fetchedObject valueForKey:kTestAttributeKey]).to.beTruthy();

    [currentStack saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSManagedObject *changed = [localContext objectWithID:objectId];

        [changed setValue:@NO forKey:kTestAttributeKey];
    } completion:^(BOOL success, NSError *error) {
        fetchedObject = [currentContext objectWithID:objectId];
    }];

    expect([fetchedObject valueForKey:kTestAttributeKey]).will.beFalsy();
}

@end
