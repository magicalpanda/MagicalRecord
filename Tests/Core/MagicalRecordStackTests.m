//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordTestBase.h"

@interface MagicalRecordTests : MagicalRecordTestBase

@end

@implementation MagicalRecordTests

- (void)tearDown
{
    // Clean up any store files we created during the test
    MagicalRecordStack *defaultStack = [MagicalRecordStack defaultStack];

    if ((NO == [defaultStack.store.type isEqualToString:NSInMemoryStoreType]) && (nil != defaultStack.store))
    {
        XCTAssertTrue([defaultStack.store MR_removePersistentStoreFiles]);
    }

    [super tearDown];
}

- (void)assertDefaultStack
{
    MagicalRecordStack *defaultStack = [MagicalRecordStack defaultStack];

    XCTAssertNotNil(defaultStack.context);
    XCTAssertNotNil(defaultStack.model);
    XCTAssertNotNil(defaultStack.coordinator);
    XCTAssertNotNil(defaultStack.store);
}

- (void)testCreateDefaultCoreDataStack
{
    NSURL *testStoreURL = [NSPersistentStore MR_fileURLForStoreName:[MagicalRecord defaultStoreName]];
    XCTAssertNotNil(testStoreURL);

    NSString *testStorePath = testStoreURL.path;
    XCTAssertNotNil(testStorePath);

    [[NSFileManager defaultManager] removeItemAtPath:testStorePath error:nil];

    MagicalRecordStack *defaultStack = [SQLiteMagicalRecordStack stackWithStoreAtURL:testStoreURL];
    [defaultStack setModelFromClass:[self class]];
    [MagicalRecordStack setDefaultStack:defaultStack];

    [self assertDefaultStack];

    NSPersistentStore *defaultStore = defaultStack.store;
    XCTAssertEqual(defaultStore.type, NSSQLiteStoreType);
    XCTAssertTrue([defaultStore.URL.absoluteString hasSuffix:@".sqlite"]);
}

- (void)testCreateInMemoryCoreDataStack
{
    MagicalRecordStack *defaultStack = [InMemoryMagicalRecordStack stack];

    [MagicalRecordStack setDefaultStack:defaultStack];

    [self assertDefaultStack];

    NSPersistentStore *defaultStore = defaultStack.store;
    XCTAssertEqual(defaultStore.type, NSInMemoryStoreType);
}

- (void)testCreateSqliteStackWithCustomName
{
    NSString *testStoreName = @"MyTestDataStore.sqlite";

    NSURL *testStoreURL = [NSPersistentStore MR_fileURLForStoreName:testStoreName];
    NSString *testStorePath = testStoreURL.path;
    XCTAssertNotNil(testStorePath);

    [[NSFileManager defaultManager] removeItemAtPath:testStorePath error:nil];

    MagicalRecordStack *defaultStack = [SQLiteMagicalRecordStack stackWithStoreNamed:testStoreName];
    [MagicalRecordStack setDefaultStack:defaultStack];

    [self assertDefaultStack];

    NSPersistentStore *defaultStore = defaultStack.store;
    XCTAssertEqual(defaultStore.type, NSSQLiteStoreType);
    XCTAssertTrue([defaultStore.URL.absoluteString hasSuffix:testStoreName]);
}

@end
