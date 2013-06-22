#import "Kiwi.h"

// Project
#import "SingleEntityWithNoRelationships.h"

SPEC_BEGIN(NSManagedObjectContextMagicalSavesSpec)

describe(@"NSManagedObjectContext+MagicalSaves", ^{
    beforeEach (^{
        // Occurs before each enclosed "it" block
        [MagicalRecord setDefaultModelFromClass:[self class]];
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });
    
    afterEach (^{
        // Occurs after each enclosed "it" block
        [MagicalRecord cleanUp];
    });
    
    context(@"be able to save to self only", ^{
        __block NSManagedObjectContext *managedObjectContext;
        
        beforeEach (^{
            managedObjectContext = [NSManagedObjectContext MR_context];
        });
        
        afterEach (^{
            [managedObjectContext reset];
            managedObjectContext = nil;
        });
        
        context(@"synchronously", ^{
            it(@"should save", ^{
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];
                
                [[@([inserted hasChanges]) should] beTrue];
                
                [managedObjectContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                NSManagedObjectID *objectId = [inserted objectID];
                
                [managedObjectContext MR_saveOnlySelfAndWait];
                
                NSManagedObject *rootFetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
                
                [rootFetchedObject shouldBeNil];
                [[@([rootFetchedObject hasChanges]) should] beFalse];
                
                rootFetchedObject = [managedObjectContext objectRegisteredForID:objectId];
                
                [rootFetchedObject shouldNotBeNil];
                [[@([rootFetchedObject hasChanges]) should] beFalse];
            });
        });
        
        context(@"asynchronously", ^{
            it(@"and should call the completion block on the main thread", ^{
                __block BOOL completionBlockCalled = NO;
                __block BOOL completionBlockIsOnMainThread = NO;

                [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];
                
                [managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
                    completionBlockCalled = YES;
                    completionBlockIsOnMainThread = [NSThread isMainThread];
                }];
                
                [[expectFutureValue(@(completionBlockCalled)) shouldEventually] beTrue];
            });
            
            it(@"should save", ^{
                __block NSManagedObjectID *objectId;
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];
                
                [[@([inserted hasChanges]) should] beTrue];
                
                [managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
                    [managedObjectContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                    objectId = [inserted objectID];
                }];
                
                [[expectFutureValue(objectId) shouldEventually] beNonNil];
                
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
                
                [[expectFutureValue(fetchedObject) shouldEventually] beNil];
                [[expectFutureValue(@([fetchedObject hasChanges])) shouldEventually] beFalse];
                
                fetchedObject = [managedObjectContext objectRegisteredForID:objectId];
                
                [[expectFutureValue(fetchedObject) shouldEventually] beNonNil];
                [[expectFutureValue(@([fetchedObject hasChanges])) shouldEventually] beFalse];
            });
        });
    });
    
    context(@"be able to save to the persistent store", ^{
        __block NSManagedObjectContext *managedObjectContext;
        
        beforeEach (^{
            managedObjectContext = [NSManagedObjectContext MR_context];
        });
        
        afterEach (^{
            [managedObjectContext reset];
            managedObjectContext = nil;
        });
        
        context(@"synchronously", ^{
            it(@"and should save", ^{
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];
                
                [[@([managedObjectContext hasChanges]) should] beTrue];
                [[@([inserted hasChanges]) should] beTrue];
                
                [managedObjectContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                NSManagedObjectID *objectId = [inserted objectID];
                
                [managedObjectContext MR_saveToPersistentStoreAndWait];
                
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
                
                [fetchedObject shouldNotBeNil];
                [[@([fetchedObject hasChanges]) should] beFalse];
            });
        });
        
        context(@"asynchronously", ^{
            it(@"and should call the completion block on the main thread", ^{
                __block BOOL completionBlockCalled = NO;
                __block BOOL completionBlockIsOnMainThread = NO;

                [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];
                
                [[@([managedObjectContext hasChanges]) should] beTrue];
                
                [managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                    completionBlockCalled = YES;
                    completionBlockIsOnMainThread = [NSThread isMainThread];
                }];
                
                [[expectFutureValue(@(completionBlockCalled)) shouldEventually] beTrue];
            });
            
            it(@"and should save", ^{
                __block NSManagedObjectID *objectId;
                
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];
                
                [[@([managedObjectContext hasChanges]) should] beTrue];
                [[@([inserted hasChanges]) should] beTrue];
                
                [managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                    [managedObjectContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                    objectId = [inserted objectID];
                }];
                
                [[expectFutureValue(objectId) shouldEventually] beNonNil];
                
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
                
                [[expectFutureValue(fetchedObject) shouldEventually] beNonNil];
                [[expectFutureValue(@([fetchedObject hasChanges])) shouldEventually] beFalse];
            });
        });
    });
    
    context(@"be able to save with options", ^{
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
        
        context(@"synchronously", ^{
            beforeEach(^{
                permanentObjectID = [insertedObject objectID];
                [permanentObjectID shouldNotBeNil];
            });
            
            specify (^{
                [[@([managedObjectContext hasChanges]) should] beTrue];
                [[@([insertedObject hasChanges]) should] beTrue];
            });
            
            it(@"to self only", ^{
                [managedObjectContext MR_saveWithOptions:MRSaveSynchronously completion:^(BOOL success, NSError *error) {
                    [[@(success) should] beTrue];
                    [error shouldBeNil];
                }];
                
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:permanentObjectID];
                [fetchedObject shouldBeNil];
                [[@([fetchedObject hasChanges]) should] beFalse];
            });
            
            it(@"to persistent store", ^{
                [managedObjectContext MR_saveWithOptions:MRSaveSynchronously | MRSaveParentContexts completion:^(BOOL success, NSError *error) {
                    [[@(success) should] beTrue];
                    [error shouldBeNil];
                }];
                
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:permanentObjectID];
                [fetchedObject shouldNotBeNil];
                [[@([fetchedObject hasChanges]) should] beFalse];
            });
        });
        
        context(@"asynchronously", ^{
            it(@"to self only", ^{
                [managedObjectContext MR_saveWithOptions:0 completion:^(BOOL success, NSError *error) {
                    [[@(success) should] beTrue];
                    [error shouldBeNil];
                    
                    [managedObjectContext obtainPermanentIDsForObjects:@[insertedObject] error:nil];
                    permanentObjectID = [insertedObject objectID];
                }];
                
                [[expectFutureValue(permanentObjectID) shouldEventually] beNonNil];
                
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:permanentObjectID];
                [[expectFutureValue(fetchedObject) shouldEventually] beNil];
                [[@([fetchedObject hasChanges]) should] beFalse];
            });
            
            it(@"to persistent store", ^{
                [managedObjectContext MR_saveWithOptions:MRSaveParentContexts completion:^(BOOL success, NSError *error) {
                    [[@(success) should] beTrue];
                    [error shouldBeNil];
                    
                    [managedObjectContext obtainPermanentIDsForObjects:@[insertedObject] error:nil];
                    permanentObjectID = [insertedObject objectID];
                }];
                
                [[expectFutureValue(permanentObjectID) shouldEventually] beNonNil];
                
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:permanentObjectID];
                [[expectFutureValue(fetchedObject) shouldEventually] beNonNil];
                [[@([fetchedObject hasChanges]) should] beFalse];
            });
        });
    });
    
    // We're testing for deprecated method function — ignore the warnings
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    context(@"deprecated method", ^{
        __block NSManagedObjectContext *managedObjectContext;
        
        beforeEach (^{
            managedObjectContext = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
        });
        
        afterEach (^{
            [managedObjectContext reset];
            managedObjectContext = nil;
        });
        
        context(@"MR_save", ^{
            it(@"should save", ^{
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];
                
                [[@([inserted hasChanges]) should] beTrue];
                
                [managedObjectContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                NSManagedObjectID *objectId = [inserted objectID];
                
                [managedObjectContext MR_save];
                
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
                
                [fetchedObject shouldNotBeNil];
                [[@([fetchedObject hasChanges]) should] beFalse];
            });
        });
        
        context(@"MR_saveWithErrorCallback", ^{
            it(@"should call error handler on errors", ^{
                __block BOOL errorHandlerCalled = NO;
                
                [managedObjectContext MR_saveWithErrorCallback:^(NSError *error) {
                    errorHandlerCalled = YES;
                }];
                
                [[expectFutureValue(@(errorHandlerCalled)) shouldEventually] beTrue];
            });
            
            it(@"should save", ^{
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];
                
                [[@([inserted hasChanges]) should] beTrue];
                
                [managedObjectContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                NSManagedObjectID *objectId = [inserted objectID];
                
                __block BOOL errorHandlerCalled = NO;
                __block NSError *saveError;
                
                [managedObjectContext MR_saveWithErrorCallback:^(NSError *error) {
                    saveError = error;
                    errorHandlerCalled = YES;
                }];
                
                [saveError shouldBeNil];
                [[@(errorHandlerCalled) should] beFalse];
                
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
                
                [fetchedObject shouldNotBeNil];
                [[@([fetchedObject hasChanges]) should] beFalse];
            });
        });
        
        context(@"MR_saveInBackgroundErrorHandler", ^{
            it(@"should call error handler on errors", ^{
                __block BOOL errorHandlerCalled = NO;
                
                [managedObjectContext MR_saveInBackgroundErrorHandler:^(NSError *error) {
                    errorHandlerCalled = YES;
                }];
                
                [[expectFutureValue(@(errorHandlerCalled)) shouldEventually] beTrue];
            });
            
            it(@"should save to self, and be present in parent context", ^{
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];
                
                [[@([inserted hasChanges]) should] beTrue];
                
                [managedObjectContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                NSManagedObjectID *objectId = [inserted objectID];
                
                __block BOOL errorHandlerCalled = NO;
                __block NSError *saveError;
                
                [managedObjectContext MR_saveInBackgroundErrorHandler:^(NSError *error) {
                    saveError = error;
                    errorHandlerCalled = YES;
                }];
                
                [[expectFutureValue(@([inserted hasChanges])) shouldEventually] beFalse];
                
                // There should be no errors
                [[expectFutureValue(saveError) shouldEventually] beNil];
                [[expectFutureValue(@(errorHandlerCalled)) shouldEventually] beFalse];
                
                // Retrieve the object from the root saving context, and check that it's valid
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
                
                [[expectFutureValue(fetchedObject) shouldEventually] beNil];
                [[expectFutureValue(@([fetchedObject hasChanges])) shouldEventually] beFalse];
                
                // Check that the object has been passed up to the parent context, but that the fetched object has unsaved changes
                fetchedObject = [[managedObjectContext parentContext] objectRegisteredForID:objectId];
                
                [[expectFutureValue(fetchedObject) shouldEventually] beNonNil];
                [[expectFutureValue(@([fetchedObject hasChanges])) shouldEventually] beTrue];
            });
        });
        
        context(@"MR_saveInBackgroundErrorHandler", ^{
            it(@"should call completion block", ^{
                __block BOOL completionBlockCalled = NO;
                __block BOOL errorHandlerCalled = NO;
                
                [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];
                
                [managedObjectContext MR_saveInBackgroundErrorHandler:^(NSError *error) {
                    errorHandlerCalled = YES;
                } completion:^{
                    completionBlockCalled = YES;
                }];
                
                [[expectFutureValue(@(errorHandlerCalled)) shouldEventually] beFalse];
                [[expectFutureValue(@(completionBlockCalled)) shouldEventually] beTrue];
            });
            
            it(@"should call error handler on errors", ^{
                __block BOOL completionBlockCalled = NO;
                __block BOOL errorHandlerCalled = NO;
                
                [managedObjectContext MR_saveInBackgroundErrorHandler:^(NSError *error) {
                    errorHandlerCalled = YES;
                } completion:^{
                    completionBlockCalled = YES;
                }];
                
                [[expectFutureValue(@(errorHandlerCalled)) shouldEventually] beTrue];
                [[expectFutureValue(@(completionBlockCalled)) shouldEventually] beFalse];
            });
            
            it(@"should save to self, and be present in parent context", ^{
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];
                
                [[@([inserted hasChanges]) should] beTrue];
                
                [managedObjectContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                NSManagedObjectID *objectId = [inserted objectID];
                
                __block BOOL errorHandlerCalled = NO;
                __block NSError *saveError;
                
                [managedObjectContext MR_saveInBackgroundErrorHandler:^(NSError *error) {
                    saveError = error;
                    errorHandlerCalled = YES;
                }];
                
                [[expectFutureValue(@([inserted hasChanges])) shouldEventually] beFalse];
                
                // There should be no errors
                [[expectFutureValue(saveError) shouldEventually] beNil];
                [[expectFutureValue(@(errorHandlerCalled)) shouldEventually] beFalse];
                
                // Retrieve the object from the root saving context, and check that it's valid
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
                
                [[expectFutureValue(fetchedObject) shouldEventually] beNil];
                [[expectFutureValue(@([fetchedObject hasChanges])) shouldEventually] beFalse];
                
                // Check that the object has been passed up to the parent context, but that the fetched object has unsaved changes
                fetchedObject = [[managedObjectContext parentContext] objectRegisteredForID:objectId];
                
                [[expectFutureValue(fetchedObject) shouldEventually] beNonNil];
                [[expectFutureValue(@([fetchedObject hasChanges])) shouldEventually] beTrue];
            });
        });
        
        context(@"MR_saveNestedContextsErrorHandler", ^{
            it(@"should call error handler on errors", ^{
                __block BOOL errorHandlerCalled = NO;
                
                [managedObjectContext MR_saveNestedContextsErrorHandler:^(NSError *error) {
                    errorHandlerCalled = YES;
                }];
                
                [[expectFutureValue(@(errorHandlerCalled)) shouldEventually] beTrue];
            });
            
            it(@"should save", ^{
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];
                
                [[@([inserted hasChanges]) should] beTrue];
                
                [managedObjectContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                NSManagedObjectID *objectId = [inserted objectID];
                
                __block BOOL errorHandlerCalled = NO;
                __block NSError *saveError;
                
                [managedObjectContext MR_saveNestedContextsErrorHandler:^(NSError *error) {
                    saveError = error;
                    errorHandlerCalled = YES;
                }];
                
                [[expectFutureValue(saveError) shouldEventually] beNil];
                [[expectFutureValue(@(errorHandlerCalled)) shouldEventually] beFalse];
                
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
                
                [[expectFutureValue(fetchedObject) shouldEventually] beNonNil];
                [[expectFutureValue(@([fetchedObject hasChanges])) shouldEventually] beFalse];
            });
        });
        
        context(@"MR_saveInBackgroundErrorHandler", ^{
            it(@"should call error handler on errors", ^{
                __block BOOL errorHandlerCalled = NO;
                
                [managedObjectContext MR_saveInBackgroundErrorHandler:^(NSError *error) {
                    errorHandlerCalled = YES;
                }];
                
                [[expectFutureValue(@(errorHandlerCalled)) shouldEventually] beTrue];
            });
            
            it(@"should save to self, and be present in parent context", ^{
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];
                
                [[@([inserted hasChanges]) should] beTrue];
                
                [managedObjectContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                NSManagedObjectID *objectId = [inserted objectID];
                
                __block BOOL errorHandlerCalled = NO;
                __block NSError *saveError;
                
                [managedObjectContext MR_saveInBackgroundErrorHandler:^(NSError *error) {
                    saveError = error;
                    errorHandlerCalled = YES;
                }];
                
                [[expectFutureValue(@([inserted hasChanges])) shouldEventually] beFalse];
                
                // There should be no errors
                [[expectFutureValue(saveError) shouldEventually] beNil];
                [[expectFutureValue(@(errorHandlerCalled)) shouldEventually] beFalse];
                
                // Retrieve the object from the root saving context, and check that it's valid
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
                
                [[expectFutureValue(fetchedObject) shouldEventually] beNil];
                [[expectFutureValue(@([fetchedObject hasChanges])) shouldEventually] beFalse];
                
                // Check that the object has been passed up to the parent context, but that the fetched object has unsaved changes
                fetchedObject = [[managedObjectContext parentContext] objectRegisteredForID:objectId];
                
                [[expectFutureValue(fetchedObject) shouldEventually] beNonNil];
                [[expectFutureValue(@([fetchedObject hasChanges])) shouldEventually] beTrue];
            });
        });
    });
    
#pragma clang diagnostic pop // ignored "-Wdeprecated-declarations"
});

SPEC_END
