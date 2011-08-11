//
//  ImportSingleEntityWithRelatedEntitiesTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/23/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "SingleRelatedEntity.h"
#import "AbstractRelatedEntity.h"
#import "ConcreteRelatedEntity.h"
#import "MappedEntity.h"

@interface ImportSingleRelatedEntityTests : GHTestCase

@property (nonatomic, retain) SingleRelatedEntity *testEntity;

@end

@implementation ImportSingleRelatedEntityTests

@synthesize testEntity;

- (void) setupTestData
{
    NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
    
    MappedEntity *testMappedEntity = [MappedEntity createInContext:context];
    testMappedEntity.testMappedEntityIDValue = 42;
    testMappedEntity.sampleAttribute = @"This attribute created as part of the test case setup";
    
    [context save];
}

- (void) setUpClass
{
    [NSManagedObjectModel setDefaultManagedObjectModel:[NSManagedObjectModel managedObjectModelNamed:@"TestModel.momd"]];
    [MagicalRecordHelpers setupCoreDataStackWithInMemoryStore];
    
//    NSURL *storeUrl = [NSPersistentStore MR_urlForStoreName:@"ImportSingleEntityTestStore.sqlite"];
//    [[NSFileManager defaultManager] removeItemAtURL:storeUrl error:nil];
//    
//    [MagicalRecordHelpers setupCoreDataStackWithStoreNamed:@"ImportSingleEntityTestStore.sqlite"];
    
    [self setupTestData];
    
    id singleEntity = [self dataFromJSONFixture];
    
    self.testEntity = [SingleRelatedEntity MR_importFromDictionary:singleEntity];
}

- (void) tearDownClass
{
    [MagicalRecordHelpers cleanUp];
}

- (void) testImportAnEntityRelatedToAbstractEntityViaToOneRelationshop
{
    assertThat(testEntity, is(notNilValue()));

    id testRelatedEntity = testEntity.testAbstractToOneRelationship;
    
    assertThat(testRelatedEntity, is(notNilValue()));
    assertThat([testRelatedEntity sampleBaseAttribute], containsString(@"BASE"));
}

- (void) testImportAnEntityRelatedToAbstractEntityViaToManyRelationship
{
    assertThat(testEntity, is(notNilValue()));
    assertThatInteger([testEntity.testAbstractToManyRelationship count], is(equalToInteger(2)));
    
    id testRelatedEntity = [testEntity.testAbstractToManyRelationship anyObject];
    
    assertThat(testRelatedEntity, is(notNilValue()));
    assertThat([testRelatedEntity sampleBaseAttribute], containsString(@"BASE"));
}


#pragma - Subentity tests


- (void) testImportAnEntityRelatedToAConcreteSubEntityViaToOneRelationship
{
    id testRelatedEntity = testEntity.testConcreteToOneRelationship;
    assertThat(testRelatedEntity, is(notNilValue()));
    
    assertThat([testRelatedEntity sampleBaseAttribute], containsString(@"BASE"));
    assertThat([testRelatedEntity sampleConcreteAttribute], containsString(@"DECENDANT"));
}

- (void) testImportAnEntityRelatedToASubEntityViaToManyRelationship
{
    assertThatInteger([testEntity.testConcreteToManyRelationship count], is(equalToInteger(3)));
    
    id testRelatedEntity = [testEntity.testConcreteToManyRelationship anyObject];
    assertThat(testRelatedEntity, is(notNilValue()));
    
    assertThat([testRelatedEntity sampleBaseAttribute], containsString(@"BASE"));
    assertThat([testRelatedEntity sampleConcreteAttribute], containsString(@"DECENDANT"));
}


//Test ordered to many




@end
