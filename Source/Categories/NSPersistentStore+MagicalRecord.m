//
//  NSPersistentStore+MagicalRecord.m
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

//#import "NSPersistentStore+MagicalRecord.h"
#import "CoreData+MagicalRecord.h"

NSString * const kMagicalRecordDefaultStoreFileName = @"CoreDataStore.sqlite";

static NSPersistentStore *defaultPersistentStore_ = nil;

@implementation NSPersistentStore (MagicalRecord)

+ (NSPersistentStore *) MR_defaultPersistentStore
{
	return defaultPersistentStore_;
}

+ (void) MR_setDefaultPersistentStore:(NSPersistentStore *) store
{
    [store retain];
    [defaultPersistentStore_ release];
	defaultPersistentStore_ = store;
}

+ (NSString *) MR_directory:(int) type
{    
    return [NSSearchPathForDirectoriesInDomains(type, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)MR_applicationDocumentsDirectory 
{
	return [self MR_directory:NSDocumentDirectory];
}

+ (NSString *)MR_applicationLibraryDirectory
{
#if !TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR
    
    NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
    return [[self MR_directory:NSApplicationSupportDirectory] stringByAppendingPathComponent:applicationName];
    
#else
    
	return [self MR_directory:NSLibraryDirectory];
    
#endif
}

+ (NSURL *) MR_urlForStoreName:(NSString *)storeFileName
{
	NSArray *paths = [NSArray arrayWithObjects:[self MR_applicationDocumentsDirectory], [self MR_applicationLibraryDirectory], nil];
    NSFileManager *fm = [[[NSFileManager alloc] init] autorelease];

    for (NSString *path in paths) 
    {
        NSString *filepath = [path stringByAppendingPathComponent:storeFileName];
        if ([fm fileExistsAtPath:filepath])
        {
            return [NSURL fileURLWithPath:filepath];
        }
    }

    //set default url
    return [NSURL fileURLWithPath:[[self MR_applicationLibraryDirectory] stringByAppendingPathComponent:storeFileName]];
}

+ (NSURL *)MR_defaultLocalStoreUrl
{
    return [self MR_urlForStoreName:kMagicalRecordDefaultStoreFileName];
}

@end
