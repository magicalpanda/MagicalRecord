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
    SingleEntityRelatedToMappedEntityWithSecondaryMappings *entity = [[self testEntityClass] MR_importFromDictionary:self.testEntityData];
    [[NSManagedObjectContext defaultContext] save];
    
    assertThat(entity, is(notNilValue()));
    assertThat([entity secondaryMappedAttribute], containsString(@"sample json file"));
}

@end
