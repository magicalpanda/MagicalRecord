#import "Kiwi.h"

// Project
#import "SingleEntityWithNoRelationships.h"

SPEC_BEGIN(MagicalRecordActionsSpec)

describe(@"MagicalRecord", ^{		
	beforeEach(^{
		// Occurs before each enclosed "it" block
        [MagicalRecord setDefaultModelFromClass:[self class]];
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
	});
	
	afterEach(^{
		// Occurs after each enclosed "it" block
        [MagicalRecord cleanUp];
	});
    
    context(@"synchronous save action", ^{
        it(@"should save", ^{
            __block NSManagedObjectID *objectId;
            
            [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];
                
                [[@([inserted hasChanges]) should] beTrue];
                
                [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                objectId = [inserted objectID];
            }];
            
            [[objectId should] beNonNil];
            
            NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
            
            [[fetchedObject should] beNonNil];
            [[@([fetchedObject hasChanges]) should] beFalse];
        });
    });
    
    context(@"asynchronous save action", ^{
        it(@"should call completion block on the main thread", ^{
            __block BOOL completionBlockCalled = NO;
            __block BOOL completionBlockIsOnMainThread = NO;
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                [SingleEntityWithNoRelationships MR_createInContext:localContext];
            } completion:^(BOOL success, NSError *error) {
                // Ignore the success state — we only care that this block is executed on the main thread
                completionBlockCalled = YES;
                completionBlockIsOnMainThread = [NSThread isMainThread];
            }];
            
            [[expectFutureValue(@(completionBlockCalled)) shouldEventually] beTrue];
        });
        
        it(@"should save", ^{
            __block BOOL               saveSuccessState = NO;
            __block NSManagedObjectID *objectId;
            __block NSManagedObject   *fetchedObject;
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];
                
                [[@([inserted hasChanges]) should] beTrue];
                
                [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                objectId = [inserted objectID];
            } completion:^(BOOL success, NSError *error) {
                saveSuccessState = success;
                fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
            }];
            
            [[expectFutureValue(@(saveSuccessState)) shouldEventually] beTrue];
            [[expectFutureValue(fetchedObject) shouldEventually] beNonNil];
            [[expectFutureValue(@([fetchedObject hasChanges])) shouldEventually] beFalse];
        });
    });
    
	context(@"current thread save action", ^{
        context(@"running synchronously", ^{
            it(@"should save", ^{
                __block NSManagedObjectID *objectId;
                
                [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                    NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];
                    
                    [[@([inserted hasChanges]) should] beTrue];
                    
                    [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                    objectId = [inserted objectID];
                }];
                
                [[objectId should] beNonNil];
                
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
                
                [[fetchedObject should] beNonNil];
                [[@([fetchedObject hasChanges]) should] beFalse];
            });
        });
        
        context(@"running asynchronously", ^{
            it(@"should call completion block on the main thread", ^{
                __block BOOL completionBlockCalled = NO;
                __block BOOL completionBlockIsOnMainThread = NO;

                [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
                    [SingleEntityWithNoRelationships MR_createInContext:localContext];
                } completion:^(BOOL success, NSError *error) {
                    // Ignore the success state — we only care that this block is executed on the main thread
                    completionBlockCalled = YES;
                    completionBlockIsOnMainThread = [NSThread isMainThread];
                }];
                
                [[expectFutureValue(@(completionBlockCalled)) shouldEventually] beTrue];
            });
            
            it(@"should save", ^{
                __block BOOL               saveSuccessState = NO;
                __block NSError           *saveError;
                __block NSManagedObjectID *objectId;
                
                [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
                    NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];
                    
                    [[@([inserted hasChanges]) should] beTrue];
                    
                    [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                    objectId = [inserted objectID];
                } completion:^(BOOL success, NSError *error) {
                    saveSuccessState = success;
                    saveError = error;
                }];

                [[expectFutureValue(@(saveSuccessState)) shouldEventually] beTrue];
                [[expectFutureValue(saveError) shouldEventually] beNil];
                [[expectFutureValue(objectId) shouldEventually] beNonNil];
                
                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
                
                [[expectFutureValue(fetchedObject) shouldEventually] beNonNil];
                [[expectFutureValue(@([fetchedObject hasChanges])) shouldEventually] beFalse];
            });
        });
	});
    
    
    // We're testing for deprecated method function — ignore the warnings
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    context(@"deprecated method", ^{        
        context(@"saveInBackgroundWithBlock:", ^{
            it(@"should save", ^{
                __block NSManagedObjectID *objectId;
                
                [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
                    NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];
                    
                    [[@([inserted hasChanges]) should] beTrue];
                    
                    [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                    objectId = [inserted objectID];
                }];
                
                [[expectFutureValue(objectId) shouldEventually] beNonNil];
                
                NSManagedObject   *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
                
                [[expectFutureValue(objectId) shouldEventually] beNonNil];
                [[expectFutureValue(fetchedObject) shouldEventually] beNonNil];
                [[expectFutureValue(@([fetchedObject hasChanges])) shouldEventually] beFalse];
            });
        });
        
        context(@"saveInBackgroundWithBlock:completion:", ^{
            it(@"should call completion block", ^{
                __block BOOL completionBlockCalled = NO;
                
                [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
                    [SingleEntityWithNoRelationships MR_createInContext:localContext];
                } completion:^{
                    completionBlockCalled = YES;
                }];
                
                [[expectFutureValue(@(completionBlockCalled)) shouldEventually] beTrue];
            });
            
            it(@"should save", ^{
                __block NSManagedObjectID *objectId;
                __block NSManagedObject *fetchedObject;
                
                [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
                    NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];
                    
                    [[@([inserted hasChanges])should] beTrue];
                    
                    [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                    objectId = [inserted objectID];
                } completion:^{
                    [[objectId should] beNonNil];
                    
                    fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
                }];
                
                [[expectFutureValue(objectId) shouldEventually] beNonNil];
                [[expectFutureValue(fetchedObject) shouldEventually] beNonNil];
                [[expectFutureValue(@([fetchedObject hasChanges])) shouldEventually] beFalse];
            });
        });
        
        context(@"saveInBackgroundUsingCurrentContextWithBlock:completion:errorHandler:", ^{
            
            context(@"should call", ^{
                __block BOOL completionBlockCalled = NO;
                __block BOOL errorBlockCalled = NO;
                
                afterEach(^{
                    completionBlockCalled = NO;
                    errorBlockCalled = NO;
                });
                
                it(@"completion block", ^{
                    [MagicalRecord saveInBackgroundUsingCurrentContextWithBlock:^(NSManagedObjectContext *localContext) {
                        [SingleEntityWithNoRelationships MR_createInContext:localContext];
                    } completion:^{
                        completionBlockCalled = YES;
                    } errorHandler:^(NSError *error) {
                        errorBlockCalled = YES;
                    }];
                    
                    [[expectFutureValue(@(completionBlockCalled)) shouldEventually] beTrue];
                    [[expectFutureValue(@(errorBlockCalled)) shouldEventually] beFalse];
                });
                
                it(@"error handler when there is an error", ^{
                    [MagicalRecord saveInBackgroundUsingCurrentContextWithBlock:^(NSManagedObjectContext *localContext) {
                        // Don't make any changes so that an error is triggered
                    } completion:^{
                        completionBlockCalled = YES;
                    } errorHandler:^(NSError *error) {
                        errorBlockCalled = YES;
                    }];
                    
                    [[expectFutureValue(@(completionBlockCalled)) shouldEventually] beFalse];
                    [[expectFutureValue(@(errorBlockCalled)) shouldEventually] beTrue];
                });
            });
            
            it(@"should save", ^{
                __block NSError *saveError;
                __block NSManagedObjectID *objectId;
                __block NSManagedObject *fetchedObject;
                
                [MagicalRecord saveInBackgroundUsingCurrentContextWithBlock:^(NSManagedObjectContext *localContext) {
                    NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];
                    
                    [[@([inserted hasChanges])should] beTrue];
                    
                    [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                    objectId = [inserted objectID];
                } completion:^{
                    [[objectId should] beNonNil];
                    
                    fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
                } errorHandler:^(NSError *error) {
                    saveError = error;
                }];
                
                [[expectFutureValue(objectId) shouldEventually] beNonNil];
                [[expectFutureValue(saveError) shouldEventually] beNil];
                [[expectFutureValue(fetchedObject) shouldEventually] beNonNil];
                [[expectFutureValue(@([fetchedObject hasChanges])) shouldEventually] beFalse];
            });
        });        
    });
    
#pragma clang diagnostic pop // ignored "-Wdeprecated-declarations"
    
});

SPEC_END
