#define EXP_SHORTHAND
#import "Expecta.h"
#import "Specta.h"

// Project
#import "NSManagedObjectContext+MagicalSaves.h"
#import "SingleEntityWithNoRelationships.h"

SpecBegin(NSManagedObjectContextMagicalSaves)

describe(@"NSManagedObjectContext+MagicalSaves", ^{
	beforeAll(^{
        [MagicalRecord setDefaultModelFromClass:[self class]];
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
	});

    afterEach(^{
        [NSManagedObjectContext MR_resetContextForCurrentThread];
        [NSManagedObjectContext MR_resetDefaultContext];
    });

    afterAll(^{
        [MagicalRecord cleanUp];
    });

    describe(@"be able to save to self only", ^{
        __block NSManagedObjectContext *managedObjectContext;
        
        beforeEach (^{
            managedObjectContext = [NSManagedObjectContext MR_context];
        });
        
        afterEach (^{
            [managedObjectContext reset];
            managedObjectContext = nil;
        });
        
        describe(@"synchronously", ^{
            it(@"should save", ^{
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];

                expect([inserted hasChanges]).to.beTruthy();
                
                [managedObjectContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                NSManagedObjectID *objectId = [inserted objectID];
                
                [managedObjectContext MR_saveOnlySelfAndWait];
                
                NSManagedObject *rootFetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];

                expect(rootFetchedObject).to.beNil();
                expect([rootFetchedObject hasChanges]).to.beFalsy();
                
                rootFetchedObject = [managedObjectContext objectRegisteredForID:objectId];

                expect(rootFetchedObject).toNot.beNil();
                expect([rootFetchedObject hasChanges]).to.beFalsy();
            });
        });
        
        describe(@"asynchronously", ^{
            it(@"and should call the completion block on the main thread", ^{
                __block BOOL completionBlockCalled = NO;
                __block BOOL completionBlockIsOnMainThread = NO;

                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];

                expect([inserted hasChanges]).to.beTruthy();

                [managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
                    completionBlockCalled = YES;
                    completionBlockIsOnMainThread = [NSThread isMainThread];
                }];

                expect(completionBlockCalled).will.beTruthy();
                expect(completionBlockIsOnMainThread).will.beTruthy();
            });
            
            it(@"should save", ^{
                __block NSManagedObjectID *objectId;
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];
                
                expect([inserted hasChanges]).to.beTruthy();

                [managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
                    [managedObjectContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                    objectId = [inserted objectID];
                }];

                expect(objectId).willNot.beNil();

                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
                
                expect(fetchedObject).will.beNil();
                expect([fetchedObject hasChanges]).will.beFalsy();

                fetchedObject = [managedObjectContext objectRegisteredForID:objectId];

                expect(fetchedObject).willNot.beNil();
                expect([fetchedObject hasChanges]).will.beFalsy();
            });
        });
    });
    
    describe(@"be able to save to the persistent store", ^{
        __block NSManagedObjectContext *managedObjectContext;
        
        beforeEach (^{
            managedObjectContext = [NSManagedObjectContext MR_context];
        });
        
        afterEach (^{
            [managedObjectContext reset];
            managedObjectContext = nil;
        });
        
        describe(@"synchronously", ^{
            it(@"and should save", ^{
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];

                expect([managedObjectContext hasChanges]).to.beTruthy();
                expect([inserted hasChanges]).to.beTruthy();
                
                [managedObjectContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                NSManagedObjectID *objectId = [inserted objectID];
                
                [managedObjectContext MR_saveToPersistentStoreAndWait];
                
                NSError *fetchError;
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] existingObjectWithID:objectId error:&fetchError];

                expect(fetchedObject).toNot.beNil();
                expect(fetchError).to.beNil();
                expect([fetchedObject hasChanges]).to.beFalsy();
            });
        });
        
        describe(@"asynchronously", ^{
            it(@"and should call the completion block on the main thread", ^{
                __block BOOL completionBlockCalled = NO;
                __block BOOL completionBlockIsOnMainThread = NO;

                [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];
                
                expect([managedObjectContext hasChanges]).to.beTruthy();

                [managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                    completionBlockCalled = YES;
                    completionBlockIsOnMainThread = [NSThread isMainThread];
                }];
                
                expect(completionBlockCalled).will.beTruthy();
            });
            
            it(@"and should save", ^{
                __block NSManagedObjectID *objectId;
                
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];
                
                expect([managedObjectContext hasChanges]).to.beTruthy();
                expect([inserted hasChanges]).to.beTruthy();

                [managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                    [managedObjectContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                    objectId = [inserted objectID];
                }];
                
                expect(objectId).willNot.beNil();

                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
                
                expect(fetchedObject).willNot.beNil();
                expect([fetchedObject hasChanges]).will.beFalsy();
            });
        });
    });

    describe(@"be able to save with options", ^{
        __block NSManagedObjectContext *managedObjectContext;
        __block NSManagedObjectID      *permanentObjectID;
        __block NSManagedObject        *insertedObject;
        
        beforeEach (^{
            managedObjectContext = [NSManagedObjectContext MR_context];
            insertedObject       = [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];
            [managedObjectContext obtainPermanentIDsForObjects:@[insertedObject] error:nil];
        });
        
        afterEach (^{
            [managedObjectContext reset];
            
            permanentObjectID    = nil;
            insertedObject       = nil;
            managedObjectContext = nil;
        });
        
        describe(@"synchronously", ^{
            beforeEach(^{
                permanentObjectID = [insertedObject objectID];
                expect(permanentObjectID).toNot.beNil();
            });
            
            it(@"context and object should both have changes",^{
                expect([managedObjectContext hasChanges]).to.beTruthy();
                expect([insertedObject hasChanges]).to.beTruthy();
            });
            
            it(@"to self only", ^{
                [managedObjectContext MR_saveWithOptions:MRSaveSynchronously completion:^(BOOL success, NSError *error) {
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();
                }];
                
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:permanentObjectID];
                expect(fetchedObject).to.beNil();
                expect([fetchedObject hasChanges]).to.beFalsy();
            });
            
            it(@"to persistent store", ^{
                [managedObjectContext MR_saveWithOptions:MRSaveSynchronously | MRSaveParentContexts completion:^(BOOL success, NSError *error) {
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();
                }];
                
                NSError *fetchError;
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] existingObjectWithID:permanentObjectID error:&fetchError];

                expect(fetchedObject).toNot.beNil();
                expect(fetchError).to.beNil();
                expect([fetchedObject hasChanges]).to.beFalsy();
            });
        });
        
        describe(@"asynchronously", ^{
            it(@"to self only", ^{
                [managedObjectContext MR_saveWithOptions:0 completion:^(BOOL success, NSError *error) {
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();

                    [managedObjectContext obtainPermanentIDsForObjects:@[insertedObject] error:nil];
                    permanentObjectID = [insertedObject objectID];
                }];

                expect(permanentObjectID).willNot.beNil();

                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:permanentObjectID];

                // The object should not exist into the root saving context
                expect(fetchedObject).to.beNil();
            });
            
            it(@"to persistent store", ^{
                [managedObjectContext MR_saveWithOptions:MRSaveParentContexts completion:^(BOOL success, NSError *error) {
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();

                    [managedObjectContext obtainPermanentIDsForObjects:@[insertedObject] error:nil];
                    permanentObjectID = [insertedObject objectID];
                }];

                expect(permanentObjectID).willNot.beNil();
                
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:permanentObjectID];

                expect(fetchedObject).willNot.beNil();
                expect([fetchedObject hasChanges]).will.beFalsy();
            });
        });
    });
});

SpecEnd
