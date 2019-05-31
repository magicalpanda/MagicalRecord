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

        XCTAssertTrue(inserted.hasChanges);

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    }];

    XCTAssertNotNil(objectId);

    XCTestExpectation *rootSavingExpectation = [self expectationWithDescription:@"Root Saving Context Fetch Object"];
    NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];

    [rootSavingContext performBlock:^{
        NSError *fetchError;
        NSManagedObject *fetchedObject = [rootSavingContext existingObjectWithID:objectId error:&fetchError];

        XCTAssertNotNil(fetchedObject);
        XCTAssertNil(fetchError);
        XCTAssertFalse(fetchedObject.hasChanges);

        [rootSavingExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testSynchronousSaveActionMakesInsertedEntitiesAvailableInTheDefaultContext
{
    __block NSManagedObjectID *objectId;

    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        XCTAssertTrue(inserted.hasChanges);

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    }];

    XCTAssertNotNil(objectId);

    XCTestExpectation *rootSavingExpectation = [self expectationWithDescription:@"Root Saving Context Fetch Object"];
    NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];

    [rootSavingContext performBlock:^{
        NSError *fetchError;
        NSManagedObject *fetchedObject = [rootSavingContext existingObjectWithID:objectId error:&fetchError];

        XCTAssertNotNil(fetchedObject);
        XCTAssertNil(fetchError);
        XCTAssertFalse(fetchedObject.hasChanges);

        [rootSavingExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testSynchronousSaveActionMakesUpdatesToEntitiesAvailableToTheDefaultContext
{
    __block NSManagedObjectID *objectId;
    __block NSManagedObject *fetchedObject;

    NSString *const kTestAttributeKey = @"booleanTestAttribute";

    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        [inserted setValue:@YES forKey:kTestAttributeKey];

        XCTAssertTrue(inserted.hasChanges);

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    }];

    XCTestExpectation *rootSavingExpectation = [self expectationWithDescription:@"Root Saving Context Fetch Object"];
    NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];

    [rootSavingContext performBlock:^{
        fetchedObject = [rootSavingContext objectWithID:objectId];
        XCTAssertTrue([fetchedObject valueForKey:kTestAttributeKey]);

        [rootSavingExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0f handler:nil];

    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *changed = [localContext objectWithID:objectId];

        [changed setValue:@NO forKey:kTestAttributeKey];
    }];

    rootSavingExpectation = [self expectationWithDescription:@"Root Saving Context Fetch Object"];

    [rootSavingContext performBlock:^{
        fetchedObject = [rootSavingContext objectWithID:objectId];

        // Async since the merge to the main thread context after persistence
        XCTAssertEqualObjects([fetchedObject valueForKey:kTestAttributeKey], @NO);

        [rootSavingExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

#pragma mark - Asynchronous Saves

- (void)testAsynchronousSaveActionSaves
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Save Completed"];

    __block BOOL saveSuccessState = NO;
    __block NSError *saveError;
    __block NSManagedObjectID *objectId;

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        XCTAssertTrue(inserted.hasChanges);

        XCTAssertTrue([localContext obtainPermanentIDsForObjects:@[inserted] error:nil]);
        objectId = [inserted objectID];

        XCTAssertNotNil(objectId);
        XCTAssertFalse(objectId.isTemporaryID);
    } completion:^(BOOL contextDidSave, NSError *error) {
        saveSuccessState = contextDidSave;
        saveError = error;

        XCTAssertTrue(saveSuccessState);
        XCTAssertNil(saveError);

        NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];

        [rootSavingContext performBlockAndWait:^{
            NSError *existingObjectError;
            NSManagedObject *existingObject = [rootSavingContext existingObjectWithID:objectId error:&existingObjectError];

            XCTAssertNotNil(existingObject);
            XCTAssertFalse(existingObject.hasChanges);
            XCTAssertNil(existingObjectError);

            [expectation fulfill];
        }];
    }];

    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testAsynchronousSaveActionCallsCompletionBlockOnTheMainThread
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Save Completed"];

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];
    } completion:^(BOOL contextDidSave, NSError *error) {
        XCTAssertTrue(NSThread.isMainThread);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testAsynchronousSaveActionMakesInsertedEntitiesAvailableInTheDefaultContext
{
    __block NSManagedObjectID *objectId;

    XCTestExpectation *contextSavedExpectation = [self expectationWithDescription:@"Context Did Save"];

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        XCTAssertTrue(inserted.hasChanges);

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    } completion:^(BOOL contextDidSave, NSError *error) {
        XCTAssertTrue(contextDidSave);

        NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];

        [rootSavingContext performBlock:^{
            NSManagedObject *fetchedObject = [rootSavingContext objectWithID:objectId];
            XCTAssertNotNil(fetchedObject);
            XCTAssertFalse(fetchedObject.hasChanges);

            [contextSavedExpectation fulfill];
        }];
    }];

    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testAsynchronousSaveActionMakesUpdatesToEntitiesAvailableToTheDefaultContext
{
    __block NSManagedObjectID *objectId;
    __block NSManagedObject *fetchedObject;

    NSString *const kTestAttributeKey = @"booleanTestAttribute";

    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        [inserted setValue:@YES forKey:kTestAttributeKey];

        XCTAssertTrue(inserted.hasChanges);

        [localContext obtainPermanentIDsForObjects:@[inserted] error:nil];
        objectId = [inserted objectID];
    }];

    NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];

    [rootSavingContext performBlockAndWait:^{
        fetchedObject = [[NSManagedObjectContext MR_rootSavingContext] objectWithID:objectId];
        XCTAssertTrue([fetchedObject valueForKey:kTestAttributeKey]);
    }];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for managed object context"];

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSManagedObject *changed = [localContext objectWithID:objectId];
        
        [changed setValue:@NO forKey:kTestAttributeKey];
    } completion:^(BOOL contextDidSave, NSError *error) {
        [rootSavingContext performBlock:^{
            fetchedObject = [rootSavingContext objectWithID:objectId];
            XCTAssertNotNil(fetchedObject);
            XCTAssertEqualObjects([fetchedObject valueForKey:kTestAttributeKey], @NO);

            [expectation fulfill];
        }];
    }];

    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error) {
        MRLogError(@"Managed Object Context performBlock: timed out due to error: %@", [error localizedDescription]);
    }];

}

@end
