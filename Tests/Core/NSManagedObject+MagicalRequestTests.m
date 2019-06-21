//
//  NSManagedObject+MagicalRequestTests.m
//  MagicalRecord
//
//  Created by Sam Dean on 30/07/2016.
//  Copyright © 2016 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordTestBase.h"

#import "NSManagedObject+MagicalRequests.h"

@interface NSManagedObject_MagicalRequestTests : MagicalRecordTestBase

@end

@implementation NSManagedObject_MagicalRequestTests

- (void)testThatAscendingParameterIsHonouredForMultipleKeys {
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];

    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];

    // Deliberately expect the default ascending value (YES) to be used for key3
    // (not the carried over NO from key2)
    NSFetchRequest *request = [NSManagedObject MR_requestAllSortedBy:@"key1:YES,key2:NO,key3"
                                                           ascending:YES
                                                       withPredicate:predicate
                                                           inContext:context];

    XCTAssertEqual(request.sortDescriptors[0].ascending, YES);
    XCTAssertEqual(request.sortDescriptors[1].ascending, NO);
    XCTAssertEqual(request.sortDescriptors[2].ascending, YES);

    XCTAssertEqualObjects(request.sortDescriptors[0].key, @"key1");
    XCTAssertEqualObjects(request.sortDescriptors[1].key, @"key2");
    XCTAssertEqualObjects(request.sortDescriptors[2].key, @"key3");
}

@end
