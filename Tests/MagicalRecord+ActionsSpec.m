#define EXP_SHORTHAND
#import "Expecta.h"
#import "Specta.h"

// Project
#import "MagicalRecord+Actions.h"
#import "SingleEntityWithNoRelationships.h"

SpecBegin(MagicalRecordActions)

describe(@"MagicalRecord", ^{		
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

    describe(@"synchronous save action", ^{
        it(@"should save", ^{
            __block NSManagedObjectID *objectId;
            
            [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];

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
        });
        
        it(@"should make inserted entities available to the default context", ^{
            __block NSManagedObjectID *objectId;
            
            [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];

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
        });
        
        it(@"should make updates to entities available to the default context", ^{
            __block NSManagedObjectID *objectId;
            __block NSManagedObject   *fetchedObject;
            
            NSString * const kTestAttributeKey = @"booleanTestAttribute";
            
            [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];
                
                [inserted setValue:@YES forKey:kTestAttributeKey];
                
                expect([inserted hasChanges]).to.beTruthy();

                [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                objectId = [inserted objectID];
            }];
            
            fetchedObject = [[NSManagedObjectContext MR_defaultContext] objectWithID:objectId];
            expect([fetchedObject valueForKey:kTestAttributeKey]).to.beTruthy();
            
            [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                NSManagedObject *changed = [localContext objectWithID:objectId];
                
                [changed setValue:@NO forKey:kTestAttributeKey];
            }];
            
            fetchedObject = [[NSManagedObjectContext MR_defaultContext] objectWithID:objectId];
            
            // Async since the merge to the main thread context after persistence
            expect([fetchedObject valueForKey:kTestAttributeKey]).will.beFalsy();
        });
    });
    
    describe(@"asynchronous save action", ^{
        it(@"should call completion block on the main thread", ^{
            __block BOOL completionBlockCalled = NO;
            __block BOOL completionBlockIsOnMainThread = NO;
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];

                expect(inserted).toNot.beNil();
            } completion:^(BOOL success, NSError *error) {
                // Ignore the success state — we only care that this block is executed on the main thread
                completionBlockCalled = YES;
                completionBlockIsOnMainThread = [NSThread isMainThread];
            }];

            expect(completionBlockCalled).will.beTruthy();
            expect(completionBlockIsOnMainThread).will.beTruthy();
        });

        it(@"should save", ^{
            __block BOOL               saveSuccessState = NO;
            __block NSManagedObjectID *objectId;
            __block NSManagedObject   *fetchedObject;
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];

                expect([inserted hasChanges]).to.beTruthy();
                
                [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                objectId = [inserted objectID];
            } completion:^(BOOL success, NSError *error) {
                saveSuccessState = success;
                fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectRegisteredForID:objectId];
            }];

            expect(saveSuccessState).will.beTruthy();
            expect(fetchedObject).willNot.beNil();
            expect([fetchedObject hasChanges]).will.beFalsy();
        });
        
        it(@"should make inserted entities available to the default context", ^{
            __block BOOL               saveSuccessState = NO;
            __block NSManagedObjectID *objectId;
            __block NSManagedObject   *fetchedObject;
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];
                
                expect([inserted hasChanges]).to.beTruthy();

                [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                objectId = [inserted objectID];
            } completion:^(BOOL success, NSError *error) {
                saveSuccessState = success;
                fetchedObject = [[NSManagedObjectContext MR_defaultContext] objectWithID:objectId];
            }];
            
            expect(saveSuccessState).will.beTruthy();
            expect(fetchedObject).willNot.beNil();
            expect([fetchedObject hasChanges]).will.beFalsy();
        });
        
        it(@"should make updates to entities available to the default context", ^{
            __block NSManagedObjectID *objectId;
            __block NSManagedObject   *fetchedObject;
            
            NSString * const kTestAttributeKey = @"booleanTestAttribute";
            
            [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];
                
                [inserted setValue:@YES forKey:kTestAttributeKey];
                
                expect([inserted hasChanges]).to.beTruthy();

                [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                objectId = [inserted objectID];
            }];
            
            fetchedObject = [[NSManagedObjectContext MR_defaultContext] objectWithID:objectId];
            expect([fetchedObject valueForKey:kTestAttributeKey]).to.beTruthy();
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                NSManagedObject *changed = [localContext objectWithID:objectId];
                
                [changed setValue:@NO forKey:kTestAttributeKey];
            } completion:^(BOOL success, NSError *error) {
                fetchedObject = [[NSManagedObjectContext MR_defaultContext] objectWithID:objectId];
            }];
            
            expect([fetchedObject valueForKey:kTestAttributeKey]).will.beFalsy();
        });
    });

	describe(@"current thread save action", ^{
        describe(@"running synchronously", ^{
            it(@"should save", ^{
                __block NSManagedObjectID *objectId;
                
                [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                    NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];
                    
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
            });
        });
        
        describe(@"running asynchronously", ^{
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

                expect(completionBlockCalled).will.beTruthy();
            });
            
            it(@"should save", ^{
                __block BOOL               saveSuccessState = NO;
                __block NSError           *saveError;
                __block NSManagedObjectID *objectId;
                
                [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
                    NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createInContext:localContext];
                    
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
            });
        });
	});
});

SpecEnd
