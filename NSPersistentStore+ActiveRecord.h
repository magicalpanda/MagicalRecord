//
//  NSPersistentStore+ActiveRecord.h
//  DocBook
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Willow Tree Mobile, Inc. All rights reserved.
//

#import "ActiveRecordHelpers.h"

#define kActiveRecordDefaultStoreFileName @"CoreDataStore.sqlite"

@interface NSPersistentStore (ActiveRecord)

+ (NSURL *) defaultLocalStoreUrl;

+ (NSPersistentStore *) defaultPersistentStore;
+ (void) setDetaultPersistentStore:(NSPersistentStore *) store;

+ (NSURL *) urlForStoreName:(NSString *)storeFileName;

@end
