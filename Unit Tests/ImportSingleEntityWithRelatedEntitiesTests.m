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

@interface ImportSingleEntityWithRelatedEntitiesTests : GHTestCase

@property (nonatomic, strong) SingleRelatedEntity *testEntity;
@end

@implementation ImportSingleEntityWithRelatedEntitiesTests

@synthesize testEntity;

- (void) setUp
{
    [NSManagedObjectModel setDefaultManagedObjectModel:[NSManagedObjectModel managedObjectModelNamed:@"TestModel.momd"]];
    [MagicalRecordHelpers setupCoreDataStackWithInMemoryStore];
    
    id singleEntity = [FixtureHelpers dataFromJSONFixtureNamed:@"SingleRelatedEntity"];
    
    testEntity = [SingleRelatedEntity mr_importFromDictionary:singleEntity];
}

- (void) tearDown
{
    [MagicalRecordHelpers cleanUp];
}

- (void) testImportAnEntityRelatedToAnotherEntityWithAOneToOneRelationship
{
    assertThat(testEntity, is(notNilValue()));
    
    assertThat(testEntity.testRelationship, is(notNilValue()));
    assertThat(testEntity.testRelationship.sampleBaseAttribute, containsString(@"BASE"));
    assertThat(testEntity.testRelationship.mainTestEntity, is(equalTo(testEntity)));
}

- (void) testImportAnEntityRelatedToAnotherEntityWithAManyToOneRelationship
{
    GHFail(@"Test Not Implemented");    
}

- (void) testImportAnEntityRelatedToAnitherEntityWithAManyToManyRelationship
{
    GHFail(@"Test Not Implemented");
}

- (void) testImportAnEntityRelatedToASubEntityWithAOneToOneRelationship
{
    assertThat(testEntity.testRelationship.sampleConcreteAttribute, containsString(@"DECENDANT"));

}

- (void) testImportAnEntityRelatedToASubEntityWithAManyToOneRelationship
{
    GHFail(@"Test Not Implemented");   
}

- (void) testImportAnEntityRelatedToASubEntityWithAManyToManyRelationship
{
    GHFail(@"Test Not Implemented");
}


@end
