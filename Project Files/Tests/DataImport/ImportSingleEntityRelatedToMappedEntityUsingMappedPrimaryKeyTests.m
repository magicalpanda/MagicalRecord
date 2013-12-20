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
    
    MappedEntity *testMappedEntity = [MappedEntity MR_createInContext:context];
    testMappedEntity.testMappedEntityIDValue = 42;
    testMappedEntity.sampleAttribute = @"This attribute created as part of the test case setup";
    
    [context MR_saveToPersistentStoreAndWait];
}

- (Class) testEntityClass
{
    return [SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey class];
}

- (void) testImportMappedEntityRelatedViaToOneRelationship
{
    SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey *entity = [[self testEntityClass] MR_importFromObject:self.testEntityData];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    id testRelatedEntity = entity.mappedEntity;
    
    //verify mapping in relationship description userinfo
    NSEntityDescription *mappedEntity = [entity entity];
    NSRelationshipDescription *testRelationship = [[mappedEntity propertiesByName] valueForKey:@"mappedEntity"];
    XCTAssertEqualObjects([[testRelationship userInfo] valueForKey:kMagicalRecordImportRelationshipMapKey], @"someRandomAttributeName", @"Expected 'someRandomAttributeName' got '%@'", [[testRelationship userInfo] valueForKey:kMagicalRecordImportRelationshipMapKey]);

    XCTAssertEqual([[SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey MR_numberOfEntities] integerValue], 1, @"Expected count of 1 entity, got %@", [SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey MR_numberOfEntities]);

    XCTAssertEqual([[MappedEntity MR_numberOfEntities] integerValue], 1, @"Expected count of 1 entity, got %@", [MappedEntity MR_numberOfEntities]);

    XCTAssertNotNil(testRelatedEntity, @"testRelatedEntity should not be nil");

    NSRange stringRange = [[testRelatedEntity sampleAttribute] rangeOfString:@"sample json file"];

    XCTAssertTrue(stringRange.length > 0, @"Did not find 'sample json file' in %@", [testRelatedEntity sampleAttribute]);
}

//- (void) testUpdateMappedEntityRelatedViaToOneRelationship
//{
//    SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey *entity = [SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey createEntity];
//    [entity MR_updateValuesForKeysWithObject:self.testEntityData];
//    [[NSManagedObjectContext MR_defaultContext] MR_save];
//    
//    id testRelatedEntity = entity.mappedEntity;
//    
//    //verify mapping in relationship description userinfo
//    NSEntityDescription *mappedEntity = [entity entity];
//    NSRelationshipDescription *testRelationship = [[mappedEntity propertiesByName] valueForKey:@"mappedEntity"];
//    assertThat([[testRelationship userInfo] valueForKey:kMagicalRecordImportRelationshipMapKey], is(equalTo(@"someRandomAttributeName")));
//    
//    assertThat([SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey numberOfEntities], is(equalToInteger(1)));
//    assertThat([MappedEntity numberOfEntities], is(equalToInteger(1)));
//    assertThat(testRelatedEntity, is(notNilValue()));
//    assertThat([testRelatedEntity sampleAttribute], is(containsString(@"sample json file")));
//}

- (void) testImportMappedEntityUsingPrimaryRelationshipKey
{
    SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey *entity = [[self testEntityClass] MR_importFromObject:self.testEntityData];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    id testRelatedEntity = entity.mappedEntity;
    
    //verify mapping in relationship description userinfo
    NSEntityDescription *mappedEntity = [entity entity];
    NSRelationshipDescription *testRelationship = [[mappedEntity propertiesByName] valueForKey:@"mappedEntity"];
    XCTAssertEqualObjects([[testRelationship userInfo] valueForKey:kMagicalRecordImportRelationshipMapKey], @"testMappedEntityID", @"Expected 'testMappedEntityID' got '%@'", [[testRelationship userInfo] valueForKey:kMagicalRecordImportRelationshipMapKey]);

    XCTAssertEqual([[SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey MR_numberOfEntities] integerValue], 1, @"Expected count of 1 entity, got %@", [SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey MR_numberOfEntities]);

    XCTAssertEqual([[MappedEntity MR_numberOfEntities] integerValue], 1, @"Expected count of 1 entity, got %@", [MappedEntity MR_numberOfEntities]);

    XCTAssertEqual([[testRelatedEntity testMappedEntityID] integerValue], 42, @"Expected testMappedEntityID to be '42', got '%@'", [testRelatedEntity testMappedEntityID]);

    XCTAssertNotNil(testRelatedEntity, @"testRelatedEntity should not be nil");

    NSRange stringRange = [[testRelatedEntity sampleAttribute] rangeOfString:@"sample json file"];

    XCTAssertTrue(stringRange.length > 0, @"Did not find 'sample json file' in %@", [testRelatedEntity sampleAttribute]);

}

//- (void) testUpdateMappedEntityUsingPrimaryRelationshipKey
//{
//    SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey *entity = [SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey createEntity];
//    [entity MR_updateValuesForKeysWithObject:self.testEntityData];
//    [[NSManagedObjectContext MR_defaultContext] MR_save];
//    
//    id testRelatedEntity = entity.mappedEntity;
//    
//    //verify mapping in relationship description userinfo
//    NSEntityDescription *mappedEntity = [entity entity];
//    NSRelationshipDescription *testRelationship = [[mappedEntity propertiesByName] valueForKey:@"mappedEntity"];
//    assertThat([[testRelationship userInfo] valueForKey:kMagicalRecordImportRelationshipLinkedByKey], is(equalTo(@"testMappedEntityID")));
//    
//    assertThat([MappedEntity numberOfEntities], is(equalToInteger(1)));
//    assertThat([testRelatedEntity testMappedEntityID], is(equalToInteger(42)));
//    assertThat([testRelatedEntity sampleAttribute], containsString(@"sample json file"));
//}


@end
