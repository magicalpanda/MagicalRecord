//
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.

#import "MagicalRecordTestBase.h"

@interface NSPersistentStoreCoordinatorMagicalRecordTests : MagicalRecordTestBase

@property (readwrite, nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation NSPersistentStoreCoordinatorMagicalRecordTests

- (void)setUp
{
    [super setUp];

    NSURL *testStoreURL = [NSPersistentStore MR_fileURLForStoreNameIfExistsOnDisk:@"TestStore.sqlite"];
    NSString *testStorePath = testStoreURL.path;

    if (testStoreURL != nil && testStorePath != nil)
    {
        [[NSFileManager defaultManager] removeItemAtPath:testStorePath error:nil];
    }

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    self.model = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:bundle]];
}

- (void)testCreateCoodinatorWithSqlitePersistentStore
{
    NSPersistentStoreCoordinator *testCoordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:@"TestStore.sqlite" andModel:self.model withOptions:nil];
    XCTAssertNotNil(testCoordinator);
    XCTAssertEqual(testCoordinator.persistentStores.count, (NSUInteger)1);

    NSPersistentStore *store = [[testCoordinator persistentStores] firstObject];
    XCTAssertEqualObjects(store.type, NSSQLiteStoreType);
    XCTAssertTrue([store MR_removePersistentStoreFiles]);
}

- (void)testCreateCoordinatorWithInMemoryStore
{
    NSPersistentStoreCoordinator *testCoordinator = [NSPersistentStoreCoordinator MR_coordinatorWithInMemoryStoreWithModel:self.model];
    XCTAssertNotNil(testCoordinator);
    XCTAssertEqual(testCoordinator.persistentStores.count, (NSUInteger)1);

    NSPersistentStore *store = [[testCoordinator persistentStores] firstObject];
    XCTAssertEqualObjects(store.type, NSInMemoryStoreType);
}

- (void)testCanAddAnInMemoryStoreToAnExistingCoordinator
{
    NSPersistentStoreCoordinator *testCoordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:@"TestStore.sqlite" andModel:self.model withOptions:nil];
    XCTAssertNotNil(testCoordinator);
    XCTAssertEqual(testCoordinator.persistentStores.count, (NSUInteger)1);

    NSPersistentStore *firstStore = [testCoordinator persistentStores][ 0 ];
    XCTAssertEqualObjects(firstStore.type, NSSQLiteStoreType);

    [testCoordinator MR_addInMemoryStoreWithOptions:nil];
    XCTAssertEqual(testCoordinator.persistentStores.count, (NSUInteger)2);

    NSPersistentStore *secondStore = [testCoordinator persistentStores][ 1 ];
    XCTAssertEqualObjects(secondStore.type, NSInMemoryStoreType);

    XCTAssertTrue([firstStore MR_removePersistentStoreFiles]);
}

@end
