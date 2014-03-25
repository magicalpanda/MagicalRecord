//
//  NSPersistentStore+MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "MagicalRecord.h"

extern NSString * const kMagicalRecordDefaultStoreFileName;

@interface NSPersistentStore (MagicalRecord)

+ (NSURL *) MR_defaultLocalStoreUrl;

+ (NSURL *) MR_fileURLForStoreName:(NSString *)storeFileName;
+ (NSURL *) MR_fileURLForStoreNameIfExistsOnDisk:(NSString *)storeFileName;

+ (NSURL *) MR_cloudURLForUbiqutiousContainer:(NSString *)bucketName;

- (NSArray *) MR_sqliteURLs;

- (BOOL) copyToURL:(NSURL *)destinationUrl error:(NSError **)error;

/**
 *  Removes the store files for this persistent store.
 *  Please refer to the documentation for 
 *  `+ (BOOL) MR_removePersistentStoreFilesAtURL:` for more information
 *
 *  @return YES if removing all items was successful
 */
- (BOOL) MR_removePersistentStoreFiles;

/**
 *  Removes the persistent store files at the specified URL, as well as any 
 *  sidecar files that are present, such as STORENAME.sqlite-shm and
 *  STORENAME.sqlite-wal
 *
 *  @param url File URL pointing to an NSPersistentStore file
 *
 *  @return YES if removing all items was successful
 */
+ (BOOL) MR_removePersistentStoreFilesAtURL:(NSURL*)url;

@end

@interface NSPersistentStore (MagicalRecordDeprecated)

+ (NSURL *) MR_defaultURLForStoreName:(NSString *)storeFileName __attribute__((deprecated("Please use + (NSURL *) MR_fileURLForStoreName:")));
+ (NSURL *) MR_urlForStoreName:(NSString *)storeFileName __attribute__((deprecated("Please use + (NSURL *) MR_fileURLForStoreNameIfExistsOnDisk:")));

@end


