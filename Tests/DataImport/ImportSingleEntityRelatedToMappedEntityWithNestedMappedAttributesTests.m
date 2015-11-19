//
//  Created by Saul Mora on 8/16/11.
//  Copyright (c) 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordDataImportTestCase.h"
#import "SingleEntityRelatedToMappedEntityWithNestedMappedAttributes.h"
#import "MappedEntity.h"

@interface ImportSingleEntityRelatedToMappedEntityWithNestedMappedAttributesTests : MagicalRecordDataImportTestCase

@end

@implementation ImportSingleEntityRelatedToMappedEntityWithNestedMappedAttributesTests

- (void)testDataImport
{
    NSManagedObjectContext *stackContext = self.stack.context;
    SingleEntityRelatedToMappedEntityWithNestedMappedAttributes *entity = [SingleEntityRelatedToMappedEntityWithNestedMappedAttributes MR_importFromObject:self.testEntityData inContext:stackContext];
    XCTAssertNotNil(entity.mappedEntity);
    XCTAssertEqualObjects(entity.mappedEntity.mappedEntityID, @42);
    XCTAssertTrue([entity.mappedEntity.nestedAttribute containsString:@"nested value"]);
}

@end
