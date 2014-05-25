//
//  Created by Tony Arnold on 25/03/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordTestBase.h"
#import "SingleRelatedEntity.h"

@interface NSManagedObjectMagicalAggregationTests : MagicalRecordTestBase

@end

@implementation NSManagedObjectMagicalAggregationTests

- (void)testCanSearchForNumberOfAllEntities
{
    NSManagedObjectContext *stackContext = self.stack.context;

    NSInteger numberOfTestEntitiesToCreate = 20;

    [self p_createSampleData:numberOfTestEntitiesToCreate inContext:stackContext];

    expect([SingleRelatedEntity MR_numberOfEntitiesWithContext:stackContext]).to.equal(numberOfTestEntitiesToCreate);
}

- (void)testCanSearchForNumberOfEntitiesWithPredicate
{
    NSManagedObjectContext *stackContext = self.stack.context;

    NSInteger numberOfTestEntitiesToCreate = 20;

    [self p_createSampleData:numberOfTestEntitiesToCreate inContext:stackContext];

    NSPredicate *searchFilter = [NSPredicate predicateWithFormat:@"mappedStringAttribute = '1'"];

    expect([SingleRelatedEntity MR_numberOfEntitiesWithPredicate:searchFilter inContext:stackContext]).to.equal(5);
}

#pragma mark - Private Methods

- (void)p_createSampleData:(NSInteger)numberOfTestEntitiesToCreate inContext:(NSManagedObjectContext *)context
{
    for (NSInteger i = 0; i < numberOfTestEntitiesToCreate; i++) {
        SingleRelatedEntity *testEntity = [SingleRelatedEntity MR_createEntityInContext:context];
        testEntity.mappedStringAttribute = [NSString stringWithFormat:@"%zd", i / 5];
    }
}

@end
