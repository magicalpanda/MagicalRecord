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
        NSManagedObject *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];
        XCTAssertTrue(insertedObject.hasChanges);

        [localContext obtainPermanentIDsForObjects:@[ insertedObject ] error:nil];
        objectId = [insertedObject objectID];
    }];

    XCTAssertNotNil(objectId);

    NSError *fetchError;
    NSManagedObject *fetchedObject = [currentContext existingObjectWithID:objectId error:&fetchError];
    XCTAssertNotNil(fetchedObject);
    XCTAssertNil(fetchError);
    XCTAssertFalse(fetchedObject.hasChanges);
}

- (void)testSynchronousSaveActionMakesInsertedEntitiesAvailableInTheDefaultContext
{
    MagicalRecordStack *currentStack = self.stack;
    NSManagedObjectContext *currentContext = currentStack.context;

    __block NSManagedObjectID *objectId;

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *inserted = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];
        XCTAssertTrue(inserted.hasChanges);

        [localContext obtainPermanentIDsForObjects:@[ inserted ] error:nil];
        objectId = [inserted objectID];
    }];

    XCTAssertNotNil(objectId);

    NSError *fetchError;
    NSManagedObject *fetchedObject = [currentContext existingObjectWithID:objectId error:&fetchError];
    XCTAssertNotNil(fetchedObject);
    XCTAssertNil(fetchError);
    XCTAssertFalse(fetchedObject.hasChanges);
}

- (void)testSynchronousSaveActionMakesUpdatesToEntitiesAvailableToTheDefaultContext
{
    MagicalRecordStack *currentStack = self.stack;
    NSManagedObjectContext *currentContext = currentStack.context;

    __block NSManagedObjectID *objectId;
    __block NSManagedObject *fetchedObject;

    NSString *const kTestAttributeKey = @"booleanTestAttribute";

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        [insertedObject setValue:@YES forKey:kTestAttributeKey];
        XCTAssertTrue(insertedObject.hasChanges);

        [localContext obtainPermanentIDsForObjects:@[ insertedObject ] error:nil];
        objectId = [insertedObject objectID];
    }];

    fetchedObject = [currentContext objectWithID:objectId];
    XCTAssertNotNil([fetchedObject valueForKey:kTestAttributeKey]);

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *changed = [localContext objectWithID:objectId];

        [changed setValue:@NO forKey:kTestAttributeKey];
    }];

    fetchedObject = [currentContext objectWithID:objectId];

    XCTAssertEqualObjects([fetchedObject valueForKey:kTestAttributeKey], @NO);
}

- (void)testSaveActionDoesNotAssignEntitiesWithoutAContextToAContext
{
    MagicalRecordStack *currentStack = self.stack;

    __block NSManagedObjectID *objectId;

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[SingleEntityWithNoRelationships MR_entityName] inManagedObjectContext:localContext];
        NSManagedObject *insertedObject = [[SingleEntityWithNoRelationships alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];

        XCTAssertFalse(insertedObject.hasChanges);
        XCTAssertNil(insertedObject.managedObjectContext);

        objectId = [insertedObject objectID];
    }];

    XCTAssertTrue(objectId.isTemporaryID);
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

    XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for asynchronous context to save"];

    [currentStack saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSManagedObject *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];
        XCTAssertTrue(insertedObject.hasChanges);

        [localContext obtainPermanentIDsForObjects:@[ insertedObject ] error:nil];
        objectId = [insertedObject objectID];
    }
        completion:^(BOOL success, NSError *error) {
            saveSuccessState = success;
            saveError = error;
            existingObject = [currentContext existingObjectWithID:objectId error:&existingObjectError];

            [expectation fulfill];
        }];

    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *_Nullable error) {
        if (error)
        {
            NSLog(@"Timeout Error: %@", error);
        }
    }];

    XCTAssertTrue(saveSuccessState);
    XCTAssertNil(saveError);
    XCTAssertNil(existingObjectError);
    XCTAssertNotNil(existingObject);
    XCTAssertFalse(existingObject.hasChanges);
}

- (void)testAsynchronousSaveActionMakesInsertedEntitiesAvailableInTheDefaultContext
{
    MagicalRecordStack *currentStack = self.stack;
    NSManagedObjectContext *currentContext = currentStack.context;

    __block BOOL saveSuccessState = NO;
    __block NSManagedObjectID *objectId;
    __block NSManagedObject *fetchedObject;

    XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for asynchronous context to save"];

    [currentStack saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSManagedObject *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];
        XCTAssertTrue(insertedObject.hasChanges);

        [localContext obtainPermanentIDsForObjects:@[ insertedObject ] error:nil];
        objectId = [insertedObject objectID];
    }
        completion:^(BOOL success, __unused NSError *error) {
            saveSuccessState = success;
            fetchedObject = [currentContext objectWithID:objectId];

            [expectation fulfill];
        }];

    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *_Nullable error) {
        if (error)
        {
            NSLog(@"Timeout Error: %@", error);
        }
    }];

    XCTAssertTrue(saveSuccessState);
    XCTAssertNotNil(fetchedObject);
    XCTAssertFalse(fetchedObject.hasChanges);
}

- (void)testAsynchronousSaveActionMakesUpdatesToEntitiesAvailableToTheDefaultContext
{
    MagicalRecordStack *currentStack = self.stack;
    NSManagedObjectContext *currentContext = currentStack.context;

    __block NSManagedObjectID *objectId;
    __block NSManagedObject *fetchedObject;

    NSString *const kTestAttributeKey = @"booleanTestAttribute";

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        [insertedObject setValue:@YES forKey:kTestAttributeKey];

        XCTAssertTrue(insertedObject.hasChanges);

        [localContext obtainPermanentIDsForObjects:@[ insertedObject ] error:nil];
        objectId = [insertedObject objectID];
    }];

    fetchedObject = [currentContext objectWithID:objectId];
    XCTAssertNotNil([fetchedObject valueForKey:kTestAttributeKey]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for asynchronous context to save"];

    [currentStack saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSManagedObject *changed = [localContext objectWithID:objectId];

        [changed setValue:@NO forKey:kTestAttributeKey];
    }
        completion:^(__unused BOOL success, __unused NSError *error) {
            fetchedObject = [currentContext objectWithID:objectId];

            [expectation fulfill];
        }];

    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *_Nullable error) {
        if (error)
        {
            NSLog(@"Timeout Error: %@", error);
        }
    }];

    XCTAssertEqualObjects([fetchedObject valueForKey:kTestAttributeKey], @NO);
}

- (void)testAsynchronousSaveActionPerformedOnBackgroundQueue
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for asynchronous context to save"];
    MagicalRecordStack *currentStack = self.stack;

    [currentStack saveWithBlock:^(__unused NSManagedObjectContext *localContext) {
        XCTAssertFalse([NSThread isMainThread]);
    }
        completion:^(__unused BOOL success, __unused NSError *error) {
            [expectation fulfill];
        }];

    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *_Nullable error) {
        if (error)
        {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

@end
