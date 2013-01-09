//
//  SaveTests.m
//  Magical Record
//
//  Created by Stephen J Vanterpool on 9/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#define EXP_SHORTHAND
#import "Expecta.h"
#import "SaveTests.h"
#import "SingleEntityWithNoRelationships.h"

@implementation SaveTests

- (void) setUpClass
{
    [NSManagedObjectModel MR_setDefaultManagedObjectModel:[NSManagedObjectModel MR_managedObjectModelNamed:@"TestModel.momd"]];
}

- (void) setUp
{
    NSLog(@"Creating stack");
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
}

- (void) tearDown
{
    [MagicalRecord cleanUp];
}

- (void)testAsynchronousSaveCallsCompletionHandler
{
    __block BOOL completionHandlerCalled = NO;

    dispatch_group_t group = dispatch_group_create();

    dispatch_group_enter(group);

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        expect(localContext).toNot.beNil();
        [SingleEntityWithNoRelationships MR_createInContext:localContext];
    } completion:^(BOOL success, NSError *error) {
        // Ignore the success state — we only care that this block is executed
        completionHandlerCalled = YES;
        dispatch_group_leave(group);
    }];

    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    expect(completionHandlerCalled).will.beTruthy();
}

- (void)testAsynchronousSavesActuallySave
{
    __block BOOL               saveSuccessState = NO;
    __block NSManagedObjectID *objectId;
    __block NSManagedObject   *fetchedObject;

    dispatch_group_t group = dispatch_group_create();

    dispatch_group_enter(group);

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];
        expect([inserted hasChanges]).to.beTruthy();
        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = inserted.objectID;
    } completion:^(BOOL success, NSError *error) {
        saveSuccessState = success;
        fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];
        dispatch_group_leave(group);
    }];

    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    expect(saveSuccessState).to.beTruthy();
    expect(fetchedObject).toNot.beNil();
    expect([fetchedObject hasChanges]).to.beFalsy();
}

- (void)testSynchronousSavesActuallySave
{
    __block NSManagedObjectID *objectId;
    __block NSManagedObject   *fetchedObject;

    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];
        expect([inserted hasChanges]).to.beTruthy();
        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = inserted.objectID;
    }];

    fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];

    expect(fetchedObject).toNot.beNil();
    expect([fetchedObject hasChanges]).to.beFalsy();
}

- (void)testCurrentThreadContextAsynchronousSavesActuallySave
{
    __block NSManagedObjectID *objectId;
    __block NSManagedObject   *fetchedObject;

    dispatch_group_t group = dispatch_group_create();

    dispatch_group_enter(group);

    [MagicalRecord saveUsingCurrentContextWithBlock:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];
        expect([inserted hasChanges]).to.beTruthy();
        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = inserted.objectID;
    } completion:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        dispatch_group_leave(group);
    }];

    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];
    expect(fetchedObject).toNot.beNil();
    expect([fetchedObject hasChanges]).to.beFalsy();
}

- (void)testCurrentThreadContextSynchronousSavesActuallySave
{
    __block NSManagedObjectID *objectId;
    __block NSManagedObject   *fetchedObject;

    [MagicalRecord saveUsingCurrentContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];
        expect([inserted hasChanges]).to.beTruthy();
        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = inserted.objectID;
    }];

    fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];
    expect(fetchedObject).toNot.beNil();
    expect([fetchedObject hasChanges]).to.beFalsy();
}

#pragma mark - Test deprecated methods still work as expected

- (void)testDeprecatedSimpleSynchronousSaveActuallySaves
{
    NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    NSManagedObject        *inserted             = [SingleEntityWithNoRelationships MR_createEntity];

    expect([inserted hasChanges]).to.beTruthy();
    [managedObjectContext obtainPermanentIDsForObjects:@[inserted] error:nil];
    NSManagedObjectID *objectId = inserted.objectID;

    [managedObjectContext MR_save];

    NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];
    expect(fetchedObject).toNot.beNil();
    expect([fetchedObject hasChanges]).to.beFalsy();
}

- (void)testDeprecatedBackgroundSaveCallsCompletionHandler
{
    __block BOOL didSave = NO;

    dispatch_group_t group = dispatch_group_create();

    dispatch_group_enter(group);

    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        expect(localContext).toNot.beNil();
        [SingleEntityWithNoRelationships MR_createInContext:localContext];
    } completion:^{
        didSave = YES;
        dispatch_group_leave(group);
    }];

    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    expect(didSave).will.beTruthy();
}

- (void)testDeprecatedBackgroundSavesActuallySave
{
    __block NSManagedObjectID *objectId;
    __block NSManagedObject   *fetchedObject;

    dispatch_group_t group = dispatch_group_create();

    dispatch_group_enter(group);

    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];
        expect([inserted hasChanges]).to.beTruthy();
        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = inserted.objectID;
    } completion:^{
        fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];
        dispatch_group_leave(group);
    }];

    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    expect(fetchedObject).toNot.beNil();
    expect([fetchedObject hasChanges]).to.beFalsy();
}

@end
