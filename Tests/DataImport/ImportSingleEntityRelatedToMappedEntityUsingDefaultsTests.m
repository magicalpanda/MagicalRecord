//
//  Created by Saul Mora on 8/11/11.
//  Copyright (c) 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordDataImportTestCase.h"
#import "MappedEntity.h"
#import "SingleEntityRelatedToMappedEntityUsingDefaults.h"

@interface ImportSingleEntityRelatedToMappedEntityUsingDefaultsTests : MagicalRecordDataImportTestCase

@end

@implementation ImportSingleEntityRelatedToMappedEntityUsingDefaultsTests

- (void)testImportMappedEntityViaToOneRelationship
{
    NSManagedObjectContext *stackContext = self.stack.context;
    SingleEntityRelatedToMappedEntityUsingDefaults *entity = [SingleEntityRelatedToMappedEntityUsingDefaults MR_importFromObject:self.testEntityData inContext:stackContext];
    XCTAssertNotNil(entity.mappedEntity);
    XCTAssertTrue([entity.mappedEntity.sampleAttribute containsString:@"sample json file"]);
    XCTAssertEqualObjects([MappedEntity MR_numberOfEntitiesWithContext:stackContext], @1);
}

@end
