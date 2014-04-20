//
//  NSPersistentStore+MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "MagicalRecord.h"
#import "MagicalRecordDeprecated.h"

@interface NSPersistentStore (MagicalRecord)

/**
 * Default location and filename for the persistent store created by MagicalRecord.
 *
 * @return URL for default persistent store file. Usually `/Users/MyAccount/Library/Application Support/MyAppName/CoreDataStore.sqlite`.
 *
 * @since 2.3.0
 */
+ (NSURL *) MR_defaultLocalStoreUrl;

/**
 * Given the provided filename, return a URL to the default location for
 * storing persistent stores. By default this is in the application support
 * directory, ie: `/Users/${USER}/Library/Application Support/${MY_APPLICATION_NAME}/{$storeFileName}`
 *
 * @param storeFileName Filename that you'd like to use. This should include a valid file extension.
 *
 * @return URL to proposed persistent store file
 *
 * @since 2.3.0
 */
+ (NSURL *) MR_fileURLForStoreName:(NSString *)storeFileName;

/**
 * Uses the result of `+ MR_fileURLForStoreName:`, but returns nil if the
 * store file does not exist at the returned URL.
 *
 * @param storeFileName Filename that you'd like to use. This should include a valid file extension.
 *
 * @return URL to proposed persistent store file if it exists, otherwise nil
 *
 * @since 2.3.0
 */
+ (NSURL *) MR_fileURLForStoreNameIfExistsOnDisk:(NSString *)storeFileName;

+ (NSURL *) MR_cloudURLForUbiqutiousContainer:(NSString *)bucketName;

- (NSArray *) MR_sqliteURLs;

- (BOOL) copyToURL:(NSURL *)destinationUrl error:(NSError **)error;

/**
 * Removes the store files for this persistent store.
 * Please refer to the documentation for
 * `+ (BOOL) MR_removePersistentStoreFilesAtURL:` for more information
 *
 * @return YES if removing all items was successful
 *
 * @since 2.3.0
 */
- (BOOL) MR_removePersistentStoreFiles;

/**
 * Removes the persistent store files at the specified URL, as well as any
 * sidecar files that are present, such as STORENAME.sqlite-shm and
 * STORENAME.sqlite-wal
 *
 * @param url File URL pointing to an NSPersistentStore file
 *
 * @return YES if removing all items was successful
 *
 * @since 2.3.0
 */
+ (BOOL) MR_removePersistentStoreFilesAtURL:(NSURL*)url;

@end

@interface NSPersistentStore (MagicalRecordDeprecated)

+ (NSURL *) MR_defaultURLForStoreName:(NSString *)storeFileName MRDeprecated("Please use + (NSURL *) MR_fileURLForStoreName:");
+ (NSURL *) MR_urlForStoreName:(NSString *)storeFileName MRDeprecated("Please use + (NSURL *) MR_fileURLForStoreNameIfExistsOnDisk:");

@end


