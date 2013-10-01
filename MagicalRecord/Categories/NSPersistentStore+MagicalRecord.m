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

+ (NSString *)MR_applicationStorageDirectory
{
    NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
    return [[self MR_directory:NSApplicationSupportDirectory] stringByAppendingPathComponent:applicationName];
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

    //set default url
    return [NSURL fileURLWithPath:[[self MR_applicationStorageDirectory] stringByAppendingPathComponent:storeFileName]];
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

+ (BOOL)MR_deleteFilesForSqliteStoreAtURL:(NSURL *)sqliteStoreURL withFileManager:(NSFileManager *)manager
{
    if (![[sqliteStoreURL pathExtension] isEqualToString:@"sqlite"]) {
        NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@]: sqliteStoreURL does not point to a .sqlite file",
                            NSStringFromClass([self class]),
                            NSStringFromSelector(_cmd)];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
    }
    
    NSString *storeDirectoryPath = [[sqliteStoreURL path] stringByDeletingLastPathComponent];
    NSString *storeFilename = [[sqliteStoreURL path] lastPathComponent];
    
    NSError *fileError;
    NSArray *storeDirectoryContents;
    storeDirectoryContents = [manager contentsOfDirectoryAtPath:storeDirectoryPath error:&fileError];
    
    BOOL result = YES;
    if (fileError) {
        [MagicalRecord handleErrors:fileError];
        result = NO;
    } else {
        NSError *regexError;
        NSString *pattern = [NSString stringWithFormat:@"\\A%@.*\\z", storeFilename];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:kNilOptions
                                                                                 error:&regexError];
        if (regexError) {
            [MagicalRecord handleErrors:regexError];
            result = NO;
        } else {
            for (NSString *filename in storeDirectoryContents) {
                NSRange filenameRange = NSMakeRange(0, [filename length]);
                NSUInteger numMatches = [regex numberOfMatchesInString:filename
                                                               options:kNilOptions
                                                                 range:filenameRange];
                if (numMatches > 0) {
                    NSString *fullFilePath = [storeDirectoryPath stringByAppendingPathComponent:filename];
                    NSError *deletionError;
                    if ([manager removeItemAtPath:fullFilePath error:&deletionError]) {
                        MRLogInfo(@"Removed SQLite persistent store file at path '%@'", fullFilePath);
                    } else {
                        [MagicalRecord handleErrors:deletionError];
                        result = NO;
                    }
                }
            }
        }
    }
    return result;
}

@end
