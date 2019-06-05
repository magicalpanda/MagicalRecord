//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>

#import <MagicalRecord/MagicalRecord.h>
#import "MagicalRecordTestHelpers.h"

@interface MagicalRecordTests : XCTestCase

@end


@protocol MagicalRecordErrorHandlerProtocol <NSObject>

- (void) testHandlingError:(NSError *)error;

@end

@implementation MagicalRecordTests
{
    BOOL errorHandlerWasCalled_;
}

- (void) assertDefaultStack
{
    XCTAssertNotNil([NSManagedObjectContext MR_defaultContext], @"Default context cannot be nil");
    XCTAssertNotNil([NSManagedObjectModel MR_defaultManagedObjectModel], @"Default managed object model cannot be nil");
    XCTAssertNotNil([NSPersistentStoreCoordinator MR_defaultStoreCoordinator], @"Default store coordinator cannot be nil");
    XCTAssertNotNil([NSPersistentStore MR_defaultPersistentStore], @"Default persistent store cannot be nil");
}

- (void) testCreateDefaultCoreDataStack
{
    [MagicalRecord setupCoreDataStack];
    
    [self assertDefaultStack];
    
    NSPersistentStore *defaultStore = [NSPersistentStore MR_defaultPersistentStore];
    NSURL *defaultStoreURL = defaultStore.URL;

    XCTAssertTrue([[defaultStoreURL absoluteString] hasSuffix:@".sqlite"], @"Default store URL must have an extension of 'sqlite'");
    XCTAssertEqual([defaultStore type], NSSQLiteStoreType, @"Default store should be of type NSSQLiteStoreType");

    [MagicalRecord cleanUp];
    [MagicalRecordTestHelpers removeStoreFilesForStoreAtURL:defaultStoreURL];
}

- (void) testCreateInMemoryCoreDataStack
{
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    
    [self assertDefaultStack];
    
    NSPersistentStore *defaultStore = [NSPersistentStore MR_defaultPersistentStore];
    XCTAssertEqual([defaultStore type], NSInMemoryStoreType, @"Default store should be of type NSInMemoryStoreType");

    [MagicalRecord cleanUp];
}

- (void) testCreateSqliteStackWithCustomName
{
    NSString *testStoreName = @"MyTestDataStore.sqlite";
    NSURL *testStoreURL = [NSPersistentStore MR_urlForStoreName:testStoreName];

    [MagicalRecord setupCoreDataStackWithStoreNamed:testStoreName];
    
    [self assertDefaultStack];
    
    NSPersistentStore *defaultStore = [NSPersistentStore MR_defaultPersistentStore];
    XCTAssertEqual([defaultStore type], NSSQLiteStoreType, @"Default store should be of type NSSQLiteStoreType");
    XCTAssertEqualObjects(defaultStore.URL, testStoreURL, @"Default store should have the same URL as the one that was passed to it");
    XCTAssertTrue([[[defaultStore URL] absoluteString] hasSuffix:testStoreName], @"Default store URL expects to have a suffix of '%@'", testStoreName);

    [MagicalRecord cleanUp];
    [MagicalRecordTestHelpers removeStoreFilesForStoreAtURL:testStoreURL];
}

- (void) customErrorHandler:(id)error
{
}

- (void) testCanSetAUserSpecifiedErrorHandler
{
    [MagicalRecord setErrorHandlerTarget:self action:@selector(customErrorHandler:)];

    XCTAssertEqualObjects([MagicalRecord errorHandlerTarget], self, @"Error handler should be self");
    XCTAssertEqualObjects(NSStringFromSelector([MagicalRecord errorHandlerAction]), NSStringFromSelector(@selector(customErrorHandler:)), @"Error handler action expected to be `customErrorHandler:`");
}

- (void) magicalRecordErrorHandlerTest:(NSError *)error
{
    XCTAssertNotNil(error, @"Expected a non-nil error object");
    XCTAssertEqualObjects([error domain], @"MRTests", @"Expected an error domain of 'MRTests'");
    XCTAssertEqual([error code], (NSInteger)1000, @"Expected an error code of '1000'");
    errorHandlerWasCalled_ = YES;
}

- (void) testUserSpecifiedErrorHandlersAreTriggeredOnError
{
    errorHandlerWasCalled_ = NO;
    [MagicalRecord setErrorHandlerTarget:self action:@selector(magicalRecordErrorHandlerTest:)];
    
    NSError *testError = [NSError errorWithDomain:@"MRTests" code:1000 userInfo:nil];
    [MagicalRecord handleErrors:testError];

    XCTAssertTrue(errorHandlerWasCalled_, @"Expected error handler to have been called");
}

@end
