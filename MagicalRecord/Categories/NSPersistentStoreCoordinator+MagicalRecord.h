//
//  NSPersistentStoreCoordinator+MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>

OBJC_EXPORT NSString * __MR_nonnull const kMagicalRecordPSCDidCompleteiCloudSetupNotification;
OBJC_EXPORT NSString * __MR_nonnull const kMagicalRecordPSCMismatchWillDeleteStore;
OBJC_EXPORT NSString * __MR_nonnull const kMagicalRecordPSCMismatchDidDeleteStore;
OBJC_EXPORT NSString * __MR_nonnull const kMagicalRecordPSCMismatchWillRecreateStore;
OBJC_EXPORT NSString * __MR_nonnull const kMagicalRecordPSCMismatchDidRecreateStore;
OBJC_EXPORT NSString * __MR_nonnull const kMagicalRecordPSCMismatchCouldNotDeleteStore;
OBJC_EXPORT NSString * __MR_nonnull const kMagicalRecordPSCMismatchCouldNotRecreateStore;

@interface NSPersistentStoreCoordinator (MagicalRecord)

+ (MR_nullable NSPersistentStoreCoordinator *) MR_defaultStoreCoordinator;
+ (void) MR_setDefaultStoreCoordinator:(MR_nullable NSPersistentStoreCoordinator *)coordinator;

+ (MR_nonnull NSPersistentStoreCoordinator *) MR_coordinatorWithInMemoryStore;

+ (MR_nonnull NSPersistentStoreCoordinator *) MR_newPersistentStoreCoordinator NS_RETURNS_RETAINED;

+ (MR_nonnull NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreNamed:(MR_nonnull NSString *)storeFileName;
+ (MR_nonnull NSPersistentStoreCoordinator *) MR_coordinatorWithAutoMigratingSqliteStoreNamed:(MR_nonnull NSString *)storeFileName;
+ (MR_nonnull NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreAtURL:(MR_nonnull NSURL *)storeURL;
+ (MR_nonnull NSPersistentStoreCoordinator *) MR_coordinatorWithAutoMigratingSqliteStoreAtURL:(MR_nonnull NSURL *)storeURL;
+ (MR_nonnull NSPersistentStoreCoordinator *) MR_coordinatorWithPersistentStore:(MR_nonnull NSPersistentStore *)persistentStore;
+ (MR_nonnull NSPersistentStoreCoordinator *) MR_coordinatorWithiCloudContainerID:(MR_nonnull NSString *)containerID contentNameKey:(MR_nullable NSString *)contentNameKey localStoreNamed:(MR_nonnull NSString *)localStoreName cloudStorePathComponent:(MR_nullable NSString *)subPathComponent;
+ (MR_nonnull NSPersistentStoreCoordinator *) MR_coordinatorWithiCloudContainerID:(MR_nonnull NSString *)containerID contentNameKey:(MR_nullable NSString *)contentNameKey localStoreAtURL:(MR_nonnull NSURL *)storeURL cloudStorePathComponent:(MR_nullable NSString *)subPathComponent;

+ (MR_nonnull NSPersistentStoreCoordinator *) MR_coordinatorWithiCloudContainerID:(MR_nonnull NSString *)containerID contentNameKey:(MR_nullable NSString *)contentNameKey localStoreNamed:(MR_nonnull NSString *)localStoreName cloudStorePathComponent:(MR_nullable NSString *)subPathComponent completion:(void (^ __MR_nullable)(void))completionHandler;
+ (MR_nonnull NSPersistentStoreCoordinator *) MR_coordinatorWithiCloudContainerID:(MR_nonnull NSString *)containerID contentNameKey:(MR_nullable NSString *)contentNameKey localStoreAtURL:(MR_nonnull NSURL *)storeURL cloudStorePathComponent:(MR_nullable NSString *)subPathComponent completion:(void (^ __MR_nullable)(void))completionHandler;

- (MR_nullable NSPersistentStore *) MR_addInMemoryStore;
- (MR_nullable NSPersistentStore *) MR_addAutoMigratingSqliteStoreNamed:(MR_nonnull NSString *) storeFileName;
- (MR_nullable NSPersistentStore *) MR_addAutoMigratingSqliteStoreAtURL:(MR_nonnull NSURL *)storeURL;

- (MR_nullable NSPersistentStore *) MR_addSqliteStoreNamed:(MR_nonnull id)storeFileName withOptions:(MR_nullable __autoreleasing NSDictionary *)options;
- (MR_nullable NSPersistentStore *) MR_addSqliteStoreNamed:(MR_nonnull id)storeFileName configuration:(MR_nullable NSString *)configuration withOptions:(MR_nullable __autoreleasing NSDictionary *)options;

- (void) MR_addiCloudContainerID:(MR_nonnull NSString *)containerID contentNameKey:(MR_nullable NSString *)contentNameKey localStoreNamed:(MR_nonnull NSString *)localStoreName cloudStorePathComponent:(MR_nullable NSString *)subPathComponent;
- (void) MR_addiCloudContainerID:(MR_nonnull NSString *)containerID contentNameKey:(MR_nullable NSString *)contentNameKey localStoreAtURL:(MR_nonnull NSURL *)storeURL cloudStorePathComponent:(MR_nullable NSString *)subPathComponent;
- (void) MR_addiCloudContainerID:(MR_nonnull NSString *)containerID contentNameKey:(MR_nullable NSString *)contentNameKey localStoreNamed:(MR_nonnull NSString *)localStoreName cloudStorePathComponent:(MR_nullable NSString *)subPathComponent completion:(void (^ __MR_nullable)(void))completionBlock;
- (void) MR_addiCloudContainerID:(MR_nonnull NSString *)containerID contentNameKey:(MR_nullable NSString *)contentNameKey localStoreAtURL:(MR_nonnull NSURL *)storeURL cloudStorePathComponent:(MR_nullable NSString *)subPathComponent completion:(void (^ __MR_nullable)(void))completionBlock;

@end
