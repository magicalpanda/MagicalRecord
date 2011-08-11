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

- (void) setUpClass
{
    [NSManagedObjectModel setDefaultManagedObjectModel:[NSManagedObjectModel managedObjectModelNamed:@"TestModel.momd"]];
    [MagicalRecordHelpers setupCoreDataStackWithInMemoryStore];
    
    [self setupTestData];
    
    id singleEntity = [self dataFromJSONFixture];
    
    self.testEntity = [SingleEntityRelatedToMappedEntityUsingDefaults MR_importFromDictionary:singleEntity];
}

- (void) tearDownClass
{
    [MagicalRecordHelpers cleanUp];
}

- (void) testImportMappedEntityViaToOneRelationship
{
    
}

@end
