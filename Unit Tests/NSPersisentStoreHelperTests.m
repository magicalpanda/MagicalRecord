//
//  NSPersisentStoreHelperTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSPersisentStoreHelperTests.h"

@implementation NSPersisentStoreHelperTests

#if TARGET_OS_IPHONE

- (void) testDefaultStoreFolderForiOSDevicesIsTheLibraryFolder
{
    NSString *applicationLibraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *defaultStoreName = kMagicalRecordDefaultStoreFileName;
    
    NSURL *expectedStoreUrl = [NSURL fileURLWithPath:[applicationLibraryDirectory stringByAppendingPathComponent:defaultStoreName]];
    
    NSURL *defaultStoreUrl = [NSPersistentStore defaultLocalStoreUrl];
    
    assertThat(defaultStoreUrl, is(equalTo(expectedStoreUrl)));
}


- (void) testCanFindAURLInTheLibraryForiOSForASpecifiedStoreName
{
    
}

- (void) testCanFindAURLInDocumentsFolderForiOSForASpecifiedStoreName
{
    
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
    GHFail(@"Test Not Implemented");
}

#endif


@end
