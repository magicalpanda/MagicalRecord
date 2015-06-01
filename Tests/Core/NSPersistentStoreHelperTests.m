//
//  NSPersisentStoreHelperTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MagicalRecord/MagicalRecord.h>
#import "MagicalRecordTestHelpers.h"

@interface NSPersisentStoreHelperTests : XCTestCase

@end

@implementation NSPersisentStoreHelperTests

- (NSString *) applicationStorageDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
}

#if TARGET_OS_IPHONE

- (void) testDefaultStoreFolderForiOSDevicesIsTheApplicationSupportFolder
{
    NSString *applicationLibraryDirectory = [self applicationStorageDirectory];
    NSString *expectedStorePath = [applicationLibraryDirectory stringByAppendingPathComponent:kMagicalRecordDefaultStoreFileName];
    NSURL *expectedStoreUrl = [NSURL fileURLWithPath:expectedStorePath];
    NSURL *defaultStoreUrl = [NSPersistentStore MR_defaultLocalStoreUrl];
    
    XCTAssertEqualObjects(defaultStoreUrl, expectedStoreUrl, @"Store URL should be %@, actually is %@", [expectedStoreUrl absoluteString], [defaultStoreUrl absoluteString]);
}

- (void) testCanFindAURLInTheLibraryForiOSForASpecifiedStoreName
{
    NSString *storeFileName = @"NotTheDefaultStoreName.storefile";
    NSString *applicationLibraryDirectory = [self applicationStorageDirectory];
    NSString *expectedStorePath = [applicationLibraryDirectory stringByAppendingPathComponent:storeFileName];

    BOOL fileWasCreated = [[NSFileManager defaultManager] createFileAtPath:expectedStorePath contents:[storeFileName dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    XCTAssertTrue(fileWasCreated, @"Expected file to have been created");

    NSURL *expectedFoundStoreUrl = [NSURL fileURLWithPath:expectedStorePath];
    NSURL *foundStoreUrl = [NSPersistentStore MR_urlForStoreName:storeFileName];
    
    XCTAssertEqualObjects(foundStoreUrl, expectedFoundStoreUrl, @"Found store URL should be %@, actually is %@", [expectedFoundStoreUrl absoluteString], [foundStoreUrl absoluteString]);

    [MagicalRecordTestHelpers removeStoreFilesForStoreAtURL:[NSURL fileURLWithPath:expectedStorePath]];
}

#else

- (void) testDefaultStoreFolderForMacIsTheApplicationSupportDirectory
{
    NSString *applicationSupportDirectory = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    NSString *expectedStorePath = [applicationSupportDirectory stringByAppendingPathComponent:kMagicalRecordDefaultStoreFileName];
    NSURL *expectedStoreUrl = [NSURL fileURLWithPath:expectedStorePath];
    NSURL *defaultStoreUrl = [NSPersistentStore MR_defaultLocalStoreUrl];

    XCTAssertEqualObjects(defaultStoreUrl, expectedStoreUrl, @"Store URL should be %@, actually is %@", [expectedStoreUrl absoluteString], [defaultStoreUrl absoluteString]);
}

- (void) testCanFindAURLInTheApplicationSupportLibraryForMacForASpecifiedStoreName
{
    NSString *storeFileName = @"NotTheDefaultStoreName.storefile";
    NSString *applicationSupportDirectory = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    NSString *expectedStorePath = [applicationSupportDirectory stringByAppendingPathComponent:storeFileName];

    BOOL fileWasCreated = [[NSFileManager defaultManager] createFileAtPath:expectedStorePath contents:[storeFileName dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    XCTAssertTrue(fileWasCreated, @"Expected file to have been created");

    NSURL *expectedStoreUrl = [NSURL fileURLWithPath:expectedStorePath];
    NSURL *foundStoreUrl = [NSPersistentStore MR_urlForStoreName:storeFileName];
    
    XCTAssertEqualObjects(foundStoreUrl, expectedStoreUrl, @"Found store URL should be %@, actually is %@", [expectedStoreUrl absoluteString], [foundStoreUrl absoluteString]);

    [MagicalRecordTestHelpers removeStoreFilesForStoreAtURL:[NSURL fileURLWithPath:expectedStorePath]];
}

#endif

@end
