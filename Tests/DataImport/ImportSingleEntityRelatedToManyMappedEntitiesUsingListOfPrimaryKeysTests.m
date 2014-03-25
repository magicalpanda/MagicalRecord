//
//  Created by Saul Mora on 9/1/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordDataImportTestCase.h"
#import "SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey.h"
#import "MappedEntity.h"

@interface ImportSingleEntityRelatedToManyMappedEntitiesUsingListOfPrimaryKeysTests : MagicalRecordDataImportTestCase

@end

@implementation ImportSingleEntityRelatedToManyMappedEntitiesUsingListOfPrimaryKeysTests

- (void)setUp
{
    [super setUp];

    NSManagedObjectContext *currentStackContext = self.stack.context;

    MappedEntity *related = nil;

    for (NSInteger mappedEntityIndex = 0; mappedEntityIndex < 10; mappedEntityIndex++) {
        MappedEntity *testMappedEntity = [MappedEntity MR_createEntityInContext:currentStackContext];
        testMappedEntity.testMappedEntityID = @(mappedEntityIndex);
        testMappedEntity.sampleAttribute = [NSString stringWithFormat:@"test attribute %zd", mappedEntityIndex];
        related = testMappedEntity;
    }

    SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey *entity = [SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey MR_createEntityInContext:currentStackContext];
    entity.testPrimaryKey = @(84);
    [entity addMappedEntitiesObject:related];

    [currentStackContext MR_saveToPersistentStoreAndWait];

    expect(entity).toNot.beNil();
}

- (void)testDataImportUsingListOfPrimaryKeyIDs
{
    NSManagedObjectContext *stackContext = self.stack.context;

    SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey *testEntity = [SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey MR_importFromObject:self.testEntityData inContext:stackContext];

    expect(testEntity).toNot.beNil();
    expect([SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey MR_numberOfEntitiesWithContext:stackContext]).to.equal(1);
    expect([MappedEntity MR_numberOfEntitiesWithContext:stackContext]).to.equal(10);

    expect(testEntity.mappedEntities).to.haveCountOf(5);

    for (MappedEntity *relatedEntity in testEntity.mappedEntities) {
        expect(relatedEntity.sampleAttribute).to.beginWith(@"test attribute");
    }
}

@end
