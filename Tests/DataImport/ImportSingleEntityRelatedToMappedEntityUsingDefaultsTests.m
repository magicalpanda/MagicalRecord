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

    expect(entity.mappedEntity).toNot.beNil();
    expect(entity.mappedEntity.sampleAttribute).to.contain(@"sample json file");
    expect([MappedEntity MR_numberOfEntitiesWithContext:self.stack.context]).to.equal(1);
}

@end
