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

- (void) setUpClass
{
    [NSManagedObjectModel setDefaultManagedObjectModel:[NSManagedObjectModel managedObjectModelNamed:@"TestModel.momd"]];
    [MagicalRecordHelpers setupCoreDataStackWithInMemoryStore];
    
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
    //    NSRelationshipDescription *relationshipInfo = [testRelatedEntity relationshipsByName];

    assertThat(testRelatedEntity, is(notNilValue()));
    assertThat([testRelatedEntity sampleAttribute], is(containsString(@"sampleAttributeValue")));    
}

@end
