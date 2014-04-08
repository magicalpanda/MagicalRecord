//
//  Created by Tony Arnold on 25/03/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import "Expecta.h"

#import "NSPersistentStore+MagicalRecord.h"

@interface NSPersistentStoreMagicalRecordTests : XCTestCase

@end

@implementation NSPersistentStoreMagicalRecordTests

- (void)testDefaultStoreFolderIsNSApplicationSupportDirectory
{
    NSString *applicationSupportDirectory = [[self class] NSPersistentStoreMagicalRecordTests_applicationSupportDirectory];
    NSString *defaultStoreName = kMagicalRecordDefaultStoreFileName;

    NSURL *expectedStoreUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", applicationSupportDirectory, defaultStoreName]];

    expect(expectedStoreUrl).toNot.beNil();

    NSURL *defaultStoreUrl = [NSPersistentStore MR_defaultLocalStoreUrl];

    expect(defaultStoreUrl).toNot.beNil();
    expect(defaultStoreUrl).to.equal(expectedStoreUrl);
}

- (void)testCanFindFileURLInNSApplicationSupportDirectoryWhenProvidingStoreName
{
    NSString *storeFileName = @"NotTheDefaultStoreName.storefile";
    NSString *applicationSupportDirectory = [[self class] NSPersistentStoreMagicalRecordTests_applicationSupportDirectory];
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
    NSString *applicationDocumentsDirectory = [[self class] NSPersistentStoreMagicalRecordTests_applicationDocumentsDirectory];
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

#pragma mark - Private Methods

+ (NSString *) NSPersistentStoreMagicalRecordTests_directoryInUserDomain:(NSSearchPathDirectory) directory
{
    return [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *) NSPersistentStoreMagicalRecordTests_applicationDocumentsDirectory
{
	return [self NSPersistentStoreMagicalRecordTests_directoryInUserDomain:NSDocumentDirectory];
}

+ (NSString *) NSPersistentStoreMagicalRecordTests_applicationSupportDirectory
{
    // We use the MagicalRecord class here so that there's an appropriate response from the bundle name
    NSString *applicationName = [[[NSBundle bundleForClass:[MagicalRecord class]] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
    return [[self NSPersistentStoreMagicalRecordTests_directoryInUserDomain:NSApplicationSupportDirectory] stringByAppendingPathComponent:applicationName];
}

@end
