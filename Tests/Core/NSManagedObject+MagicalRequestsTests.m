//
//  Created by Tony Arnold on 25/03/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordTestBase.h"
#import "SingleRelatedEntity.h"

@interface NSManagedObject_MagicalRequestsTests : MagicalRecordTestBase

@end

@implementation NSManagedObject_MagicalRequestsTests

- (void)testCreateFetchRequestForEntity
{
    NSFetchRequest *testRequest = [SingleRelatedEntity MR_requestAll];

    expect([testRequest entityName]).to.equal(NSStringFromClass([SingleRelatedEntity class]));
}

- (void)testCanRequestFirstEntityWithPredicate
{
    NSPredicate *testPredicate = [NSPredicate predicateWithFormat:@"mappedStringAttribute = 'Test Predicate'"];
    NSFetchRequest *testRequest = [SingleRelatedEntity MR_requestFirstWithPredicate:testPredicate];

    expect([testRequest fetchLimit]).to.equal(1);
    expect([testRequest predicate]).to.equal([NSPredicate predicateWithFormat:@"mappedStringAttribute = 'Test Predicate'"]);
}

- (void)testCreateRequestForFirstEntity
{
    NSFetchRequest *testRequest = [SingleRelatedEntity MR_requestFirstByAttribute:@"mappedStringAttribute" withValue:nil];

    expect([testRequest entityName]).to.equal(NSStringFromClass([SingleRelatedEntity class]));
    expect([testRequest fetchLimit]).to.equal(1);
    expect([testRequest fetchOffset]).to.equal(0);
    expect([testRequest predicate]).to.equal([NSPredicate predicateWithFormat:@"mappedStringAttribute = nil"]);
}

@end
