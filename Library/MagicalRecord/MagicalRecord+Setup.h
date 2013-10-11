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

+ (MagicalRecordStack *) setupSQliteStack;
+ (MagicalRecordStack *) setupSQliteStackWithStoreAtURL:(NSURL *)url;
+ (MagicalRecordStack *) setupSQliteStackWithStoreNamed:(NSString *)storeName;

+ (MagicalRecordStack *) setupAutoMigratingStack;
+ (MagicalRecordStack *) setupAutoMigratingStackWithSqliteStoreNamed:(NSString *)storeName;
+ (MagicalRecordStack *) setupAutoMigratingStackWithSqliteStoreAtURL:(NSURL *)url;

+ (MagicalRecordStack *) setupManuallyMigratingStack;
+ (MagicalRecordStack *) setupManuallyMigratingStackWithSqliteStoreNamed:(NSString *)storeName;
+ (MagicalRecordStack *) setupManuallyMigratingStackWithSqliteStoreAtURL:(NSURL *)url;

+ (MagicalRecordStack *) setupStackWithiCloudContainer:(NSString *)icloudBucket localStoreNamed:(NSString *)localStore;
+ (MagicalRecordStack *) setupStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent;
+ (MagicalRecordStack *) setupStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent completion:(void(^)(void))completion;

+ (MagicalRecordStack *) setupStackWithInMemoryStore;

@end
