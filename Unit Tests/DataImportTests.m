//
//  DataImportTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "DataImportTests.h"
#import "SingleEntityWithNoRelationships.h"

@implementation DataImportTests

- (void) setUp
{
    [NSManagedObjectModel setDefaultManagedObjectModel:[NSManagedObjectModel managedObjectModelNamed:@"TestModel.momd"]];
    [MagicalRecordHelpers setupCoreDataStackWithInMemoryStore];
}

- (void) tearDown
{
    [MagicalRecordHelpers cleanUp];
}

- (void) testImportASingleEntity
{
    id singleEntity = [FixtureHelpers dataFromPListFixtureNamed:@"SingleEntityWithNoRelationships"];
    
    SingleEntityWithNoRelationships *testEntity = [SingleEntityWithNoRelationships mr_importFromDictionary:singleEntity];
    
    assertThat(testEntity, is(notNilValue()));
    
    assertThat(testEntity.integerTestAttribute, is(equalToInteger(42)));
    assertThat(testEntity.stringTestAttribute, is(equalTo(@"This is a test value")));
}

- (void) testImportAnEntityRelatedToAnotherEntityWithAOneToOneRelationship
{
    GHFail(@"Test Not Implemented");
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
    GHFail(@"Test Not Implemented");
}

- (void) testImportAnEntityRelatedToASubEntityWithAManyToOneRelationship
{
    GHFail(@"Test Not Implemented");   
}

- (void) testImportAnEntityRelatedToASubEntityWithAManyToManyRelationship
{
    GHFail(@"Test Not Implemented");
}

- (void) testImportStringAttributeToEntity
{
    GHFail(@"Test Not Implemented");
}

- (void) testImportInt16AttributeToEntity
{
    GHFail(@"Test Not Implemented");
}

- (void) testImportInt32AttributeToEntity
{
    GHFail(@"Test Not Implemented");
}

- (void) testImportInt64AttributeToEntity
{
    GHFail(@"Test Not Implemented");
}

- (void) testImportDecimalAttributeToEntity
{
    GHFail(@"Test Not Implemented");
}

- (void) testImportDoubleAttributeToEntity
{
    GHFail(@"Test Not Implemented");
}

- (void) testImportFloatAttributeToEntity
{
    GHFail(@"Test Not Implemented");   
}

- (void) testImportBooleanAttributeToEntity
{
    GHFail(@"Test Not Implemented");
}

- (void) testImportColorAttributeToEntity
{
    GHFail(@"Test Not Implemented");
}

- (void) testImportDateAttributeToEntity
{
    GHFail(@"Test Not Implemented");   
}

@end
