//
//  ImportSingleEntityRelatedToMappedEntityUsingMappedPrimaryKey.m
//  Magical Record
//
//  Created by Saul Mora on 8/11/11.
//  Copyright (c) 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MappedEntity.h"
#import "SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey.h"
#import "MagicalDataImportTestCase.h"

@interface ImportSingleEntityRelatedToMappedEntityUsingMappedPrimaryKeyTests : MagicalDataImportTestCase

@end

@implementation ImportSingleEntityRelatedToMappedEntityUsingMappedPrimaryKeyTests

- (void) setupTestData
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    
    MappedEntity *testMappedEntity = [MappedEntity createInContext:context];
    testMappedEntity.testMappedEntityIDValue = 42;
    testMappedEntity.sampleAttribute = @"This attribute created as part of the test case setup";
    
    [context MR_save];
}

- (Class) testEntityClass
{
    return [SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey class];
}

- (void) testImportMappedEntityRelatedViaToOneRelationship
{
    SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey *entity = [[self testEntityClass] MR_importFromDictionary:self.testEntityData];
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    
    id testRelatedEntity = entity.mappedEntity;
    
    //verify mapping in relationship description userinfo
    NSEntityDescription *mappedEntity = [entity entity];
    NSRelationshipDescription *testRelationship = [[mappedEntity propertiesByName] valueForKey:@"mappedEntity"];
    assertThat([[testRelationship userInfo] valueForKey:kMagicalRecordImportRelationshipMapKey], is(equalTo(@"someRandomAttributeName")));
    
    assertThat([SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey numberOfEntities], is(equalToInteger(1)));
    assertThat([MappedEntity numberOfEntities], is(equalToInteger(2)));
    assertThat(testRelatedEntity, is(notNilValue()));
    assertThat([testRelatedEntity sampleAttribute], is(containsString(@"sample json file")));    
}

- (void) testUpdateMappedEntityRelatedViaToOneRelationship
{
    SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey *entity = [SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey createEntity];
    [entity MR_updateValuesForKeysWithDictionary:self.testEntityData];
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    
    id testRelatedEntity = entity.mappedEntity;
    
    //verify mapping in relationship description userinfo
    NSEntityDescription *mappedEntity = [entity entity];
    NSRelationshipDescription *testRelationship = [[mappedEntity propertiesByName] valueForKey:@"mappedEntity"];
    assertThat([[testRelationship userInfo] valueForKey:kMagicalRecordImportRelationshipMapKey], is(equalTo(@"someRandomAttributeName")));
    
    assertThat([SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey numberOfEntities], is(equalToInteger(1)));
    assertThat([MappedEntity numberOfEntities], is(equalToInteger(1)));
    assertThat(testRelatedEntity, is(notNilValue()));
    assertThat([testRelatedEntity sampleAttribute], is(containsString(@"sample json file")));
}

- (void) testImportMappedEntityUsingPrimaryRelationshipKey
{
    SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey *entity = [[self testEntityClass] MR_importFromDictionary:self.testEntityData];
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    
    id testRelatedEntity = entity.mappedEntity;
    
    //verify mapping in relationship description userinfo
    NSEntityDescription *mappedEntity = [entity entity];
    NSRelationshipDescription *testRelationship = [[mappedEntity propertiesByName] valueForKey:@"mappedEntity"];
    assertThat([[testRelationship userInfo] valueForKey:kMagicalRecordImportRelationshipPrimaryKey], is(equalTo(@"testMappedEntityID")));
    
    assertThat([SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey numberOfEntities], is(equalToInteger(1)));
    assertThat([MappedEntity numberOfEntities], is(equalToInteger(2)));
    assertThat([testRelatedEntity testMappedEntityID], is(equalToInteger(42)));
    assertThat([testRelatedEntity sampleAttribute], containsString(@"sample json file"));    
}

- (void) testUpdateMappedEntityUsingPrimaryRelationshipKey
{
    SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey *entity = [SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey createEntity];
    [entity MR_updateValuesForKeysWithDictionary:self.testEntityData];
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    
    id testRelatedEntity = entity.mappedEntity;
    
    //verify mapping in relationship description userinfo
    NSEntityDescription *mappedEntity = [entity entity];
    NSRelationshipDescription *testRelationship = [[mappedEntity propertiesByName] valueForKey:@"mappedEntity"];
    assertThat([[testRelationship userInfo] valueForKey:kMagicalRecordImportRelationshipPrimaryKey], is(equalTo(@"testMappedEntityID")));
    
    assertThat([MappedEntity numberOfEntities], is(equalToInteger(1)));
    assertThat([testRelatedEntity testMappedEntityID], is(equalToInteger(42)));
    assertThat([testRelatedEntity sampleAttribute], containsString(@"sample json file"));
}


@end
