//
//  MagicalRecord+Setup.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordInternal.h"
#import "MagicalRecordXcode7CompatibilityMacros.h"

@interface MagicalRecord (Setup)

+ (void) setupCoreDataStack;
+ (void) setupCoreDataStackWithInMemoryStore;
+ (void) setupAutoMigratingCoreDataStack;

+ (void) setupCoreDataStackWithStoreNamed:(MR_nonnull NSString *)storeName;
+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(MR_nonnull NSString *)storeName;

+ (void) setupCoreDataStackWithStoreAtURL:(MR_nonnull NSURL *)storeURL;
+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreAtURL:(MR_nonnull NSURL *)storeURL;


@end
