//
//  NSManagedObjectContextHelperTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObjectContextHelperTests.h"

@implementation NSManagedObjectContextHelperTests

- (void) setUp
{
    [MagicalRecordHelpers setupCoreDataStackWithInMemoryStore];
}

- (void) tearDown
{
    [MagicalRecordHelpers cleanUp];
}

- (void) testCanCreateContextForCurrentThead
{
    NSManagedObjectContext *firstContext = [NSManagedObjectContext MR_contextForCurrentThread];
    NSManagedObjectContext *secondContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    assertThat(firstContext, is(equalTo(secondContext)));
}

- (void) testCanNotifyDefaultContextOnSave
{
    NSManagedObjectContext *testContext = [NSManagedObjectContext MR_contextThatNotifiesDefaultContextOnMainThread];

    THREAD_ISOLATION_ENABLED(
    assertThatBool([testContext MR_notifiesMainContextOnSave], is(equalToBool(YES)));
                             )
    PRIVATE_QUEUES_ENABLED(
               assertThat([testContext parentContext], is(equalTo([NSManagedObjectContext MR_defaultContext])));
    )
}


@end
