//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordTestBase.h"

#define EXP_SHORTHAND
#import "Expecta.h"

#import "MagicalRecord.h"

@interface MagicalRecordTests : MagicalRecordTestBase

@end

@implementation MagicalRecordTests

- (void)tearDown
{
    // Clean up any store files we created during the test
    MagicalRecordStack *defaultStack = [MagicalRecordStack defaultStack];

    if ((NO == [defaultStack.store.type isEqualToString:NSInMemoryStoreType]) && (nil != defaultStack.store)) {
        expect([defaultStack.store MR_removePersistentStoreFiles]).to.beTruthy();
    }

    [super tearDown];
}

- (void)assertDefaultStack
{
    MagicalRecordStack *defaultStack = [MagicalRecordStack defaultStack];

    expect(defaultStack.context).toNot.beNil();
    expect(defaultStack.model).toNot.beNil();
    expect(defaultStack.coordinator).toNot.beNil();
    expect(defaultStack.store).toNot.beNil();
}

- (void)testCreateDefaultCoreDataStack
{
    NSURL *testStoreURL = [NSPersistentStore MR_fileURLForStoreName:[MagicalRecord defaultStoreName]];

    expect(testStoreURL).toNot.beNil();

    [[NSFileManager defaultManager] removeItemAtPath:[testStoreURL path] error:nil];

    MagicalRecordStack *defaultStack = [SQLiteMagicalRecordStack stackWithStoreAtURL:testStoreURL];
    [defaultStack setModelFromClass:[self class]];
    [MagicalRecordStack setDefaultStack:defaultStack];

    [self assertDefaultStack];

    NSPersistentStore *defaultStore = defaultStack.store;

    expect([defaultStore type]).to.equal(NSSQLiteStoreType);
    expect([[defaultStore URL] absoluteString]).to.endWith(@".sqlite");
}

- (void)testCreateInMemoryCoreDataStack
{
    MagicalRecordStack *defaultStack = [InMemoryMagicalRecordStack stack];

    [MagicalRecordStack setDefaultStack:defaultStack];

    [self assertDefaultStack];

    NSPersistentStore *defaultStore = defaultStack.store;
    expect([defaultStore type]).to.equal(NSInMemoryStoreType);
}

- (void)testCreateSqliteStackWithCustomName
{
    NSString *testStoreName = @"MyTestDataStore.sqlite";

    NSURL *testStoreURL = [NSPersistentStore MR_fileURLForStoreName:testStoreName];

    [[NSFileManager defaultManager] removeItemAtPath:[testStoreURL path] error:nil];

    MagicalRecordStack *defaultStack = [SQLiteMagicalRecordStack stackWithStoreNamed:testStoreName];
    [MagicalRecordStack setDefaultStack:defaultStack];

    [self assertDefaultStack];

    NSPersistentStore *defaultStore = defaultStack.store;
    expect([defaultStore type]).to.equal(NSSQLiteStoreType);
    expect([[defaultStore URL] absoluteString]).to.endWith(testStoreName);
}

@end
