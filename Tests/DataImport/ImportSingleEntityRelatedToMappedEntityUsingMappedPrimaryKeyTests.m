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

    expect(entity.mappedEntity).toNot.beNil();
    expect([SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey MR_numberOfEntitiesWithContext:self.stack.context]).to.equal(1);
    expect([MappedEntity MR_numberOfEntitiesWithContext:self.stack.context]).to.equal(1);
    expect(entity.mappedEntity.sampleAttribute).to.contain(@"sample json file");

    // Verify mapping in relationship description userinfo
    NSEntityDescription *mappedEntity = [entity entity];
    NSRelationshipDescription *testRelationship = [[mappedEntity propertiesByName] valueForKey:@"mappedEntity"];
    expect([[testRelationship userInfo] valueForKey:kMagicalRecordImportRelationshipMapKey]).to.equal(@"someRandomAttributeName");
}

- (void)testImportMappedEntityUsingPrimaryRelationshipKey
{
    NSManagedObjectContext *stackContext = self.stack.context;

    SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey *entity = [SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey MR_importFromObject:self.testEntityData inContext:stackContext];

    expect(entity.mappedEntity).toNot.beNil();
    expect([SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey MR_numberOfEntitiesWithContext:self.stack.context]).to.equal(1);
    expect([MappedEntity MR_numberOfEntitiesWithContext:self.stack.context]).to.equal(1);
    expect(entity.mappedEntity.sampleAttribute).to.contain(@"sample json file");
    expect(entity.mappedEntity.testMappedEntityID).to.equal(@42);

    // Verify mapping in relationship description userinfo
    NSEntityDescription *mappedEntity = [entity entity];
    NSRelationshipDescription *testRelationship = [[mappedEntity propertiesByName] valueForKey:@"mappedEntity"];
    expect([[testRelationship userInfo] valueForKey:kMagicalRecordImportRelationshipMapKey]).to.equal(@"someRandomAttributeName");
}

@end
