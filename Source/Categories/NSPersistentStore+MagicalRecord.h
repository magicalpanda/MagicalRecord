//
//  NSPersistentStore+MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "MagicalRecordHelpers.h"

extern NSString * const kMagicalRecordDefaultStoreFileName;

#ifdef MR_SHORTHAND
	#define defaultLocalStoreURL MR_defaultLocalStoreURL
	#define defaultPersistentStore MR_defaultPersistentStore
	#define setDefaultPersistentStore MR_setDefaultPersistentStore
	#define URLForStoreName MR_URLForStoreName
#endif

@interface NSPersistentStore (MagicalRecord)

+ (NSURL *) MR_defaultLocalStoreURL;

+ (NSPersistentStore *) MR_defaultPersistentStore;
+ (void) MR_setDefaultPersistentStore:(NSPersistentStore *) store;

+ (NSURL *) MR_URLForStoreName:(NSString *)storeFileName;

@end
