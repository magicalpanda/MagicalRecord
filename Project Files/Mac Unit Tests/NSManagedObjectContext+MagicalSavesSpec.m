#import "Kiwi.h"

// Project
#import "SingleEntityWithNoRelationships.h"

SPEC_BEGIN(NSManagedObjectContextMagicalSavesSpec)

describe(@"NSManagedObjectContext+MagicalSaves", ^{
	beforeEach(^{
		// Occurs before each enclosed "it" block
        [MagicalRecord setDefaultModelFromClass:[self class]];
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
	});

	afterEach(^{
		// Occurs after each enclosed "it" block
        [MagicalRecord cleanUp];
	});

    context(@"saving synchronously", ^{
        it(@"should save", ^{
            NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
            NSManagedObject        *inserted             = [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];

            [[@([inserted hasChanges]) should] beTrue];

            [managedObjectContext obtainPermanentIDsForObjects:@[inserted] error:nil];
            NSManagedObjectID *objectId = inserted.objectID;

            [managedObjectContext MR_saveToPersistentStoreAndWait];

            NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];

            [[fetchedObject should] beNonNil];
            [[@([fetchedObject hasChanges]) should] beFalse];
        });

    });

    context(@"saving asynchronously", ^{
        it(@"should call completion block", ^{
            __block BOOL completionBlockCalled = NO;

            NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext MR_contextForCurrentThread];

            [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];

            [managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                completionBlockCalled = YES;
            }];

            [[expectFutureValue(@(completionBlockCalled)) shouldEventually] beTrue];
        });

        it(@"should save", ^{
            __block NSManagedObjectID *objectId;
            NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
            NSManagedObject        *inserted             = [SingleEntityWithNoRelationships MR_createInContext:managedObjectContext];

            [[@([inserted hasChanges]) should] beTrue];

            [managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                [managedObjectContext obtainPermanentIDsForObjects:@[inserted] error:nil];
                objectId = inserted.objectID;
            }];

            [[expectFutureValue(objectId) shouldEventually] beNonNil];

            NSManagedObject *fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];

            [[expectFutureValue(fetchedObject) shouldEventually] beNonNil];
            [[expectFutureValue(@([fetchedObject hasChanges])) shouldEventually] beFalse];
        });
    });

});

SPEC_END
