//
//  NSPersistentStore+MagicalRecord.m
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "NSPersistentStore+MagicalRecord.h"
#import "NSError+MagicalRecordErrorHandling.h"
#import "MagicalRecordLogging.h"


NSString * const kMagicalRecordDefaultStoreFileName = @"CoreDataStore.sqlite";


@implementation NSPersistentStore (MagicalRecord)

+ (NSString *) MR_directory:(int) type
{    
    return [NSSearchPathForDirectoriesInDomains(type, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)MR_applicationDocumentsDirectory 
{
	return [self MR_directory:NSDocumentDirectory];
}

+ (NSString *)MR_applicationStorageDirectory
{
    NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
    return [[self MR_directory:NSApplicationSupportDirectory] stringByAppendingPathComponent:applicationName];
}

+ (NSURL *) MR_defaultURLForStoreName:(NSString *)storeFileName;
{
    NSURL *storeURL = [self MR_urlForStoreName:storeFileName];
    if (storeURL == nil)
    {
        NSString *storePath = [[self MR_applicationStorageDirectory] stringByAppendingPathComponent:storeFileName];
        storeURL = [NSURL fileURLWithPath:storePath];
    }
    return storeURL;
}

+ (NSURL *) MR_urlForStoreName:(NSString *)storeFileName
{
	NSArray *paths = [NSArray arrayWithObjects:[self MR_applicationDocumentsDirectory], [self MR_applicationStorageDirectory], nil];
    NSFileManager *fm = [[NSFileManager alloc] init];
    
    for (NSString *path in paths) 
    {
        NSString *filepath = [path stringByAppendingPathComponent:storeFileName];
        if ([fm fileExistsAtPath:filepath])
        {
            return [NSURL fileURLWithPath:filepath];
        }
    }

    return nil;
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

- (BOOL) MR_isSqliteStore;
{
    return [[self type] isEqualToString:NSSQLiteStoreType];
}

- (BOOL) copyToURL:(NSURL *)destinationUrl error:(NSError **)error;
{
    if (![self MR_isSqliteStore])
    {
        MRLogWarn(@"NSPersistentStore [%@] is not a %@", self, NSSQLiteStoreType);
        return NO;
    }

    NSArray *storeUrls = [self MR_sqliteURLs];

    BOOL success = YES;
    NSFileManager *fileManager = [[NSFileManager alloc] init];

    for (NSURL *storeUrl in storeUrls)
    {
        NSURL *copyToURL = [destinationUrl URLByDeletingPathExtension];
        copyToURL = [copyToURL URLByAppendingPathExtension:[storeUrl pathExtension]];
        success &= [fileManager copyItemAtURL:storeUrl toURL:copyToURL error:error];
    }
    return success;
}

- (NSArray *) MR_sqliteURLs;
{
    if (![self MR_isSqliteStore])
    {
        MRLogWarn(@"NSPersistentStore [%@] is not a %@", self, NSSQLiteStoreType);
        return nil;
    }

    NSURL *primaryStoreURL = [self URL];
    NSAssert([primaryStoreURL isFileURL], @"Store URL [%@] does not point to a resource on the local file system", primaryStoreURL);
    
    NSMutableArray *storeURLs = [NSMutableArray arrayWithObject:primaryStoreURL];
    NSArray *extensions = @[@"sqlite-wal", @"sqlite-shm"];

    for (NSString *extension in extensions)
    {
        NSURL *extensionURL = [primaryStoreURL URLByDeletingPathExtension];
        extensionURL = [extensionURL URLByAppendingPathExtension:extension];

        NSError *error;
        BOOL fileExists = [extensionURL checkResourceIsReachableAndReturnError:&error];
        if (fileExists)
        {
            [storeURLs addObject:extensionURL];
        }
        [[error MR_coreDataDescription] MR_logToConsole];
    }
    return [NSArray arrayWithArray:storeURLs];
}

@end
