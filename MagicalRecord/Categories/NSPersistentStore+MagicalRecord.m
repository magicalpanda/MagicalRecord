//
//  NSPersistentStore+MagicalRecord.m
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "NSPersistentStore+MagicalRecord.h"

NSString * const kMagicalRecordDefaultStoreFileName = @"CoreDataStore.sqlite";

static NSPersistentStore *defaultPersistentStore_ = nil;
static NSString *applicationStorageDirectory_ = nil;


@implementation NSPersistentStore (MagicalRecord)

+ (NSPersistentStore *) MR_defaultPersistentStore
{
	return defaultPersistentStore_;
}

+ (void) MR_setDefaultPersistentStore:(NSPersistentStore *)store
{
	defaultPersistentStore_ = store;
}

+ (void) MR_setApplicationStorageDirectory:(NSString *)urlString {
    applicationStorageDirectory_ = urlString;
}

+ (NSString *) MR_defaultApplicationStorageDirectory {
    NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
    return [[self MR_directory:NSApplicationSupportDirectory] stringByAppendingPathComponent:applicationName];
}

+ (NSString *) MR_directory:(NSSearchPathDirectory)type
{    
    return [NSSearchPathForDirectoriesInDomains(type, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)MR_applicationStorageDirectory
{
    // by default, MagicalRecord uses a directory that contains the app bundle name from your plist,
    // so changing the app bundle name will cause the core data persistent store to reset
    // to avoid this behaviour, use [NSPersistentStore MR_setApplicationStorageDirectory:] before setting up your stack
    if (applicationStorageDirectory_ == nil) {
        return [self MR_defaultApplicationStorageDirectory];
    }
  
    return applicationStorageDirectory_;
}

+ (NSURL *) MR_urlForStoreName:(NSString *)storeFileName
{
    NSString *pathForStoreName = [[self MR_applicationStorageDirectory] stringByAppendingPathComponent:storeFileName];
    return [NSURL fileURLWithPath:pathForStoreName];
}

+ (NSURL *) MR_cloudURLForUbiqutiousContainer:(NSString *)bucketName;
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *cloudURL = nil;
    if ([fileManager respondsToSelector:@selector(URLForUbiquityContainerIdentifier:)])
    {
        cloudURL = [fileManager URLForUbiquityContainerIdentifier:bucketName];
    }

    return cloudURL;
}

+ (NSURL *) MR_defaultLocalStoreUrl
{
    return [self MR_urlForStoreName:kMagicalRecordDefaultStoreFileName];
}

@end
