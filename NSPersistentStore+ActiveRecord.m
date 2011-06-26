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
    
//#ifdef UIKIT_EXTERN_CLASS
//    if (store == nil) 
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Core Data Error" message:@"The default NSPersistentStore was set to nil. The most likely cause is the NSManagedObjectModel version has changed. Either create a new data store, or delete the previous store to continue" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//    }
//#endif
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
	return [self directory:NSLibraryDirectory];
}

+ (NSURL *) urlForStoreName:(NSString *)storeFileName
{
	NSArray *paths = nil;
    NSString *defaultDirectory = nil;
#if MAC_APP_STORE
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
