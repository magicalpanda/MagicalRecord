//
//  Created by Saul Mora on 8/11/11.
//  Copyright (c) 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordDataImportTestCase.h"
#import "MappedEntity.h"
#import "SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey.h"

@interface ImportSingleEntityRelatedToMappedEntityUsingMappedPrimaryKeyTests : MagicalRecordDataImportTestCase

@end

@implementation ImportSingleEntityRelatedToMappedEntityUsingMappedPrimaryKeyTests

- (void)testImportMappedEntityRelatedViaToOneRelationship
{
    NSManagedObjectContext *stackContext = self.stack.context;
    SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey *entity = [SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey MR_importFromObject:self.testEntityData inContext:stackContext];
    XCTAssertNotNil(entity.mappedEntity);
    XCTAssertEqualObjects([SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey MR_numberOfEntitiesWithContext:stackContext], @1);
    XCTAssertEqualObjects([MappedEntity MR_numberOfEntitiesWithContext:stackContext], @1);
    XCTAssertTrue([entity.mappedEntity.sampleAttribute containsString:@"sample json file"]);

    // Verify mapping in relationship description userinfo
    NSEntityDescription *mappedEntity = [entity entity];
    NSRelationshipDescription *testRelationship = [[mappedEntity propertiesByName] valueForKey:@"mappedEntity"];
    XCTAssertEqualObjects(testRelationship.userInfo[kMagicalRecordImportAttributeKeyMapKey], @"someRandomAttributeName");
}

- (void)testImportMappedEntityUsingPrimaryRelationshipKey
{
    NSManagedObjectContext *stackContext = self.stack.context;

    SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey *entity = [SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey MR_importFromObject:self.testEntityData inContext:stackContext];
    XCTAssertNotNil(entity.mappedEntity);
    XCTAssertEqualObjects([SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey MR_numberOfEntitiesWithContext:stackContext], @1);
    XCTAssertEqualObjects([MappedEntity MR_numberOfEntitiesWithContext:stackContext], @1);
    XCTAssertTrue([entity.mappedEntity.sampleAttribute containsString:@"sample json file"]);
    XCTAssertEqualObjects(entity.mappedEntity.testMappedEntityID, @42);

    // Verify mapping in relationship description userinfo
    NSEntityDescription *mappedEntity = [entity entity];
    NSRelationshipDescription *testRelationship = [[mappedEntity propertiesByName] valueForKey:@"mappedEntity"];
    XCTAssertEqualObjects(testRelationship.userInfo[kMagicalRecordImportRelationshipMapKey], @"someRandomAttributeName");

}

@end
