//
//  NSPersistentStoreCoordinatorHelperTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSPersistentStoreCoordinatorHelperTests.h"

@implementation NSPersistentStoreCoordinatorHelperTests

- (void) setUp
{
    NSURL *testStoreURL = [NSPersistentStore MR_urlForStoreName:@"TestStore.sqlite"];
    [[NSFileManager defaultManager] removeItemAtPath:[testStoreURL path] error:nil];
}

- (void) testCreateCoodinatorWithSqlitePersistentStore
{
    NSPersistentStoreCoordinator *testCoordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:@"TestStore.sqlite"];
    
    assertThatUnsignedInteger([[testCoordinator persistentStores] count], is(equalToUnsignedInteger(1)));

    NSPersistentStore *store = [[testCoordinator persistentStores] objectAtIndex:0];
    assertThat([store type], is(equalTo(NSSQLiteStoreType)));
}

- (void) testCreateCoordinatorWithInMemoryStore
{
    NSPersistentStoreCoordinator *testCoordinator = [NSPersistentStoreCoordinator MR_coordinatorWithInMemoryStore];

    assertThatUnsignedInteger([[testCoordinator persistentStores] count], is(equalToUnsignedInteger(1)));
    
    NSPersistentStore *store = [[testCoordinator persistentStores] objectAtIndex:0];
    assertThat([store type], is(equalTo(NSInMemoryStoreType)));
}

- (void) testCanAddAnInMemoryStoreToAnExistingCoordinator
{
    NSPersistentStoreCoordinator *testCoordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:@"TestStore.sqlite"];
    
    assertThatUnsignedInteger([[testCoordinator persistentStores] count], is(equalToUnsignedInteger(1)));
    
    NSPersistentStore *firstStore = [[testCoordinator persistentStores] objectAtIndex:0];
    assertThat([firstStore type], is(equalTo(NSSQLiteStoreType)));
    
    [testCoordinator MR_addInMemoryStore];
    
    assertThatUnsignedInteger([[testCoordinator persistentStores] count], is(equalToUnsignedInteger(2)));
    
    NSPersistentStore *secondStore = [[testCoordinator persistentStores] objectAtIndex:1];
    assertThat([secondStore type], is(equalTo(NSInMemoryStoreType)));
}

@end
