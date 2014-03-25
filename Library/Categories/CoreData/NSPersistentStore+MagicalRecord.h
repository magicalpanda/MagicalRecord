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

@end

@interface NSPersistentStore (MagicalRecordDeprecated)

+ (NSURL *) MR_defaultURLForStoreName:(NSString *)storeFileName __attribute__((deprecated("Please use + (NSURL *) MR_fileURLForStoreName:")));
+ (NSURL *) MR_urlForStoreName:(NSString *)storeFileName __attribute__((deprecated("Please use + (NSURL *) MR_fileURLForStoreNameIfExistsOnDisk:")));

@end


