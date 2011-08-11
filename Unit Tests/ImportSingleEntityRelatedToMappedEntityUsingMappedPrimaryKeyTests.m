//
//  ImportSingleEntityRelatedToMappedEntityUsingMappedPrimaryKey.m
//  Magical Record
//
//  Created by Saul Mora on 8/11/11.
//  Copyright (c) 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MappedEntity.h"
#import "SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey.h"

@interface ImportSingleEntityRelatedToMappedEntityUsingMappedPrimaryKeyTests : GHTestCase

@property (nonatomic, retain) SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey *testEntity;

@end

@implementation ImportSingleEntityRelatedToMappedEntityUsingMappedPrimaryKeyTests

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
    
    [self setupTestData];
    
    id singleEntity = [self dataFromJSONFixture];
    
    self.testEntity = [SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey MR_importFromDictionary:singleEntity];
}

- (void) tearDownClass
{
    [MagicalRecordHelpers cleanUp];
}

- (void) testImportMappedEntityRelatedViaToOneRelationship
{
    id testRelatedEntity = testEntity.mappedEntity;
    
    //verify mapping in relationship description userinfo
    NSEntityDescription *mappedEntity = [testEntity entity];
    NSRelationshipDescription *testRelationship = [[mappedEntity propertiesByName] valueForKey:@"mappedEntity"];
    assertThat([[testRelationship userInfo] valueForKey:kMagicalRecordImportRelationshipMapKey], is(equalTo(@"someRandomAttributeName")));
    
    assertThat(testRelatedEntity, is(notNilValue()));
    assertThat([testRelatedEntity sampleAttribute], is(containsString(@"sample json file")));    
}

- (void) testImportMappedEntityUsingPrimaryRelationshipKey
{
    id testRelatedEntity = testEntity.mappedEntity;
    
    //verify mapping in relationship description userinfo
    NSEntityDescription *mappedEntity = [testEntity entity];
    NSRelationshipDescription *testRelationship = [[mappedEntity propertiesByName] valueForKey:@"mappedEntity"];
    assertThat([[testRelationship userInfo] valueForKey:kMagicalRecordImportRelationshipPrimaryKey], is(equalTo(@"testMappedEntityID")));
    

    assertThat([testRelatedEntity testMappedEntityID], is(equalToInteger(42)));
    assertThat([testRelatedEntity sampleAttribute], containsString(@"sample json file"));
}

@end
