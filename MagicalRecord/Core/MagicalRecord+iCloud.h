//
//  MagicalRecord+iCloud.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"

@interface MagicalRecord (iCloud)

+ (BOOL) isICloudEnabled;

+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)icloudBucket localStoreNamed:(NSString *)localStore;
+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent;
+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent completion:(void(^)(void))completion;

@end
