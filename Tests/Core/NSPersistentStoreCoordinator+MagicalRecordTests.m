//
//  Created by Tony Arnold on 25/03/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordTestBase.h"

@interface NSPersistentStoreCoordinatorMagicalRecordTests : MagicalRecordTestBase

@property(readwrite, nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation NSPersistentStoreCoordinatorMagicalRecordTests

- (void)setUp
{
    [super setUp];

    NSURL *testStoreURL = [NSPersistentStore MR_fileURLForStoreNameIfExistsOnDisk:@"TestStore.sqlite"];

    if (testStoreURL) {
        [[NSFileManager defaultManager] removeItemAtPath:[testStoreURL path] error:nil];
    }

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    self.model = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:bundle]];
}

- (void)testCreateCoodinatorWithSqlitePersistentStore
{
    NSPersistentStoreCoordinator *testCoordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:@"TestStore.sqlite" andModel:self.model withOptions:nil];

    expect(testCoordinator).toNot.beNil();

    NSUInteger persistentStoreCount = [[testCoordinator persistentStores] count];

    expect(persistentStoreCount).to.equal(1);

    NSPersistentStore *store = [[testCoordinator persistentStores] firstObject];
    NSString *storeType = [store type];

    expect(storeType).to.equal(NSSQLiteStoreType);

    expect([store MR_removePersistentStoreFiles]).to.beTruthy();
}

- (void)testCreateCoordinatorWithInMemoryStore
{
    NSPersistentStoreCoordinator *testCoordinator = [NSPersistentStoreCoordinator MR_coordinatorWithInMemoryStoreWithModel:self.model];

    expect(testCoordinator).toNot.beNil();

    NSUInteger persistentStoreCount = [[testCoordinator persistentStores] count];

    expect(persistentStoreCount).to.equal(1);

    NSPersistentStore *store = [[testCoordinator persistentStores] firstObject];
    NSString *storeType = [store type];

    expect(storeType).to.equal(NSInMemoryStoreType);
}

- (void)testCanAddAnInMemoryStoreToAnExistingCoordinator
{
    NSPersistentStoreCoordinator *testCoordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:@"TestStore.sqlite" andModel:self.model withOptions:nil];

    expect(testCoordinator).toNot.beNil();

    NSUInteger persistentStoreCount = [[testCoordinator persistentStores] count];

    expect(persistentStoreCount).to.equal(1);

    NSPersistentStore *firstStore = [[testCoordinator persistentStores] firstObject];
    NSString *firstStoreType = [firstStore type];

    expect(firstStoreType).to.equal(NSSQLiteStoreType);

    [testCoordinator MR_addInMemoryStoreWithOptions:nil];

    persistentStoreCount = [[testCoordinator persistentStores] count];

    expect(persistentStoreCount).to.equal(2);

    NSPersistentStore *secondStore = [[testCoordinator persistentStores] objectAtIndex:1];
    NSString *secondStoreType = [secondStore type];
    
    expect(secondStoreType).to.equal(NSInMemoryStoreType);

    expect([firstStore MR_removePersistentStoreFiles]).to.beTruthy();
}

@end
