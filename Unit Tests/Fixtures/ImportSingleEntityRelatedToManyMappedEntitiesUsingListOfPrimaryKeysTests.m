//
//  ImportSingleEntityRelatedToManyMappedEntitiesUsingListOfPrimaryKeysTests.m
//  Magical Record
//
//  Created by Saul Mora on 9/1/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalDataImportTestCase.h"
#import "MappedEntity.h"
#import "SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey.h"

@interface ImportSingleEntityRelatedToManyMappedEntitiesUsingListOfPrimaryKeysTests : MagicalDataImportTestCase

@end

@implementation ImportSingleEntityRelatedToManyMappedEntitiesUsingListOfPrimaryKeysTests

- (Class) testEntityClass
{
    return [SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey class];
}

- (void) setupTestData
{
    NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
    
    for (int i = 0; i < 10; i++) 
    {
        MappedEntity *testMappedEntity = [MappedEntity createInContext:context];
        testMappedEntity.testMappedEntityIDValue = i;
        testMappedEntity.sampleAttribute = @"This attribute created as part of the test case setup";
    }
    [context save];
}

- (void) testDataImport
{
    SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey *testEntity = (SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey *)self.testEntity;
    
    assertThat(testEntity.mappedEntities, hasCountOf(4));
}
@end
