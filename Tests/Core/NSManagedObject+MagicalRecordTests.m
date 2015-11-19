//
//  Created by Tony Arnold on 25/03/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordTestBase.h"
#import "SingleRelatedEntity.h"

#import "EntityWithoutEntityNameMethod.h"
#import "DifferentClassNameMapping.h"

@interface NSManagedObjectMagicalRecordTests : MagicalRecordTestBase

@end

@implementation NSManagedObjectMagicalRecordTests

- (void)testThatInternalEntityNameReturnsClassNameWhenEntityNameMethodIsNotImplemented
{
    NSString *entityName = [EntityWithoutEntityNameMethod MR_entityName];
    XCTAssertNotNil(entityName);
    XCTAssertEqualObjects(entityName, NSStringFromClass([EntityWithoutEntityNameMethod class]));
}

- (void)testThatInternalEntityNameReturnsProvidedNameWhenEntityNameMethodIsImplemented
{
    NSString *entityName = [DifferentClassNameMapping MR_entityName];
    XCTAssertNotNil(entityName);
    XCTAssertNotEqualObjects(entityName, NSStringFromClass([DifferentClassNameMapping class]));
    XCTAssertEqualObjects(entityName, [DifferentClassNameMapping entityName]);
}

- (void)testCanGetEntityDescriptionFromEntityClass
{
    NSManagedObjectContext *stackContext = self.stack.context;
    NSEntityDescription *testDescription = [SingleRelatedEntity MR_entityDescriptionInContext:stackContext];
    XCTAssertNotNil(testDescription);
}

- (void)testCanCreateEntityInstance
{
    NSManagedObjectContext *stackContext = self.stack.context;
    SingleRelatedEntity *testEntity = [SingleRelatedEntity MR_createEntityInContext:stackContext];
    XCTAssertNotNil(testEntity);
}

- (void)testCanDeleteEntityInstanceInCurrentContext
{
    MagicalRecordStack *currentStack = self.stack;
    NSManagedObjectContext *currentStackContext = currentStack.context;
    NSManagedObject *insertedEntity = [SingleRelatedEntity MR_createEntityInContext:currentStackContext];

    [currentStackContext MR_saveToPersistentStoreAndWait];
    XCTAssertFalse([insertedEntity MR_isEntityDeleted]);

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *localEntity = [insertedEntity MR_inContext:localContext];
        XCTAssertTrue([localEntity MR_deleteEntityInContext:localContext]);
    }];

    XCTAssertNotNil(insertedEntity);
    XCTAssertTrue([insertedEntity MR_isEntityDeleted]);
}

- (void)testCanDeleteEntityInstanceInOtherContext
{
    MagicalRecordStack *currentStack = self.stack;
    NSManagedObjectContext *currentStackContext = currentStack.context;
    NSManagedObject *testEntity = [SingleRelatedEntity MR_createEntityInContext:currentStackContext];

    [currentStackContext MR_saveToPersistentStoreAndWait];
    XCTAssertFalse([testEntity MR_isEntityDeleted]);

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *otherEntity = [testEntity MR_inContext:localContext];
        XCTAssertNotNil(otherEntity);
        XCTAssertFalse([otherEntity MR_isEntityDeleted]);

        // Delete the object in the other context
        XCTAssertTrue([testEntity MR_deleteEntityInContext:localContext]);

        // The nested context entity should now be deleted
        XCTAssertTrue([otherEntity MR_isEntityDeleted]);
    }];

    // The default context entity should now be deleted
    XCTAssertNotNil(testEntity);
    XCTAssertTrue([testEntity MR_isEntityDeleted]);
}

- (void)testRetrievingManagedObjectFromAnotherContextWithAPermanentObjectID
{
    MagicalRecordStack *currentStack = self.stack;
    NSManagedObjectContext *currentStackContext = currentStack.context;
    NSManagedObject *insertedEntity = [SingleRelatedEntity MR_createEntityInContext:currentStackContext];
    XCTAssertTrue(insertedEntity.objectID.isTemporaryID);

    [insertedEntity MR_obtainPermanentObjectID];
    XCTAssertFalse(insertedEntity.objectID.isTemporaryID);

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *localEntity = [insertedEntity MR_inContext:localContext];
        XCTAssertFalse(localEntity.objectID.isTemporaryID);
    }];

    XCTAssertFalse(insertedEntity.objectID.isTemporaryID);
}

- (void)testRetrievingManagedObjectFromAnotherContextWithATemporaryObjectID
{
    MagicalRecordStack *currentStack = self.stack;
    NSManagedObjectContext *currentStackContext = currentStack.context;
    NSManagedObject *insertedEntity = [SingleRelatedEntity MR_createEntityInContext:currentStackContext];
    XCTAssertTrue(insertedEntity.objectID.isTemporaryID);

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        XCTAssertThrowsSpecificNamed([insertedEntity MR_inContext:localContext], NSException, NSObjectInaccessibleException);
    }];
}

@end
