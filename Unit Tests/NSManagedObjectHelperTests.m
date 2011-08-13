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
    [MagicalRecordHelpers setupCoreDataStackWithInMemoryStore];
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
    [[NSManagedObjectContext defaultContext] save];
    
    assertThatBool([testEntity isDeleted], is(equalToBool(NO)));
    
    [testEntity deleteEntity];
    
    assertThat(testEntity, is(notNilValue()));
    assertThatBool([testEntity isDeleted], is(equalToBool(YES)));
}

// Test Number of Entities

- (void) createSampleData:(NSInteger)numberOfTestEntitiesToCreate
{
    for (NSInteger i = 1; i < numberOfTestEntitiesToCreate; i++) 
    {
        SingleRelatedEntity *testEntity = [SingleRelatedEntity createEntity];
        testEntity.mappedStringAttribute = [NSString stringWithFormat:@"%d", i / 5];
    }
    
    [[NSManagedObjectContext defaultContext] save];
}

- (void) testCanSearchForNumberOfAllEntities
{
    NSInteger numberOfTestEntitiesToCreate = 20;
    [self createSampleData:numberOfTestEntitiesToCreate];
    
    assertThat([SingleRelatedEntity numberOfEntities], is(equalToInteger(numberOfTestEntitiesToCreate)));
}

- (void) testCanSearchForNumberOfAllUniqueEntities
{
    NSInteger numberOfTestEntitiesToCreate = 20;
    [self createSampleData:numberOfTestEntitiesToCreate];

    assertThat([SingleRelatedEntity numberOfUniqueEntities], is(equalToInteger(4)));
}

- (void) testCanSearchForNumberOfEntitesWithPredicate
{
    NSInteger numberOfTestEntitiesToCreate = 20;
    [self createSampleData:numberOfTestEntitiesToCreate];
    
    assertThat([SingleRelatedEntity numberOfEntitiesWithPredicate:[NSPredicate predicateWithFormat:@"mappedStringAttribute = 0"]], is(equalToInteger(1)));
}

- (void) testCanSearchForNumberOfUniqueEntitiesWithPredicate
{
    NSInteger numberOfTestEntitiesToCreate = 20;
    [self createSampleData:numberOfTestEntitiesToCreate];
    
    assertThat([SingleRelatedEntity numberOfEntitiesWithPredicate:[NSPredicate predicateWithFormat:@"mappedStringAttribute = 0"]], is(equalToInteger(4)));
}


@end
