//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordTestBase.h"

@interface MagicalRecordTests : MagicalRecordTestBase

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
    NSURL *testStoreURL = [NSPersistentStore MR_urlForStoreName:kMagicalRecordDefaultStoreFileName];
    [[NSFileManager defaultManager] removeItemAtPath:[testStoreURL path] error:nil];
    
    [MagicalRecord setupCoreDataStack];
    
    [self assertDefaultStack];
    
    NSPersistentStore *defaultStore = [NSPersistentStore MR_defaultPersistentStore];

    XCTAssertTrue([[[defaultStore URL] absoluteString] hasSuffix:@".sqlite"], @"Default store URL must have an extension of 'sqlite'");
    XCTAssertEqual([defaultStore type], NSSQLiteStoreType, @"Default store should be of type NSSQLiteStoreType");
}

- (void) testCreateInMemoryCoreDataStack
{
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    
    [self assertDefaultStack];
    
    NSPersistentStore *defaultStore = [NSPersistentStore MR_defaultPersistentStore];
    XCTAssertEqual([defaultStore type], NSInMemoryStoreType, @"Default store should be of type NSInMemoryStoreType");
}

- (void) testCreateSqliteStackWithCustomName
{
    NSString *testStoreName = @"MyTestDataStore.sqlite";
    
    NSURL *testStoreURL = [NSPersistentStore MR_urlForStoreName:testStoreName];
    [[NSFileManager defaultManager] removeItemAtPath:[testStoreURL path] error:nil];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:testStoreName];
    
    [self assertDefaultStack];
    
    NSPersistentStore *defaultStore = [NSPersistentStore MR_defaultPersistentStore];
    XCTAssertEqual([defaultStore type], NSSQLiteStoreType, @"Default store should be of type NSSQLiteStoreType");
    XCTAssertTrue([[[defaultStore URL] absoluteString] hasSuffix:testStoreName], @"Default store URL expects to have a suffix of '%@'", testStoreName);
}

- (void) customErrorHandler:(id)error;
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

//- (void) testLogsErrorsToLogger
//{
//    NSError *testError = [NSError errorWithDomain:@"Cocoa" code:1000 userInfo:nil];
//    id mockErrorHandler = [OCMockObject mockForProtocol:@protocol(MagicalRecordErrorHandlerProtocol)];
//    [[mockErrorHandler expect] testHandlingError:testError];
//    
//    //    [[mockErrorHandler expect] performSelector:@selector(testErrorHandler:) withObject:[OCMArg any]];
//    
//    [MagicalRecord setErrorHandlerTarget:mockErrorHandler action:@selector(testHandlingError:)];
//    [MagicalRecord handleErrors:testError];
//
//    [mockErrorHandler verify];
//}

@end
