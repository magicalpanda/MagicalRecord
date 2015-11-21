//
//  Created by Tony Arnold on 25/03/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MagicalRecord/MagicalRecord.h>

#import "NSPersistentStore+MagicalRecordPrivate.h"

@interface NSPersistentStoreMagicalRecordTests : XCTestCase

@end

@implementation NSPersistentStoreMagicalRecordTests

- (void)testDefaultStoreFolderIsNSApplicationSupportDirectory
{
    NSString *applicationSupportDirectory = MR_defaultApplicationStorePath();
    NSString *defaultStoreName = [MagicalRecord defaultStoreName];
    XCTAssertNotNil(defaultStoreName);
    XCTAssertGreaterThan(defaultStoreName.length, (NSUInteger)0);

    NSURL *expectedStoreUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", applicationSupportDirectory, defaultStoreName]];
    XCTAssertNotNil(expectedStoreUrl);

    NSURL *defaultStoreUrl = [NSPersistentStore MR_defaultLocalStoreUrl];
    XCTAssertNotNil(defaultStoreUrl);
    XCTAssertEqualObjects(defaultStoreUrl, expectedStoreUrl);
}

- (void)testCanFindFileURLInNSApplicationSupportDirectoryWhenProvidingStoreName
{
    NSString *storeFileName = @"NotTheDefaultStoreName.storefile";
    NSString *applicationSupportDirectory = MR_defaultApplicationStorePath();
    NSString *testStorePath = [applicationSupportDirectory stringByAppendingPathComponent:storeFileName];

    BOOL fileWasCreated = [[NSFileManager defaultManager] createFileAtPath:testStorePath contents:[storeFileName dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    XCTAssertTrue(fileWasCreated);

    NSURL *expectedStoreUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", applicationSupportDirectory, storeFileName]];
    XCTAssertNotNil(expectedStoreUrl);

    NSURL *foundStoreUrl = [NSPersistentStore MR_fileURLForStoreNameIfExistsOnDisk:storeFileName];
    XCTAssertNotNil(foundStoreUrl);
    XCTAssertEqualObjects(foundStoreUrl, expectedStoreUrl);

    [[NSFileManager defaultManager] removeItemAtPath:testStorePath error:nil];
}

- (void)testCanFindFileURLInNSDocumentDirectoryWhenProvidingStoreName
{
    NSString *storeFileName = @"NotTheDefaultStoreName.storefile";
    NSString *applicationDocumentsDirectory = MR_defaultApplicationStorePath();
    NSString *testStorePath = [applicationDocumentsDirectory stringByAppendingPathComponent:storeFileName];

    BOOL fileWasCreated = [[NSFileManager defaultManager] createFileAtPath:testStorePath contents:[storeFileName dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    XCTAssertTrue(fileWasCreated);

    NSURL *expectedStoreUrl = [NSURL fileURLWithPath:testStorePath];
    XCTAssertNotNil(expectedStoreUrl);

    NSURL *foundStoreUrl = [NSPersistentStore MR_fileURLForStoreNameIfExistsOnDisk:storeFileName];
    XCTAssertNotNil(foundStoreUrl);
    XCTAssertEqualObjects(foundStoreUrl, expectedStoreUrl);

    [[NSFileManager defaultManager] removeItemAtPath:testStorePath error:nil];
}

@end
