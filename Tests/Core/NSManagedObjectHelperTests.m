//
//  NSManagedObjectHelperTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordTestBase.h"
#import "SingleRelatedEntity.h"

@interface NSManagedObjectHelperTests : MagicalRecordTestBase

@end

@implementation NSManagedObjectHelperTests

- (void)testCreateFetchRequestForEntity
{
    NSFetchRequest *testRequest = [SingleRelatedEntity MR_requestAllInContext:[NSManagedObjectContext MR_defaultContext]];

    XCTAssertEqualObjects([[testRequest entity] name], NSStringFromClass([SingleRelatedEntity class]), @"Entity name should be the string representation of the entity's class");
}

- (void)testCanRequestFirstEntityWithPredicate
{
    NSPredicate *testPredicate = [NSPredicate predicateWithFormat:@"mappedStringAttribute = 'Test Predicate'"];
    NSFetchRequest *testRequest = [SingleRelatedEntity MR_requestFirstWithPredicate:testPredicate inContext:[NSManagedObjectContext MR_defaultContext]];

    XCTAssertEqual([testRequest fetchLimit], (NSUInteger)1, @"Fetch limit should be 1, got: %tu", [testRequest fetchLimit]);
    XCTAssertEqualObjects([testRequest predicate], testPredicate, @"Predicate objects should be equal");
}

- (void)testCreateRequestForFirstEntity
{
    NSFetchRequest *testRequest = [SingleRelatedEntity MR_requestFirstByAttribute:@"mappedStringAttribute" withValue:nil inContext:[NSManagedObjectContext MR_defaultContext]];

    XCTAssertEqualObjects([[testRequest entity] name], NSStringFromClass([SingleRelatedEntity class]), @"Entity name should be the string representation of the entity's class");
    XCTAssertEqual([testRequest fetchLimit], (NSUInteger)1, @"Fetch limit should be 1, got: %tu", [testRequest fetchLimit]);
    XCTAssertEqual([testRequest fetchOffset], (NSUInteger)0, @"Fetch offset should be 0, got: %tu", [testRequest fetchOffset]);
    XCTAssertEqualObjects([testRequest predicate], [NSPredicate predicateWithFormat:@"mappedStringAttribute = nil"], @"Predicate objects should be equal");
}

- (void)testCanGetEntityDescriptionFromEntityClass
{
    NSEntityDescription *testDescription = [SingleRelatedEntity MR_entityDescriptionInContext:[NSManagedObjectContext MR_defaultContext]];

    XCTAssertNotNil(testDescription, @"Entity description should not be nil");
}

- (void)testCanCreateEntityInstance
{
    [[NSManagedObjectContext MR_defaultContext] performBlockAndWait:^{
        id testEntity = [SingleRelatedEntity MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];

        XCTAssertNotNil(testEntity, @"Entity should not be nil");
    }];
}

- (void)testCanDeleteEntityInstance
{
    [[NSManagedObjectContext MR_defaultContext] performBlockAndWait:^{
        id testEntity = [SingleRelatedEntity MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];

        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

        XCTAssertFalse([testEntity isDeleted], @"Entity should not return true for isDeleted before MR_deleteEntity is sent");

        [testEntity MR_deleteEntity];

        XCTAssertNotNil(testEntity, @"Entity should not be nil after calling MR_deleteEntity");
        XCTAssertTrue([testEntity isDeleted], @"Entity should return true for isDeleted before MR_deleteEntity is sent");
    }];
}

- (void)testCanSearchForNumberOfAllEntities
{
    NSInteger numberOfTestEntitiesToCreate = 20;

    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];

    [context performBlockAndWait:^{
        [self p_createSampleData:numberOfTestEntitiesToCreate inContext:context];
        
        NSNumber *entityCount = [SingleRelatedEntity MR_numberOfEntitiesWithContext:context];
        XCTAssertEqualObjects(entityCount, @(numberOfTestEntitiesToCreate), @"Expected numberOfEntities to be %zd, got %@", numberOfTestEntitiesToCreate, entityCount);
    }];
}

- (void)testCanSearchForNumberOfEntitiesWithPredicate
{
    NSInteger numberOfTestEntitiesToCreate = 20;

    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];

    [context performBlockAndWait:^{
        [self p_createSampleData:numberOfTestEntitiesToCreate inContext:context];

        NSPredicate *searchFilter = [NSPredicate predicateWithFormat:@"mappedStringAttribute = '1'"];
        NSNumber *entityCount = [SingleRelatedEntity MR_numberOfEntitiesWithPredicate:searchFilter inContext:context];
        XCTAssertEqualObjects(entityCount, @5, @"Should return a count of 5, got %@", entityCount);
    }];
}

