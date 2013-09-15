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

+ (MagicalRecordStack *) setupCoreDataStack;
+ (MagicalRecordStack *) setupCoreDataStackWithStoreAtURL:(NSURL *)url;
+ (MagicalRecordStack *) setupCoreDataStackWithStoreNamed:(NSString *)storeName;

+ (MagicalRecordStack *) setupAutoMigratingCoreDataStack;
+ (MagicalRecordStack *) setupAutoMigratingCoreDataStackWithSqliteStoreNamed:(NSString *)storeName;
+ (MagicalRecordStack *) setupAutoMigratingCoreDataStackWithSqliteStoreAtURL:(NSURL *)url;

+ (MagicalRecordStack *) setupManuallyMigratingCoreDataStack;
+ (MagicalRecordStack *) setupManuallyMigratingCoreDataStackWithSqliteStoreNamed:(NSString *)storeName;
+ (MagicalRecordStack *) setupManuallyMigratingCoreDataStackWithSqliteStoreAtURL:(NSURL *)url;

+ (MagicalRecordStack *) setupCoreDataStackWithiCloudContainer:(NSString *)icloudBucket localStoreNamed:(NSString *)localStore;
+ (MagicalRecordStack *) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent;
+ (MagicalRecordStack *) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent completion:(void(^)(void))completion;

+ (MagicalRecordStack *) setupCoreDataStackWithInMemoryStore;

@end
