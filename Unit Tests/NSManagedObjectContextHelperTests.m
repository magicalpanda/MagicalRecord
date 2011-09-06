//
//  NSManagedObjectContextHelperTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObjectContextHelperTests.h"

@implementation NSManagedObjectContextHelperTests

- (void) testCanCreateContextForCurrentThead
{
    NSManagedObjectContext *firstContext = [NSManagedObjectContext contextForCurrentThread];
    NSManagedObjectContext *secondContext = [NSManagedObjectContext contextForCurrentThread];
    
    assertThat(firstContext, is(equalTo(secondContext)));
}

- (void) testCanNotifyDefaultContextOnSave
{
    NSManagedObjectContext *testContext = [NSManagedObjectContext contextThatNotifiesDefaultContextOnMainThread];

    assertThatBool(testContext.notifiesMainContextOnSave, is(equalToBool(YES)));
}


@end
