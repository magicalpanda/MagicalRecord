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
+ (void) setupCoreDataStackWithStoreAtURL:(NSURL *)url;
+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName;

+ (void) setupAutoMigratingCoreDataStack;
+ (void) setupAutoMigratingCoreDataStackWithSqliteStoreNamed:(NSString *)storeName;
+ (void) setupAutoMigratingCoreDataStackWithSqliteStoreAtURL:(NSURL *)url;

+ (void) setupManuallyMigratingCoreDataStack;
+ (void) setupManuallyMigratingCoreDataStackWithSqliteStoreNamed:(NSString *)storeName;
+ (void) setupManuallyMigratingCoreDataStackWithSqliteStoreAtURL:(NSURL *)url;

+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)icloudBucket localStoreNamed:(NSString *)localStore;
+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent;
+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent completion:(void(^)(void))completion;

+ (void) setupCoreDataStackWithInMemoryStore;

@end
