//
//  NSPersistentStore+MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>

// option to autodelete store if it already exists

extern NSString * __MR_nonnull const kMagicalRecordDefaultStoreFileName;


@interface NSPersistentStore (MagicalRecord)

+ (MR_nonnull NSURL *) MR_defaultLocalStoreUrl;

+ (MR_nullable NSPersistentStore *) MR_defaultPersistentStore;
+ (void) MR_setDefaultPersistentStore:(MR_nullable NSPersistentStore *) store;

+ (MR_nullable NSURL *) MR_urlForStoreName:(MR_nonnull NSString *)storeFileName;
+ (MR_nullable NSURL *) MR_cloudURLForUbiqutiousContainer:(MR_nonnull NSString *)bucketName;

@end


