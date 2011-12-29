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
    [MagicalRecordHelpers setupCoreDataStackWithInMemoryStore];
}

- (void) tearDown
{
    [MagicalRecordHelpers cleanUp];
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
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    
    assertThatBool([testEntity isDeleted], is(equalToBool(NO)));
    
    [testEntity MR_deleteEntity];
    
    assertThat(testEntity, is(notNilValue()));
    assertThatBool([testEntity isDeleted], is(equalToBool(YES)));
}

// Test Number of Entities

- (void) createSampleData:(NSInteger)numberOfTestEntitiesToCreate
{
    for (NSInteger i = 0; i < numberOfTestEntitiesToCreate; i++) 
    {
        SingleRelatedEntity *testEntity = [SingleRelatedEntity createEntity];
        testEntity.mappedStringAttribute = [NSString stringWithFormat:@"%d", i / 5];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_save];
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
