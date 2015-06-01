//
//  NSPersistentStoreCoordinatorHelperTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MagicalRecord/MagicalRecord.h>
#import "MagicalRecordTestHelpers.h"

@interface NSPersistentStoreCoordinatorHelperTests : XCTestCase

@end

@implementation NSPersistentStoreCoordinatorHelperTests

- (void) setUp
{
    [super setUp];

    NSURL *testStoreURL = [NSPersistentStore MR_urlForStoreName:@"TestStore.sqlite"];
    [MagicalRecordTestHelpers removeStoreFilesForStoreAtURL:testStoreURL];
}

- (void) tearDown
{
    [super tearDown];

    NSURL *testStoreURL = [NSPersistentStore MR_urlForStoreName:@"TestStore.sqlite"];
    [MagicalRecordTestHelpers removeStoreFilesForStoreAtURL:testStoreURL];
}

- (void) testCreateCoodinatorWithSqlitePersistentStoreNamed
{
    NSPersistentStoreCoordinator *testCoordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:@"TestStore.sqlite"];

    NSUInteger persistentStoreCount = [[testCoordinator persistentStores] count];
    XCTAssertEqual(persistentStoreCount, (NSUInteger)1, @"Expected there to be 1 persistent store, sadly there are %tu", persistentStoreCount);

    NSPersistentStore *store = [[testCoordinator persistentStores] firstObject];
    NSString *storeType = [store type];
    XCTAssertEqualObjects(storeType, NSSQLiteStoreType, @"Store type should be NSSQLiteStoreType, instead is %@", storeType);
}

- (void) testCreateCoodinatorWithSqlitePersistentStoreAtURL
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    path = [path stringByAppendingPathComponent:@"TestStore.sqlite"];
    
    NSPersistentStoreCoordinator *testCoordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreAtURL:[NSURL fileURLWithPath:path]];
    
    NSUInteger persistentStoreCount = [[testCoordinator persistentStores] count];
    XCTAssertEqual(persistentStoreCount, (NSUInteger)1, @"Expected there to be 1 persistent store, sadly there are %tu", persistentStoreCount);
    
    NSPersistentStore *store = [[testCoordinator persistentStores] firstObject];
    NSString *storeType = [store type];
    XCTAssertEqualObjects(storeType, NSSQLiteStoreType, @"Store type should be NSSQLiteStoreType, instead is %@", storeType);
}

- (void) testCreateCoordinatorWithInMemoryStore
{
    NSPersistentStoreCoordinator *testCoordinator = [NSPersistentStoreCoordinator MR_coordinatorWithInMemoryStore];

    NSUInteger persistentStoreCount = [[testCoordinator persistentStores] count];
    XCTAssertEqual(persistentStoreCount, (NSUInteger)1, @"Expected there to be 1 persistent store, sadly there are %tu", persistentStoreCount);

    NSPersistentStore *store = [[testCoordinator persistentStores] firstObject];
    NSString *storeType = [store type];
    XCTAssertEqualObjects(storeType, NSInMemoryStoreType, @"Store type should be NSInMemoryStoreType, instead is %@", storeType);
}

- (void) testCanAddAnInMemoryStoreToAnExistingCoordinator
{
    NSPersistentStoreCoordinator *testCoordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:@"TestStore.sqlite"];

    NSUInteger persistentStoreCount = [[testCoordinator persistentStores] count];
    XCTAssertEqual(persistentStoreCount, (NSUInteger)1, @"Expected there to be 1 persistent store, sadly there are %tu", persistentStoreCount);

    NSPersistentStore *firstStore = [[testCoordinator persistentStores] firstObject];
    NSString *firstStoreType = [firstStore type];
    XCTAssertEqualObjects(firstStoreType, NSSQLiteStoreType, @"First store type should be NSSQLiteStoreType, instead is %@", firstStoreType);

    [testCoordinator MR_addInMemoryStore];
    
    persistentStoreCount = [[testCoordinator persistentStores] count];
    XCTAssertEqual(persistentStoreCount, (NSUInteger)2, @"Expected there to be 2 persistent store, sadly there are %tu", persistentStoreCount);

    NSPersistentStore *secondStore = [[testCoordinator persistentStores] objectAtIndex:1];
    NSString *secondStoreType = [secondStore type];
    XCTAssertEqualObjects(secondStoreType, NSInMemoryStoreType, @"Second store type should be NSInMemoryStoreType, instead is %@", secondStoreType);
}

#pragma mark - Private

- (void)removeAllStoreFiles
{
    NSURL *testStoreURL = [NSPersistentStore MR_urlForStoreName:@"TestStore.sqlite"];
    NSString *rawURL = [testStoreURL absoluteString];
    NSURL *shmSidecar = [NSURL URLWithString:[rawURL stringByAppendingString:@"-shm"]];
    NSURL *walSidecar = [NSURL URLWithString:[rawURL stringByAppendingString:@"-wal"]];

    [[NSFileManager defaultManager] removeItemAtURL:testStoreURL error:nil];
    [[NSFileManager defaultManager] removeItemAtURL:shmSidecar error:nil];
    [[NSFileManager defaultManager] removeItemAtURL:walSidecar error:nil];
}

@end
