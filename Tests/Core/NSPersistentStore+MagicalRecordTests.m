//
//  Created by Tony Arnold on 25/03/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import "Expecta.h"

#import "NSPersistentStore+MagicalRecord.h"
#import "NSPersistentStore+MagicalRecordPrivate.h"
#import "MagicalRecord.h"

@interface NSPersistentStoreMagicalRecordTests : XCTestCase

@end

@implementation NSPersistentStoreMagicalRecordTests

- (void)testDefaultStoreFolderIsNSApplicationSupportDirectory
{
    NSString *applicationSupportDirectory = MR_defaultApplicationStorePath();
    NSString *defaultStoreName = [MagicalRecord defaultStoreName];

    NSURL *expectedStoreUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", applicationSupportDirectory, defaultStoreName]];

    expect(expectedStoreUrl).toNot.beNil();

    NSURL *defaultStoreUrl = [NSPersistentStore MR_defaultLocalStoreUrl];

    expect(defaultStoreUrl).toNot.beNil();
    expect(defaultStoreUrl).to.equal(expectedStoreUrl);
}

- (void)testCanFindFileURLInNSApplicationSupportDirectoryWhenProvidingStoreName
{
    NSString *storeFileName = @"NotTheDefaultStoreName.storefile";
    NSString *applicationSupportDirectory = MR_defaultApplicationStorePath();
    NSString *testStorePath = [applicationSupportDirectory stringByAppendingPathComponent:storeFileName];

    BOOL fileWasCreated = [[NSFileManager defaultManager] createFileAtPath:testStorePath contents:[storeFileName dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];

    expect(fileWasCreated).to.beTruthy();

    NSURL *expectedStoreUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", applicationSupportDirectory, storeFileName]];

    expect(expectedStoreUrl).toNot.beNil();

    NSURL *foundStoreUrl = [NSPersistentStore MR_fileURLForStoreNameIfExistsOnDisk:storeFileName];

    expect(foundStoreUrl).toNot.beNil();
    expect(foundStoreUrl).to.equal(expectedStoreUrl);

    [[NSFileManager defaultManager] removeItemAtPath:testStorePath error:nil];
}

- (void)testCanFindFileURLInNSDocumentDirectoryWhenProvidingStoreName
{
    NSString *storeFileName = @"NotTheDefaultStoreName.storefile";
    NSString *applicationDocumentsDirectory = MR_defaultApplicationStorePath();
    NSString *testStorePath = [applicationDocumentsDirectory stringByAppendingPathComponent:storeFileName];

    BOOL fileWasCreated = [[NSFileManager defaultManager] createFileAtPath:testStorePath contents:[storeFileName dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];

    expect(fileWasCreated).to.beTruthy();

    NSURL *expectedFoundStoreUrl = [NSURL fileURLWithPath:testStorePath];

    expect(expectedFoundStoreUrl).toNot.beNil();

    NSURL *foundStoreUrl = [NSPersistentStore MR_fileURLForStoreNameIfExistsOnDisk:storeFileName];

    expect(foundStoreUrl).toNot.beNil();
    expect(foundStoreUrl).to.equal(expectedFoundStoreUrl);

    [[NSFileManager defaultManager] removeItemAtPath:testStorePath error:nil];
}

@end
