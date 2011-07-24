//
//  NSPersistentStoreCoordinatorHelperTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSPersistentStoreCoordinatorHelperTests.h"

@implementation NSPersistentStoreCoordinatorHelperTests

- (void) testCreateCoodinatorWithSqlitePersistentStore
{
    GHFail(@"Test Not Implemented");
}

- (void) testCreateCoordinatorWithInMemoryStore
{
    NSPersistentStoreCoordinator *testCoordinator = [NSPersistentStoreCoordinator coordinatorWithInMemoryStore];

    assertThatUnsignedInteger([[testCoordinator persistentStores] count], is(equalToUnsignedInteger(1)));
    
    NSPersistentStore *store = [[testCoordinator persistentStores] objectAtIndex:0];
    assertThat([store type], is(equalTo(NSInMemoryStoreType)));
}

- (void) testCanAddAnInMemoryStoreToAnExistingCoordinator
{
    GHFail(@"Test Not Implemented");   
}

- (void) testCanSetAUserSpecifiedErrroHandler
{
    GHFail(@"Test Not Implemented");
}

- (void) testLogsErrorsToLogger
{
    GHFail(@"Test Not Implemented");
}


@end
