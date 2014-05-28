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
 Default location and filename for the persistent store created by MagicalRecord.
 
 This is usually `/Users/MyAccount/Library/Application Support/MyAppName/CoreDataStore.sqlite`.

 @return URL for the default persistent store file.

 @since Available in v2.3 and later.
 */
+ (NSURL *) MR_defaultLocalStoreUrl;

/**
 Given the provided filename, return a URL to the default location for storing persistent stores. By default this is in the application support directory, ie: `/Users/${USER}/Library/Application Support/${MY_APPLICATION_NAME}/{$storeFileName}`

 @param storeFileName Filename that you'd like to use. This should include a valid file extension.

 @return URL to proposed persistent store file.

 @since Available in v2.3 and later.
 */
+ (NSURL *) MR_fileURLForStoreName:(NSString *)storeFileName;

/**
 Uses the result of `+ MR_fileURLForStoreName:`, but returns nil if the store file does not exist at the returned URL.

 @param storeFileName Filename that you'd like to use. This should include a valid file extension.

 @return URL to proposed persistent store file if it exists, otherwise nil

 @since Available in v2.3 and later.
 */
+ (NSURL *) MR_fileURLForStoreNameIfExistsOnDisk:(NSString *)storeFileName;

+ (NSURL *) MR_cloudURLForUbiqutiousContainer:(NSString *)bucketName;

- (NSArray *) MR_sqliteURLs;

- (BOOL) MR_copyToURL:(NSURL *)destinationUrl error:(NSError **)error;

/**
 Removes the store files for this persistent store.

 @return YES if removing all items was successful
 
 @see +MR_removePersistentStoreFilesAtURL:

 @since Available in v2.3 and later.
 */
- (BOOL) MR_removePersistentStoreFiles;

/**
 Removes the persistent store files at the specified URL, as well as any sidecar files that are present, such as STORENAME.sqlite-shm and STORENAME.sqlite-wal

 @param url File URL pointing to an NSPersistentStore file

 @return YES if removing all items was successful

 @since Available in v2.3 and later.
 */
+ (BOOL) MR_removePersistentStoreFilesAtURL:(NSURL*)url;

@end

@interface NSPersistentStore (MagicalRecordDeprecated)

+ (NSURL *) MR_defaultURLForStoreName:(NSString *)storeFileName MR_DEPRECATED_IN_3_0_PLEASE_USE("MR_fileURLForStoreName:");
+ (NSURL *) MR_urlForStoreName:(NSString *)storeFileName MR_DEPRECATED_IN_3_0_PLEASE_USE("MR_fileURLForStoreNameIfExistsOnDisk:");

@end
