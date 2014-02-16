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

+ (MagicalRecordStack *) setupStackWithiCloudContainer:(NSString *)icloudBucket localStoreNamed:(NSString *)localStore;
+ (MagicalRecordStack *) setupStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent;
+ (MagicalRecordStack *) setupStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent completion:(void(^)(void))completion;

+ (MagicalRecordStack *) setupStackWithInMemoryStore;

@end
