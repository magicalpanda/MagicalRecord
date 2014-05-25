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
    expect([EntityWithoutEntityNameMethod MR_entityName]).toNot.beNil();
    expect([EntityWithoutEntityNameMethod MR_entityName]).to.equal(NSStringFromClass([EntityWithoutEntityNameMethod class]));
}

- (void)testThatInternalEntityNameReturnsProvidedNameWhenEntityNameMethodIsImplemented
{
    expect([EntityWithoutEntityNameMethod MR_entityName]).toNot.beNil();
    expect([DifferentClassNameMapping MR_entityName]).toNot.equal(NSStringFromClass([DifferentClassNameMapping class]));
    expect([DifferentClassNameMapping MR_entityName]).to.equal([DifferentClassNameMapping entityName]);
}

- (void)testCanGetEntityDescriptionFromEntityClass
{
    NSManagedObjectContext *stackContext = self.stack.context;

    NSEntityDescription *testDescription = [SingleRelatedEntity MR_entityDescriptionInContext:stackContext];

    expect(testDescription).toNot.beNil();
}

- (void)testCanCreateEntityInstance
{
    NSManagedObjectContext *stackContext = self.stack.context;

    SingleRelatedEntity *testEntity = [SingleRelatedEntity MR_createEntityInContext:stackContext];

    expect(testEntity).toNot.beNil();
}

- (void)testCanDeleteEntityInstanceInCurrentContext
{
    MagicalRecordStack *currentStack = self.stack;
    NSManagedObjectContext *currentStackContext = currentStack.context;

    NSManagedObject *insertedEntity = [SingleRelatedEntity MR_createEntityInContext:currentStackContext];

    [currentStackContext MR_saveToPersistentStoreAndWait];

    expect([insertedEntity MR_isEntityDeleted]).to.beFalsy();

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *localEntity = [insertedEntity MR_inContext:localContext];

        expect([localEntity MR_deleteEntityInContext:localContext]).to.beTruthy();
    }];

    // The default context entity should now be deleted
    expect(insertedEntity).willNot.beNil();
    expect([insertedEntity MR_isEntityDeleted]).will.beTruthy();
}

- (void)testCanDeleteEntityInstanceInOtherContext
{
    MagicalRecordStack *currentStack = self.stack;
    NSManagedObjectContext *currentStackContext = currentStack.context;

    NSManagedObject *testEntity = [SingleRelatedEntity MR_createEntityInContext:currentStackContext];

    [currentStackContext MR_saveToPersistentStoreAndWait];

    expect([testEntity MR_isEntityDeleted]).to.beFalsy();

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *otherEntity = [testEntity MR_inContext:localContext];

        expect(otherEntity).toNot.beNil();
        expect([otherEntity MR_isEntityDeleted]).to.beFalsy();

        // Delete the object in the other context
        expect([testEntity MR_deleteEntityInContext:localContext]).to.beTruthy();

        // The nested context entity should now be deleted
        expect([otherEntity MR_isEntityDeleted]).to.beTruthy();
    }];

    // The default context entity should now be deleted
    expect(testEntity).willNot.beNil();
    expect([testEntity MR_isEntityDeleted]).will.beTruthy();
}

- (void)testRetrievingManagedObjectFromAnotherContextWithAPermanentObjectID
{
    MagicalRecordStack *currentStack = self.stack;
    NSManagedObjectContext *currentStackContext = currentStack.context;

    NSManagedObject *insertedEntity = [SingleRelatedEntity MR_createEntityInContext:currentStackContext];

    expect([[insertedEntity objectID] isTemporaryID]).to.beTruthy();

    [insertedEntity MR_obtainPermanentObjectID];

    expect([[insertedEntity objectID] isTemporaryID]).to.beFalsy();

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *localEntity = [insertedEntity MR_inContext:localContext];

        expect([[localEntity objectID] isTemporaryID]).to.beFalsy();
    }];

    expect([[insertedEntity objectID] isTemporaryID]).to.beFalsy();
}

- (void)testRetrievingManagedObjectFromAnotherContextWithATemporaryObjectID
{
    MagicalRecordStack *currentStack = self.stack;
    NSManagedObjectContext *currentStackContext = currentStack.context;

    NSManagedObject *insertedEntity = [SingleRelatedEntity MR_createEntityInContext:currentStackContext];

    expect([[insertedEntity objectID] isTemporaryID]).to.beTruthy();

    [currentStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSString *reason = [NSString stringWithFormat:@"Cannot load a temporary object '%@' [%@] across managed object contexts. Please obtain a permanent ID for this object first.", insertedEntity, [insertedEntity objectID]];

        expect(^{
            [insertedEntity MR_inContext:localContext];
        }).to.raiseWithReason(NSObjectInaccessibleException, reason);
    }];
}

@end
