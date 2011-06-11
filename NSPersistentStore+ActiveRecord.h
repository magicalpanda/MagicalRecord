//
//  NSPersistentStore+ActiveRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "ActiveRecordHelpers.h"

#define kActiveRecordDefaultStoreFileName @"CoreDataStore.sqlite"

@interface NSPersistentStore (ActiveRecord)

+ (NSString *)applicationDocumentsDirectory;
+ (NSString *)applicationLibraryDirectory;

+ (NSURL *) defaultLocalStoreUrl;

+ (NSPersistentStore *) defaultPersistentStore;
+ (void) setDefaultPersistentStore:(NSPersistentStore *) store;

+ (NSURL *) urlForStoreName:(NSString *)storeFileName;

@end
