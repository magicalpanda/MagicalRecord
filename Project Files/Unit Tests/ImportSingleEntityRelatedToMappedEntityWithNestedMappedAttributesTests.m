//
//  ImportSingleEntityRelatedToMappedEntityWithNestedMappedAttributesTests.m
//  Magical Record
//
//  Created by Saul Mora on 8/16/11.
//  Copyright (c) 2011 Magical Panda Software LLC. All rights reserved.
//


#import "MagicalDataImportTestCase.h"
#import "MappedEntity.h"
#import "SingleEntityRelatedToMappedEntityWithNestedMappedAttributes.h"

@interface ImportSingleEntityRelatedToMappedEntityWithNestedMappedAttributesTests : MagicalDataImportTestCase

@end

@implementation ImportSingleEntityRelatedToMappedEntityWithNestedMappedAttributesTests

- (Class) testEntityClass
{
    return [SingleEntityRelatedToMappedEntityWithNestedMappedAttributes class];
}

- (void) testDataImport
{
    SingleEntityRelatedToMappedEntityWithNestedMappedAttributes *entity = [[self testEntityClass] MR_importFromDictionary:self.testEntityData];
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    
    assertThat(entity.mappedEntity, is(notNilValue()));
    assertThat(entity.mappedEntity.mappedEntityID, is(equalToInteger(42)));
    assertThat(entity.mappedEntity.nestedAttribute, containsString(@"nested value"));
}

@end
