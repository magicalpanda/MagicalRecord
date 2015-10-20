//
//  MagicalRecord+iCloud.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <MagicalRecord/MagicalRecordInternal.h>
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>

@interface MagicalRecord (iCloud)

+ (BOOL)isICloudEnabled;

+ (void)setupCoreDataStackWithiCloudContainer:(MR_nonnull NSString *)containerID
                              localStoreNamed:(MR_nonnull NSString *)localStore;

+ (void)setupCoreDataStackWithiCloudContainer:(MR_nonnull NSString *)containerID
                               contentNameKey:(MR_nullable NSString *)contentNameKey
                              localStoreNamed:(MR_nonnull NSString *)localStoreName
                      cloudStorePathComponent:(MR_nullable NSString *)pathSubcomponent;

+ (void)setupCoreDataStackWithiCloudContainer:(MR_nonnull NSString *)containerID
                               contentNameKey:(MR_nullable NSString *)contentNameKey
                              localStoreNamed:(MR_nonnull NSString *)localStoreName
                      cloudStorePathComponent:(MR_nullable NSString *)pathSubcomponent
                                   completion:(void (^ __MR_nullable)(void))completion;

+ (void)setupCoreDataStackWithiCloudContainer:(MR_nonnull NSString *)containerID
                              localStoreAtURL:(MR_nonnull NSURL *)storeURL;

+ (void)setupCoreDataStackWithiCloudContainer:(MR_nonnull NSString *)containerID
                               contentNameKey:(MR_nullable NSString *)contentNameKey
                              localStoreAtURL:(MR_nonnull NSURL *)storeURL
                      cloudStorePathComponent:(MR_nullable NSString *)pathSubcomponent;

+ (void)setupCoreDataStackWithiCloudContainer:(MR_nonnull NSString *)containerID
                               contentNameKey:(MR_nullable NSString *)contentNameKey
                              localStoreAtURL:(MR_nonnull NSURL *)storeURL
                      cloudStorePathComponent:(MR_nullable NSString *)pathSubcomponent
                                   completion:(void (^ __MR_nullable)(void))completion;

@end
