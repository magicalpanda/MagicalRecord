//
//  NSManagedObjectContextHelperTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObjectContextHelperTests.h"
#import "SingleEntityWithNoRelationships.h";
@implementation NSManagedObjectContextHelperTests

- (void) setUp
{
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
}

- (void) tearDown
{
    [MagicalRecord cleanUp];
}

- (void) testCanCreateContextForCurrentThead
{
    NSManagedObjectContext *firstContext = [NSManagedObjectContext MR_contextForCurrentThread];
    NSManagedObjectContext *secondContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    assertThat(firstContext, is(equalTo(secondContext)));
}

- (void) testCanNotifyDefaultContextOnSave
{
    NSManagedObjectContext *testContext = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];

   assertThat([testContext parentContext], is(equalTo([NSManagedObjectContext MR_defaultContext])));
}

- (void) testThatSavedObjectsHavePermanentIDs
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    SingleEntityWithNoRelationships *entity = [SingleEntityWithNoRelationships MR_createInContext:context];
    assertThatBool([[entity objectID] isTemporaryID], equalToBool(YES));
    [context MR_saveOnlySelfAndWait];
    assertThatBool([[entity objectID] isTemporaryID], equalToBool(NO));
}


@end
