//
//  NSPersistentStore+ActiveRecord.m
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "NSPersistentStore+ActiveRecord.h"

static NSPersistentStore *defaultPersistentStore = nil;

@implementation NSPersistentStore (ActiveRecord)

+ (NSPersistentStore *) defaultPersistentStore
{
	return defaultPersistentStore;
}

+ (void) setDefaultPersistentStore:(NSPersistentStore *) store
{
	[defaultPersistentStore release];
	defaultPersistentStore = [store retain];
}

+ (NSString *) directory:(int) type
{
	return [NSSearchPathForDirectoriesInDomains(type, NSUserDomainMask, YES) lastObject];	
}

+ (NSString *)applicationDocumentsDirectory 
{
	return [self directory:NSDocumentDirectory];
}

+ (NSString *)applicationLibraryDirectory
{
#if !TARGET_OS_IPHONE
        
    NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
    return [[self directory:NSApplicationSupportDirectory] stringByAppendingPathComponent:applicationName];
        
#else

    return [self directory:NSLibraryDirectory];
        
#endif        
}

+ (NSURL *) urlForStoreName:(NSString *)storeFileName
{
	NSArray *paths = nil;
    NSString *defaultDirectory = nil;
#if MAC_APP_STORE_SAFE && !(TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    defaultDirectory = [[@"~/Library/Application Support/" stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]] stringByExpandingTildeInPath];
    paths = [NSArray arrayWithObject:defaultDirectory];
#else
    defaultDirectory = [self applicationLibraryDirectory];
    paths = [NSArray arrayWithObjects:[self applicationDocumentsDirectory], [self applicationLibraryDirectory], nil];
#endif

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
    return [NSURL fileURLWithPath:[defaultDirectory stringByAppendingPathComponent:storeFileName]];
}

+ (NSURL *)defaultLocalStoreUrl
{
    return [self urlForStoreName:kActiveRecordDefaultStoreFileName];
}

@end
