//
//  MagicalRecord+Setup.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"

@interface MagicalRecord (Setup)

+ (void) setupCoreDataStack;
+ (void) setupCoreDataStackWithoutiCloudBackup NS_AVAILABLE_IOS(5_1);
+ (void) setupCoreDataStackWithInMemoryStore;
+ (void) setupAutoMigratingCoreDataStack;
+ (void) setupAutoMigratingCoreDataStackWithoutiCloudBackup NS_AVAILABLE_IOS(5_1);

+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName;
+ (void) setupCoreDataStackWithoutiCloudBackupAndWithStoreNamed:(NSString *)storeName NS_AVAILABLE_IOS(5_1);
+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(NSString *)storeName;
+ (void) setupCoreDataStackWithAutoMigratingSqliteWithoutiCloudBackupAndStoreNamed:(NSString *)storeName NS_AVAILABLE_IOS(5_1);


@end
