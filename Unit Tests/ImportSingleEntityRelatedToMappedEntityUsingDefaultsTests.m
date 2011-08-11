//
//  ImportSingleEntityRelatedToMappedEntityUsingDefaults.m
//  Magical Record
//
//  Created by Saul Mora on 8/11/11.
//  Copyright (c) 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MappedEntity.h"
#import "SingleEntityRelatedToMappedEntityUsingDefaults.h"

@interface ImportSingleEntityRelatedToMappedEntityUsingDefaultsTests : GHTestCase

@property (nonatomic, retain) SingleEntityRelatedToMappedEntityUsingDefaults *testEntity;
@end

@implementation ImportSingleEntityRelatedToMappedEntityUsingDefaultsTests

@synthesize testEntity;

- (void) setupTestData
{
    NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
    
    MappedEntity *testMappedEntity = [MappedEntity createInContext:context];
    testMappedEntity.testMappedEntityIDValue = 42;
    testMappedEntity.sampleAttribute = @"This attribute created as part of the test case setup";
    
    [context save];
}

- (void) setUp
{
    [NSManagedObjectModel setDefaultManagedObjectModel:[NSManagedObjectModel managedObjectModelNamed:@"TestModel.momd"]];
    [MagicalRecordHelpers setupCoreDataStackWithInMemoryStore];
    
    [self setupTestData];
    
    id singleEntity = [self dataFromJSONFixture];
    
    self.testEntity = [SingleEntityRelatedToMappedEntityUsingDefaults MR_importFromDictionary:singleEntity];
}

- (void) tearDown
{
    [MagicalRecordHelpers cleanUp];
}

- (void) testImportMappedEntityViaToOneRelationship
{
    id testRelatedEntity = testEntity.mappedEntity;
    
    assertThat([MappedEntity numberOfEntities], is(equalToInteger(1)));
    
    assertThat(testRelatedEntity, is(notNilValue()));
    assertThat([testRelatedEntity sampleAttribute], containsString(@"sample json file"));
}

@end
