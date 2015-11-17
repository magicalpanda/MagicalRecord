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

    for (NSInteger mappedEntityIndex = 0; mappedEntityIndex < 10; mappedEntityIndex++)
    {
        MappedEntity *testMappedEntity = [MappedEntity MR_createEntityInContext:currentStackContext];
        testMappedEntity.testMappedEntityID = @(mappedEntityIndex);
        testMappedEntity.sampleAttribute = [NSString stringWithFormat:@"test attribute %zd", mappedEntityIndex];
        related = testMappedEntity;
    }

    SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey *entity = [SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey MR_createEntityInContext:currentStackContext];
    entity.testPrimaryKey = @(84);
    [entity addMappedEntitiesObject:related];

    [currentStackContext MR_saveToPersistentStoreAndWait];

    XCTAssertNotNil(entity);
}

- (void)testDataImportUsingListOfPrimaryKeyIDs
{
    NSManagedObjectContext *stackContext = self.stack.context;

    SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey *testEntity = [SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey MR_importFromObject:self.testEntityData inContext:stackContext];

    XCTAssertNotNil(testEntity);
    XCTAssertEqualObjects([SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey MR_numberOfEntitiesWithContext:stackContext], @1);
    XCTAssertEqualObjects([MappedEntity MR_numberOfEntitiesWithContext:stackContext], @10);
    XCTAssertEqual(testEntity.mappedEntities.count, (NSUInteger)5);

    for (MappedEntity *relatedEntity in testEntity.mappedEntities)
    {
        XCTAssertTrue([relatedEntity.sampleAttribute hasPrefix:@"test attribute"]);
    }
}

@end
