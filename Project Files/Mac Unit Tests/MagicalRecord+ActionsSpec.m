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
            __block NSManagedObject   *fetchedObject;

            [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];

                [[@([inserted hasChanges]) should] beTrue];

                [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                objectId = [inserted objectID];
            }];

            [[objectId should] beNonNil];

            fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];

            [[fetchedObject should] beNonNil];
            [[@([fetchedObject hasChanges]) should] beFalse];
        });
    });

    context(@"asynchronous save action", ^{
        it(@"should call completion block", ^{
            __block BOOL completionBlockCalled = NO;

            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                [SingleEntityWithNoRelationships MR_createInContext:localContext];
            } completion:^(BOOL success, NSError *error) {
                // Ignore the success state — we only care that this block is executed
                completionBlockCalled = YES;
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
                fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];
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

                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];

                [[fetchedObject should] beNonNil];
                [[@([fetchedObject hasChanges]) should] beFalse];
            });
        });

        context(@"running asynchronously", ^{
            it(@"should call completion block", ^{
                __block BOOL completionBlockCalled = NO;

                [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
                    [SingleEntityWithNoRelationships MR_createInContext:localContext];
                } completion:^(BOOL success, NSError *error) {
                    // Ignore the success state — we only care that this block is executed
                    completionBlockCalled = YES;
                }];

                [[expectFutureValue(@(completionBlockCalled)) shouldEventually] beTrue];
            });

            it(@"should save", ^{
                __block NSManagedObjectID *objectId;

                [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
                    NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];

                    [[@([inserted hasChanges]) should] beTrue];

                    [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                    objectId = [inserted objectID];
                } completion:^(BOOL success, NSError *error) {
                    [[@(success) should] beTrue];
                }];

                [[expectFutureValue(objectId) shouldEventually] beNonNil];

                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];

                [[expectFutureValue(fetchedObject) shouldEventually] beNonNil];
                [[expectFutureValue(@([fetchedObject hasChanges])) shouldEventually] beFalse];
            });
        });
	});

    context(@"deprecated method", ^{
        context(@"simple save", ^{
            it(@"should save", ^{
                NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext MR_defaultContext];
                NSManagedObject        *inserted             = [SingleEntityWithNoRelationships MR_createEntity];

                [[@([inserted hasChanges]) should] beTrue];

                [managedObjectContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                NSManagedObjectID *objectId = [inserted objectID];

                [[objectId should] beNonNil];

                [[[managedObjectContext should] receive] MR_save];
                [managedObjectContext MR_save];

                NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];

                [[fetchedObject should] beNonNil];
                [[@([fetchedObject hasChanges]) should] beFalse];
            });
        });

        context(@"save action", ^{
            it(@"should save", ^{
                __block NSManagedObjectID *objectId;

                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];

                    [[@([inserted hasChanges]) should] beTrue];

                    [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                    objectId = [inserted objectID];
                }];

                [[objectId should] beNonNil];

                NSManagedObject   *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];
                
                [[objectId should] beNonNil];
                [[fetchedObject should] beNonNil];
                [[@([fetchedObject hasChanges]) should] beFalse];
            });
        });

        context(@"background save action", ^{
            it(@"should call completion block", ^{
                __block BOOL completionBlockCalled = NO;

                [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
                    [SingleEntityWithNoRelationships MR_createInContext:localContext];
                } completion:^{
                    // Ignore the success state — we only care that this block is executed
                    completionBlockCalled = YES;
                }];

                [[expectFutureValue(@(completionBlockCalled)) shouldEventually] beTrue];
            });

            it(@"should save", ^{
                __block NSManagedObjectID *objectId;
                __block NSManagedObject   *fetchedObject;

                [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
                    NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];

                    [[@([inserted hasChanges]) should] beTrue];

                    [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                    objectId = [inserted objectID];
                } completion:^{
                    [[objectId should] beNonNil];

                    fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];
                }];

                [[expectFutureValue(objectId) shouldEventually] beNonNil];
                [[expectFutureValue(fetchedObject) shouldEventually] beNonNil];
                [[expectFutureValue(@([fetchedObject hasChanges])) shouldEventually] beFalse];
            });
        });

        
    });
});

SPEC_END
