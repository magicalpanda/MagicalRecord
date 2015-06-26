//
//  MagicalRecord+Setup.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"

@class MagicalRecordStack;

@interface MagicalRecord (Setup)

+ (MagicalRecordStack *) setupSQLiteStack;
+ (MagicalRecordStack *) setupSQLiteStackWithStoreAtURL:(NSURL *)url;
+ (MagicalRecordStack *) setupSQLiteStackWithStoreNamed:(NSString *)storeName;

+ (MagicalRecordStack *) setupAutoMigratingStack;
+ (MagicalRecordStack *) setupAutoMigratingStackWithSQLiteStoreNamed:(NSString *)storeName;
+ (MagicalRecordStack *) setupAutoMigratingStackWithSQLiteStoreAtURL:(NSURL *)url;

+ (MagicalRecordStack *) setupManuallyMigratingStack;
+ (MagicalRecordStack *) setupManuallyMigratingStackWithSQLiteStoreNamed:(NSString *)storeName;
+ (MagicalRecordStack *) setupManuallyMigratingStackWithSQLiteStoreAtURL:(NSURL *)url;

+ (MagicalRecordStack *) setupClassicStack;
+ (MagicalRecordStack *) setupClassicStackWithSQLiteStoreNamed:(NSString *)storeName;
+ (MagicalRecordStack *) setupClassicStackWithSQLiteStoreAtURL:(NSURL *)storeURL;

+ (MagicalRecordStack *) setupiCloudStackWithLocalStoreNamed:(NSString *)localStore;

+ (MagicalRecordStack *) setupStackWithInMemoryStore;

+ (MagicalRecordStack *)setupModernStackWithLocalStoreNamed:(NSString *)localStoreName;
+ (MagicalRecordStack *)setupModernStackWithLocalStoreNamed:(NSString *)localStoreName modelURL:(NSURL *)modelURL;
+ (MagicalRecordStack *)setupModernStackWithLocalStoreURL:(NSString *)localStoreURL modelURL:(NSURL *)modelURL;
+ (MagicalRecordStack *)setupModernStackWithLocalStoreURL:(NSString *)localStoreURL;

@end
