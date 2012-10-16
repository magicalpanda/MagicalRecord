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

- (void)testBackgroundSaveCallsCompletionHandler
{
    __block BOOL didSave = NO;
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        [SingleEntityWithNoRelationships MR_createInContext:localContext];
    } completion:^{
        didSave = YES;
    }];
    
    expect(didSave).will.beTruthy();
}

- (void)testBackgroundSavesActuallySave
{
    __block NSManagedObjectID *objectId;
    __block NSManagedObject *fetchedObject;
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

- (void)testCurrentThreadSavesActuallySave
{
	__block NSManagedObjectID *objectId;
    __block NSManagedObject *fetchedObject;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];
        expect([inserted hasChanges]).to.beTruthy();
        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = inserted.objectID;
    }];

	fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];

    expect(fetchedObject).toNot.beNil();
    expect([fetchedObject hasChanges]).to.beFalsy();
}

@end
