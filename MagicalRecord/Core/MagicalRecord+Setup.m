//
//  MagicalRecord+Setup.m
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord+Setup.h"
#import "NSManagedObject+MagicalRecord.h"
#import "NSPersistentStoreCoordinator+MagicalRecord.h"
#import "MagicalrecordNoBackupHelper.h"
#import "NSManagedObjectContext+MagicalRecord.h"

@implementation MagicalRecord (Setup)

+ (void) setupCoreDataStack
{
    [self setupCoreDataStackWithStoreNamed:[self defaultStoreName]];
}

+ (void) setupCoreDataStackWithoutiCloudBackup
{
    [self setupCoreDataStackWithoutiCloudBackupAndWithStoreNamed:[self defaultStoreName]];
}

+ (void) setupAutoMigratingCoreDataStack
{
    [self setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[self defaultStoreName]];
}

+ (void) setupAutoMigratingCoreDataStackWithoutiCloudBackup
{
    [self setupCoreDataStackWithAutoMigratingSqliteWithoutiCloudBackupAndStoreNamed:[self defaultStoreName]];
}

+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName
{
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;
    
	NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:storeName];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
	
    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

+ (void) setupCoreDataStackWithoutiCloudBackupAndWithStoreNamed:(NSString *)storeName
{
    NSString *noBackupStoreName = [NSString stringWithFormat:@"noBackup/%@", storeName];
    
    [self setupCoreDataStackWithStoreNamed:noBackupStoreName];
    
    NSURL *storeLocation = [[NSPersistentStore MR_urlForStoreName:noBackupStoreName] URLByDeletingLastPathComponent];
    [MagicalrecordNoBackupHelper addSkipBackupAttributeToItemAtURL:storeLocation];
}

+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(NSString *)storeName
{
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;
    
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithAutoMigratingSqliteStoreNamed:storeName];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
    
    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

+ (void) setupCoreDataStackWithAutoMigratingSqliteWithoutiCloudBackupAndStoreNamed:(NSString *)storeName
{
    NSString *noBackupStoreName = [NSString stringWithFormat:@"noBackup/%@", storeName];
    
    [self setupCoreDataStackWithAutoMigratingSqliteStoreNamed:noBackupStoreName];
    
    NSURL *storeLocation = [[NSPersistentStore MR_urlForStoreName:noBackupStoreName] URLByDeletingLastPathComponent];
    [MagicalrecordNoBackupHelper addSkipBackupAttributeToItemAtURL:storeLocation];
}

+ (void) setupCoreDataStackWithInMemoryStore;
{
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;
    
	NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithInMemoryStore];
	[NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
	
    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

@end
