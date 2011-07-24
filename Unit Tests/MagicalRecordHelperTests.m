//
//  MagicalRecordHelperTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordHelperTests.h"

@implementation MagicalRecordHelperTests

- (void) setUp
{
    [NSManagedObjectModel setDefaultManagedObjectModel:[NSManagedObjectModel managedObjectModelNamed:@"TestModel.momd"]];
}

- (void) tearDown
{
    [MagicalRecordHelpers cleanUp];
    //delete temp store
}

- (void) assertDefaultStack
{
    assertThat([NSManagedObjectContext defaultContext], is(notNilValue()));
    assertThat([NSManagedObjectModel defaultManagedObjectModel], is(notNilValue()));
    assertThat([NSPersistentStoreCoordinator defaultStoreCoordinator], is(notNilValue()));
    assertThat([NSPersistentStore defaultPersistentStore], is(notNilValue()));    
}

- (void) testCreateDefaultCoreDataStack
{
    [MagicalRecordHelpers setupCoreDataStack];
    
    [self assertDefaultStack];
    
    NSPersistentStore *defaultStore = [NSPersistentStore defaultPersistentStore];
    assertThat([[defaultStore URL] absoluteString], endsWith(kMagicalRecordDefaultStoreFileName));
    assertThat([defaultStore type], is(equalTo(NSSQLiteStoreType)));
}

- (void) testCreateInMemoryCoreDataStack
{
    [MagicalRecordHelpers setupCoreDataStackWithInMemoryStore];
    
    [self assertDefaultStack];
    
    NSPersistentStore *defaultStore = [NSPersistentStore defaultPersistentStore];
    assertThat([defaultStore type], is(equalTo(NSInMemoryStoreType)));
}

- (void) testCreateSqliteStackWithCustomName
{
    NSString *testStoreName = @"MyTestDataStore.sqlite";
    [MagicalRecordHelpers setupCoreDataStackWithStoreNamed:testStoreName];
    
    [self assertDefaultStack];
    
    NSPersistentStore *defaultStore = [NSPersistentStore defaultPersistentStore];
    assertThat([defaultStore type], is(equalTo(NSSQLiteStoreType)));
    assertThat([[defaultStore URL] absoluteString], endsWith(testStoreName));
}


- (void) testCanSetAUserSpecifiedErrorHandler
{
    GHFail(@"Test Not Implemented");
}

- (void) testUserSpecifiedErrorHandlersAreTriggeredOnError
{
    GHFail(@"Test Not Implemented");
}


- (void) testLogsErrorsToLogger
{
    GHFail(@"Test Not Implemented");
}

@end
