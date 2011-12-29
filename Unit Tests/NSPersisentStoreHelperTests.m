//
//  NSPersisentStoreHelperTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSPersisentStoreHelperTests.h"

@implementation NSPersisentStoreHelperTests

- (NSString *) applicationStorageDirectory
{
    NSString *appSupportDirectory = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    appSupportDirectory = [appSupportDirectory stringByAppendingPathComponent:@"iOS App Unit Tests"];
    return appSupportDirectory;
}

#if TARGET_OS_IPHONE

- (void) testDefaultStoreFolderForiOSDevicesIsTheApplicationSupportFolder
{
    NSString *applicationLibraryDirectory = [self applicationStorageDirectory];
    NSString *defaultStoreName = kMagicalRecordDefaultStoreFileName;
    
    NSURL *expectedStoreUrl = [NSURL fileURLWithPath:[applicationLibraryDirectory stringByAppendingPathComponent:defaultStoreName]];
    
    NSURL *defaultStoreUrl = [NSPersistentStore defaultLocalStoreUrl];
    
    assertThat(defaultStoreUrl, is(equalTo(expectedStoreUrl)));
}


- (void) testCanFindAURLInTheLibraryForiOSForASpecifiedStoreName
{
    NSString *storeFileName = @"NotTheDefaultStoreName.storefile";
    NSString *applicationLibraryDirectory = [self applicationStorageDirectory];
    NSString *testStorePath = [applicationLibraryDirectory stringByAppendingPathComponent:storeFileName];
    
    BOOL fileWasCreated = [[NSFileManager defaultManager] createFileAtPath:testStorePath contents:[storeFileName dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    
    assertThatBool(fileWasCreated, is(equalToBool(YES)));
    
    NSURL *expectedFoundStoreUrl = [NSURL fileURLWithPath:testStorePath];
    NSURL *foundStoreUrl = [NSPersistentStore urlForStoreName:storeFileName];
    
    assertThat(foundStoreUrl, is(equalTo(expectedFoundStoreUrl)));
    
    [[NSFileManager defaultManager] removeItemAtPath:testStorePath error:nil];
}

- (void) testCanFindAURLInDocumentsFolderForiOSForASpecifiedStoreName
{
    NSString *storeFileName = @"NotTheDefaultStoreName.storefile";
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *testStorePath = [documentDirectory stringByAppendingPathComponent:storeFileName];
    
    BOOL fileWasCreated = [[NSFileManager defaultManager] createFileAtPath:testStorePath contents:[storeFileName dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    
    assertThatBool(fileWasCreated, is(equalToBool(YES)));
    
    NSURL *expectedFoundStoreUrl = [NSURL fileURLWithPath:testStorePath];
    NSURL *foundStoreUrl = [NSPersistentStore urlForStoreName:storeFileName];
    
    assertThat(foundStoreUrl, is(equalTo(expectedFoundStoreUrl)));
    
    [[NSFileManager defaultManager] removeItemAtPath:testStorePath error:nil];
}

#else

- (void) testDefaultStoreFolderForMacIsTheApplicationSupportSlashApplicationFolder
{
    NSString *applictionSupportDirectory = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
    NSString *defaultStoreName = kMagicalRecordDefaultStoreFileName;
    
    NSURL *expectedStoreUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@/%@", applictionSupportDirectory, applicationName, defaultStoreName]];
    
    NSURL *defaultStoreUrl = [NSPersistentStore defaultLocalStoreUrl];
    assertThat(defaultStoreUrl, is(equalTo(expectedStoreUrl)));
}


- (void) testCanFindAURLInTheApplicationSupportLibraryForMacForASpecifiedStoreName
{
    NSString *storeFileName = @"NotTheDefaultStoreName.storefile";
    NSString *applicationSupportDirectory = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
    NSString *testStorePath = [applicationSupportDirectory stringByAppendingPathComponent:storeFileName];
    
    BOOL fileWasCreated = [[NSFileManager defaultManager] createFileAtPath:testStorePath contents:[storeFileName dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    
    assertThatBool(fileWasCreated, is(equalToBool(YES)));
    
    NSURL *expectedStoreUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@/%@", applicationSupportDirectory, applicationName, storeFileName]];
    
    NSURL *foundStoreUrl = [NSPersistentStore urlForStoreName:storeFileName];
    
    assertThat(foundStoreUrl, is(equalTo(expectedStoreUrl)));
    
    [[NSFileManager defaultManager] removeItemAtPath:testStorePath error:nil];
}

#endif


@end
