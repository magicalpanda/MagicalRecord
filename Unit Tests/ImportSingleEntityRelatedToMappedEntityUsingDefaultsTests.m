//
//  ImportSingleEntityRelatedToMappedEntityUsingDefaults.m
//  Magical Record
//
//  Created by Saul Mora on 8/11/11.
//  Copyright (c) 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MappedEntity.h"
#import "SingleEntityRelatedToMappedEntityUsingDefaults.h"
#import "MagicalDataImportTestCase.h"

@interface ImportSingleEntityRelatedToMappedEntityUsingDefaultsTests : MagicalDataImportTestCase

@end

@implementation ImportSingleEntityRelatedToMappedEntityUsingDefaultsTests

-(Class) testEntityClass
{
    return [SingleEntityRelatedToMappedEntityUsingDefaults class];
}

- (void) setupTestData
{
    NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
    
    MappedEntity *testMappedEntity = [MappedEntity createInContext:context];
    testMappedEntity.mappedEntityIDValue = 42;
    testMappedEntity.sampleAttribute = @"This attribute created as part of the test case setup";
    
    [context save];
}

- (void) testImportMappedEntityViaToOneRelationship
{
    SingleEntityRelatedToMappedEntityUsingDefaults *entity = (SingleEntityRelatedToMappedEntityUsingDefaults *)self.testEntity;
    id testRelatedEntity = entity.mappedEntity;
    
    assertThat(testRelatedEntity, is(notNilValue()));
    assertThat([testRelatedEntity sampleAttribute], containsString(@"sample json file"));
    
    assertThat([MappedEntity numberOfEntities], is(equalToInteger(1)));
}

@end
