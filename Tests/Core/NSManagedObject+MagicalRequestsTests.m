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
    XCTAssertEqualObjects(testRequest.entityName, NSStringFromClass([SingleRelatedEntity class]));
}

- (void)testCanRequestFirstEntityWithPredicate
{
    NSPredicate *testPredicate = [NSPredicate predicateWithFormat:@"mappedStringAttribute = 'Test Predicate'"];
    NSFetchRequest *testRequest = [SingleRelatedEntity MR_requestFirstWithPredicate:testPredicate];

    XCTAssertEqual(testRequest.fetchLimit, (NSUInteger)1);
    XCTAssertEqualObjects(testRequest.predicate, [NSPredicate predicateWithFormat:@"mappedStringAttribute = 'Test Predicate'"]);
}

- (void)testCreateRequestForFirstEntity
{
    NSFetchRequest *testRequest = [SingleRelatedEntity MR_requestFirstByAttribute:@"mappedStringAttribute" withValue:@"Autumnal"];
    XCTAssertEqualObjects(testRequest.entityName, NSStringFromClass([SingleRelatedEntity class]));
    XCTAssertEqual(testRequest.fetchLimit, (NSUInteger)1);
    XCTAssertEqual(testRequest.fetchOffset, (NSUInteger)0);
    XCTAssertEqualObjects(testRequest.predicate, [NSPredicate predicateWithFormat:@"mappedStringAttribute = 'Autumnal'"]);
}

@end
