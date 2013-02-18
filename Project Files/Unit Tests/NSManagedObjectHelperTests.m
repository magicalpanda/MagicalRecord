//
//  NSManagedObjectHelperTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObjectHelperTests.h"
#import "SingleRelatedEntity.h"

@implementation NSManagedObjectHelperTests

- (void) setUpClass
{
    [NSManagedObjectModel MR_setDefaultManagedObjectModel:[NSManagedObjectModel MR_managedObjectModelNamed:@"TestModel.momd"]];   
}

- (void) setUp
{
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
}

- (void) tearDown
{
    [MagicalRecord cleanUp];
}

-(BOOL)shouldRunOnMainThread
{
    return YES;
}
//Test Request Creation

- (void) testCreateFetchRequestForEntity
{
    NSFetchRequest *testRequest = [SingleRelatedEntity requestAll];
    
    assertThat([[testRequest entity] name], is(equalTo(NSStringFromClass([SingleRelatedEntity class]))));
}

- (void) testCanRequestFirstEntityWithPredicate
{
    NSPredicate *testPredicate = [NSPredicate predicateWithFormat:@"mappedStringAttribute = 'Test Predicate'"];
    NSFetchRequest *testRequest = [SingleRelatedEntity requestFirstWithPredicate:testPredicate];

    assertThatInteger([testRequest fetchLimit], is(equalToInteger(1)));
    assertThat([testRequest predicate], is(equalTo([NSPredicate predicateWithFormat:@"mappedStringAttribute = 'Test Predicate'"])));
}

// Test return result set, all, first

- (void) testCreateRequestForFirstEntity
{
    NSFetchRequest *testRequest = [SingleRelatedEntity requestFirstByAttribute:@"mappedStringAttribute" withValue:nil];
    
    assertThat([[testRequest entity] name], is(equalTo(NSStringFromClass([SingleRelatedEntity class]))));
    assertThatInteger([testRequest fetchLimit], is(equalToInteger(1)));
    assertThatInteger([testRequest fetchOffset], is(equalToInteger(0)));
    assertThat([testRequest predicate], is(equalTo([NSPredicate predicateWithFormat:@"mappedStringAttribute = nil"])));
}

- (void) testCanGetEntityDescriptionFromEntityClass
{
    NSEntityDescription *testDescription = [SingleRelatedEntity entityDescription];
    assertThat(testDescription, is(notNilValue()));
}

// Test Entity creation

- (void) testCanCreateEntityInstance
{
    id testEntity = [SingleRelatedEntity createEntity];
    
    assertThat(testEntity, is(notNilValue()));
}

// Test Entity Deletion

- (void) testCanDeleteEntityInstance
{
    id testEntity = [SingleRelatedEntity createEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    assertThatBool([testEntity isDeleted], is(equalToBool(NO)));
    
    [testEntity MR_deleteEntity];
    
    assertThat(testEntity, is(notNilValue()));
    assertThatBool([testEntity isDeleted], is(equalToBool(YES)));
}


- (void) testCanDeleteEntityInstanceInOtherContext
{
    NSManagedObjectContext * defaultContext = [NSManagedObjectContext MR_defaultContext];
    SingleRelatedEntity * testEntity = [SingleRelatedEntity MR_createEntity];
    [defaultContext MR_saveToPersistentStoreAndWait];

    assertThatBool([testEntity isDeleted], is(equalToBool(NO)));

    // Create another context and load the object in it
    NSManagedObjectContext * otherContext = [NSManagedObjectContext MR_contextWithParent:defaultContext];
    id otherEntity = [testEntity MR_inContext:otherContext];

    // Delete the object in the other context
    [testEntity MR_deleteInContext:otherContext];

    // The nested context entity should now be deleted
    assertThat(otherEntity, is(notNilValue()));
    assertThatBool([otherEntity isDeleted], is(equalToBool(YES)));

    // The default context entity should not be deleted
    assertThat(testEntity, is(notNilValue()));
    assertThatBool([testEntity isDeleted], is(equalToBool(NO)));

    // Save the nested context then reload the original object
    [otherContext MR_saveToPersistentStoreAndWait];
    id deletedEntity = [defaultContext existingObjectWithID:[testEntity objectID]
                                                      error:nil];

    assertThat(deletedEntity, is(nilValue()));
}

// Test Number of Entities

- (void) createSampleData:(NSInteger)numberOfTestEntitiesToCreate
{
    for (int i = 0; i < numberOfTestEntitiesToCreate; i++)
    {
        SingleRelatedEntity *testEntity = [SingleRelatedEntity createEntity];
        testEntity.mappedStringAttribute = [NSString stringWithFormat:@"%d", i / 5];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
}

- (void) testCanSearchForNumberOfAllEntities
{
    NSInteger numberOfTestEntitiesToCreate = 20;
    [self createSampleData:numberOfTestEntitiesToCreate];
    
    assertThat([SingleRelatedEntity numberOfEntities], is(equalToInteger(numberOfTestEntitiesToCreate)));
}

- (void) testCanSearchForNumberOfEntitiesWithPredicate
{
    NSInteger numberOfTestEntitiesToCreate = 20;
    [self createSampleData:numberOfTestEntitiesToCreate];

    NSPredicate *searchFilter = [NSPredicate predicateWithFormat:@"mappedStringAttribute = '1'"];
    assertThat([SingleRelatedEntity numberOfEntitiesWithPredicate:searchFilter], is(equalToInteger(5)));

}

@end
