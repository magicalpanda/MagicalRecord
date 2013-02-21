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
+ (void) setupCoreDataStackWithInMemoryStore;
+ (void) setupAutoMigratingCoreDataStack;
+ (void) setupCoreDataStackWithType:(NSString*)storeType;
+ (void) setupAutoMigratingCoreDataStackWithType:(NSString*)storeType;

+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName;
+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName andCustomStoreType:(NSString*)storeType;
+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(NSString *)storeName;
+ (void) setupCoreDataStackWithAutoMigratingCustomStoreNamed:(NSString *)storeName andCustomStoreType:(NSString*)storeType;


@end
