//
//  NSPersistentStore+MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "MagicalRecordHelpers.h"

//#define kMagicalRecordDefaultStoreFileName @"CoreDataStore.sqlite"
extern NSString * const kMagicalRecordDefaultStoreFileName;

@interface NSPersistentStore (MagicalRecord)

+ (NSURL *) defaultLocalStoreUrl;

+ (NSPersistentStore *) defaultPersistentStore;
+ (void) setDefaultPersistentStore:(NSPersistentStore *) store;

+ (NSURL *) urlForStoreName:(NSString *)storeFileName;

@end
