//
//  MagicalRecordHelperTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordTests.h"


@protocol MagicalRecordErrorHandlerProtocol <NSObject>

- (void) testHandlingError:(NSError *)error;

@end

@implementation MagicalRecordTests

- (void) setUp
{
    [MagicalRecord setDefaultModelNamed:@"TestModel.momd"];
}

- (void) tearDown
{
    [MagicalRecord cleanUp];
}

- (void) assertDefaultStack
{
    assertThat([NSManagedObjectContext MR_defaultContext], is(notNilValue()));
    assertThat([NSManagedObjectModel MR_defaultManagedObjectModel], is(notNilValue()));
    assertThat([NSPersistentStoreCoordinator MR_defaultStoreCoordinator], is(notNilValue()));
    assertThat([NSPersistentStore MR_defaultPersistentStore], is(notNilValue()));    
}

- (void) testCreateDefaultCoreDataStack
{
    NSURL *testStoreURL = [NSPersistentStore urlForStoreName:kMagicalRecordDefaultStoreFileName];
    [[NSFileManager defaultManager] removeItemAtPath:[testStoreURL path] error:nil];
    
    [MagicalRecord setupCoreDataStack];
    
    [self assertDefaultStack];
    
    NSPersistentStore *defaultStore = [NSPersistentStore MR_defaultPersistentStore];
    assertThat([[defaultStore URL] absoluteString], endsWith(@".sqlite"));
    assertThat([defaultStore type], is(equalTo(NSSQLiteStoreType)));
}

- (void) testCreateInMemoryCoreDataStack
{
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    
    [self assertDefaultStack];
    
    NSPersistentStore *defaultStore = [NSPersistentStore MR_defaultPersistentStore];
    assertThat([defaultStore type], is(equalTo(NSInMemoryStoreType)));
}

- (void) testCreateSqliteStackWithCustomName
{
    NSString *testStoreName = @"MyTestDataStore.sqlite";
    
    NSURL *testStoreURL = [NSPersistentStore MR_urlForStoreName:testStoreName];
    [[NSFileManager defaultManager] removeItemAtPath:[testStoreURL path] error:nil];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:testStoreName];
    
    [self assertDefaultStack];
    
    NSPersistentStore *defaultStore = [NSPersistentStore MR_defaultPersistentStore];
    assertThat([defaultStore type], is(equalTo(NSSQLiteStoreType)));
    assertThat([[defaultStore URL] absoluteString], endsWith(testStoreName));
}

- (void) customErrorHandler:(id)error;
{
}

- (void) testCanSetAUserSpecifiedErrorHandler
{
    [MagicalRecord setErrorHandlerTarget:self action:@selector(customErrorHandler:)];
    
    assertThat([MagicalRecord errorHandlerTarget], is(equalTo(self)));
    assertThat(NSStringFromSelector([MagicalRecord errorHandlerAction]), is(equalTo(NSStringFromSelector(@selector(customErrorHandler:)))));
}

- (void) magicalRecordErrorHandlerTest:(NSError *)error
{
    assertThat(error, is(notNilValue()));
    assertThat([error domain], is(equalTo(@"MRTests")));
    assertThatInteger([error code], is(equalToInteger(1000)));
    errorHandlerWasCalled_ = YES;
}

- (void) testUserSpecifiedErrorHandlersAreTriggeredOnError
{
    errorHandlerWasCalled_ = NO;
    [MagicalRecord setErrorHandlerTarget:self action:@selector(magicalRecordErrorHandlerTest:)];
    
    NSError *testError = [NSError errorWithDomain:@"MRTests" code:1000 userInfo:nil];
    [MagicalRecord handleErrors:testError];
    
    assertThatBool(errorHandlerWasCalled_, is(equalToBool(YES)));
}

- (void) testLogsErrorsToLogger
{
    NSError *testError = [NSError errorWithDomain:@"Cocoa" code:1000 userInfo:nil];
    id mockErrorHandler = [OCMockObject mockForProtocol:@protocol(MagicalRecordErrorHandlerProtocol)];
    [[mockErrorHandler expect] testHandlingError:testError];
    
    //    [[mockErrorHandler expect] performSelector:@selector(testErrorHandler:) withObject:[OCMArg any]];
    
    [MagicalRecord setErrorHandlerTarget:mockErrorHandler action:@selector(testHandlingError:)];
    [MagicalRecord handleErrors:testError];

    [mockErrorHandler verify];
}

@end
