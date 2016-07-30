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

    expect(request.sortDescriptors[0].ascending).to.equal(YES);
    expect(request.sortDescriptors[1].ascending).to.equal(NO);
    expect(request.sortDescriptors[2].ascending).to.equal(YES);

    expect(request.sortDescriptors[0].key).to.equal(@"key1");
    expect(request.sortDescriptors[1].key).to.equal(@"key2");
    expect(request.sortDescriptors[2].key).to.equal(@"key3");
}

@end