- (void)testRetrieveInstanceOfManagedObjectFromAnotherContextHasAPermanentObjectID
{
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
    __block NSManagedObject *insertedEntity;

    [defaultContext performBlockAndWait:^{
        insertedEntity = [SingleRelatedEntity MR_createEntityInContext:defaultContext];

        XCTAssertTrue(insertedEntity.objectID.isTemporaryID, @"Object ID should be temporary until saved");

        [defaultContext MR_saveToPersistentStoreAndWait];

        XCTAssertFalse(insertedEntity.objectID.isTemporaryID, @"Object ID should be permanent after save");
    }];

    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSManagedObject *localEntity = [insertedEntity MR_inContext:localContext];
        XCTAssertNotNil(localEntity, @"Object should not be nil");
        XCTAssertFalse([[localEntity objectID] isTemporaryID], @"Object ID should not be temporary after save");
    }];
}

- (void)testRetreiveInstanceOfManagedObjectContextWhichAlreadyHasPermamentObjectIDInOtherContext {
    
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];

    NSManagedObjectContext *context = [NSManagedObjectContext MR_newMainQueueContext];
    context.parentContext = [NSManagedObjectContext MR_defaultContext];

//    This is -> MR_obtainPermanentIDsBeforeSaving, if I uncomment it, object is getting permament id and works
//    [[NSNotificationCenter defaultCenter] addObserver:context
//                                             selector:@selector(MR_contextWillSave:)
//                                                 name:NSManagedObjectContextWillSaveNotification
//                                               object:context];
    
    __block NSManagedObject *insertedEntity;
    [context performBlockAndWait:^{
        SingleRelatedEntity *entity = [SingleRelatedEntity MR_createEntityInContext:context];
        entity.mappedStringAttribute = @"123";
        insertedEntity = entity;
        [context MR_saveOnlySelfAndWait];
    }];
    
//    XCTAssertTrue(insertedEntity.objectID.isTemporaryID, @"Object ID should be temporary");
    
    NSManagedObjectContext *anotherSavingContext = [NSManagedObjectContext MR_contextWithParent:defaultContext];
    
    __block NSManagedObject *insertedEntityInAnotherContext;
    [anotherSavingContext performBlockAndWait:^{
        insertedEntityInAnotherContext = [[SingleRelatedEntity MR_findByAttribute:@"mappedStringAttribute" withValue:@"123" inContext:anotherSavingContext] firstObject];
        
        [anotherSavingContext MR_saveOnlySelfAndWait];
    }];
    
    NSManagedObject *insertedEntityInDefaultContext = [insertedEntityInAnotherContext MR_inContext:defaultContext];
    
    XCTAssertTrue(insertedEntityInDefaultContext, @"Object should not be nil");    
    
}

- (void)testCanDeleteEntityInstanceInOtherContext
{
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];

    [defaultContext performBlockAndWait:^{
        NSManagedObject *testEntity = [SingleRelatedEntity MR_createEntityInContext:defaultContext];

        [defaultContext MR_saveToPersistentStoreAndWait];

        XCTAssertFalse([testEntity isDeleted], @"Entity should not be deleted at this point");

        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NSManagedObject *otherEntity = [testEntity MR_inContext:localContext];

            XCTAssertNotNil(otherEntity, @"Entity should not be nil");
            XCTAssertFalse([otherEntity isDeleted], @"Entity should not be deleted at this point");

            // Delete the object in the other context
            [testEntity MR_deleteEntityInContext:localContext];
            [localContext processPendingChanges];

            // The nested context entity should now be deleted
            XCTAssertTrue([localContext.deletedObjects containsObject:otherEntity], @"Entity should be listed as being deleted in the context");
            XCTAssertTrue([otherEntity isDeleted], @"Entity should now be deleted");
        }];
    }];
}

#pragma mark - Private Methods

- (void)p_createSampleData:(NSInteger)numberOfTestEntitiesToCreate inContext:(NSManagedObjectContext *)context
{
    [context performBlockAndWait:^{
        for (int i = 0; i < numberOfTestEntitiesToCreate; i++)
        {
            SingleRelatedEntity *testEntity = [SingleRelatedEntity MR_createEntityInContext:context];
            testEntity.mappedStringAttribute = [NSString stringWithFormat:@"%d", i / 5];
        }

        [context MR_saveOnlySelfAndWait];
    }];
}

@end
