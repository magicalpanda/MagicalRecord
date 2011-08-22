//
//  ImportSingleEntityRelatedToMappedEntityWithSecondaryMappingsTests.m
//  Magical Record
//
//  Created by Saul Mora on 8/18/11.
//  Copyright (c) 2011 Magical Panda Software LLC. All rights reserved.
//
#import "MagicalDataImportTestCase.h"
#import "SingleEntityRelatedToMappedEntityWithSecondaryMappings.h"
#import "MappedEntity.h"

@interface ImportSingleEntityRelatedToMappedEntityWithSecondaryMappingsTests : MagicalDataImportTestCase

@end

@implementation ImportSingleEntityRelatedToMappedEntityWithSecondaryMappingsTests

- (Class) testEntityClass
{
    return [SingleEntityRelatedToMappedEntityWithSecondaryMappings class];
}

- (void) testImportMappedAttributeUsingSecondaryMappedKeyName
{
    SingleEntityRelatedToMappedEntityWithSecondaryMappings *entity = (SingleEntityRelatedToMappedEntityWithSecondaryMappings *)self.testEntity;

    assertThat(entity, is(notNilValue()));
    assertThat([entity secondaryMappedAttribute], containsString(@"sample json file"));
}

//- (void) testImportMappedEntityUsingThirdPriorityMappedKeyName
//{
//    SingleEntityRelatedToMappedEntityWithSecondaryMappings *entity = (SingleEntityRelatedToMappedEntityWithSecondaryMappings *)self.testEntity;
//    id testRelatedEntity = entity.mappedRelationship;
//    
//    assertThat(testRelatedEntity, is(notNilValue()));
//    assertThat([testRelatedEntity sampleAttribute], containsString(@"sample json file"));
//}

@end
