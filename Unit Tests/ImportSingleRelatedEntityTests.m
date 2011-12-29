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
#import "MagicalDataImportTestCase.h"

@interface ImportSingleRelatedEntityTests : MagicalDataImportTestCase

@property (nonatomic, retain) SingleRelatedEntity *singleTestEntity;

@end

@implementation ImportSingleRelatedEntityTests

@synthesize singleTestEntity = _singleTestEntity;;

- (void) setupTestData
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    
    MappedEntity *testMappedEntity = [MappedEntity createInContext:context];
    testMappedEntity.testMappedEntityIDValue = 42;
    testMappedEntity.sampleAttribute = @"This attribute created as part of the test case setup";
    
    [context MR_save];
}

- (void) setUp
{
    [super setUp];
    self.singleTestEntity = [SingleRelatedEntity MR_importFromDictionary:self.testEntityData];
    [[NSManagedObjectContext MR_defaultContext] MR_save];
}

- (void) testImportAnEntityRelatedToAbstractEntityViaToOneRelationshop
{
    assertThat(self.singleTestEntity, is(notNilValue()));

    id testRelatedEntity = self.singleTestEntity.testAbstractToOneRelationship;
    
    assertThat(testRelatedEntity, is(notNilValue()));
    assertThat([testRelatedEntity sampleBaseAttribute], containsString(@"BASE"));
    assertThatBool([testRelatedEntity respondsToSelector:@selector(sampleConcreteAttribute)], is(equalToBool(NO)));
}

- (void) testImportAnEntityRelatedToAbstractEntityViaToManyRelationship
{
    assertThat(self.singleTestEntity, is(notNilValue()));
    assertThatInteger([self.singleTestEntity.testAbstractToManyRelationship count], is(equalToInteger(2)));
    
    id testRelatedEntity = [self.singleTestEntity.testAbstractToManyRelationship anyObject];
    
    assertThat(testRelatedEntity, is(notNilValue()));
    assertThat([testRelatedEntity sampleBaseAttribute], containsString(@"BASE"));
    assertThatBool([testRelatedEntity respondsToSelector:@selector(sampleConcreteAttribute)], is(equalToBool(NO)));
}


#pragma mark - Subentity tests


- (void) testImportAnEntityRelatedToAConcreteSubEntityViaToOneRelationship
{
    id testRelatedEntity = self.singleTestEntity.testConcreteToOneRelationship;
    assertThat(testRelatedEntity, is(notNilValue()));
    
    assertThat([testRelatedEntity sampleBaseAttribute], containsString(@"BASE"));
    assertThat([testRelatedEntity sampleConcreteAttribute], containsString(@"DECENDANT"));
}

- (void) testImportAnEntityRelatedToASubEntityViaToManyRelationship
{
    assertThatInteger([self.singleTestEntity.testConcreteToManyRelationship count], is(equalToInteger(3)));
    
    id testRelatedEntity = [self.singleTestEntity.testConcreteToManyRelationship anyObject];
    assertThat(testRelatedEntity, is(notNilValue()));
    
    assertThat([testRelatedEntity sampleBaseAttribute], containsString(@"BASE"));
    assertThat([testRelatedEntity sampleConcreteAttribute], containsString(@"DECENDANT"));
}


//Test ordered to many




@end
