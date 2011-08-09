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

@interface ImportSingleEntityWithRelatedEntitiesTests : GHTestCase

@property (nonatomic, strong) SingleRelatedEntity *testEntity;
@end

@implementation ImportSingleEntityWithRelatedEntitiesTests

@synthesize testEntity;

- (void) setupTestData
{
    MappedEntity *testMappedEntity = [MappedEntity createEntity];
    testMappedEntity.testMappedEntityIDValue = 42;
    testMappedEntity.sampleAttribute = @"This attribute created as part of the test case setup";
    
    [[NSManagedObjectContext defaultContext] save];
}

- (void) setUpClass
{
    [NSManagedObjectModel setDefaultManagedObjectModel:[NSManagedObjectModel managedObjectModelNamed:@"TestModel.momd"]];
    [MagicalRecordHelpers setupCoreDataStackWithInMemoryStore];
    
    [self setupTestData];
    
    id singleEntity = [FixtureHelpers dataFromJSONFixtureNamed:@"SingleRelatedEntity"];
    
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


// Test mapped relationship

- (void) testImportMappedEntityRelatedViaToOneRelationship
{
    id testRelatedEntity = testEntity.testMappedRelationship;
    
    //verify mapping in relationship description userinfo
    NSEntityDescription *mappedEntity = [testEntity entity];
    NSRelationshipDescription *testRelationship = [[mappedEntity propertiesByName] valueForKey:@"testMappedRelationship"];
    assertThat([[testRelationship userInfo] valueForKey:kMagicalRecordImportRelationshipMapKey], is(equalTo(@"TestJsonEntityName")));

    assertThat(testRelatedEntity, is(notNilValue()));
    assertThat([testRelatedEntity sampleAttribute], is(containsString(@"sampleAttributeValue")));    
}

- (void) testImportMappedEntityUsingPrimaryRelationshipKey
{
    id testRelatedEntity = testEntity.testMappedRelationship;
    
    //verify mapping in relationship description userinfo
    NSEntityDescription *mappedEntity = [testEntity entity];
    NSRelationshipDescription *testRelationship = [[mappedEntity propertiesByName] valueForKey:@"testMappedRelationship"];
    assertThat([[testRelationship userInfo] valueForKey:kMagicalRecordImportRelationshipPrimaryKey], is(equalTo(@"testMappedEntityID")));

    //    assertThat(testRelatedEntity, is(equalTo(testMappedEntity)));
    assertThat([testRelatedEntity testMappedEntityID], is(equalToInteger(42)));
    assertThat([testRelatedEntity sampleAttribute], containsString(@"test case setup"));
}

@end
