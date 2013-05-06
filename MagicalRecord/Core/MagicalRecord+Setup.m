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
#import "NSManagedObjectContext+MagicalRecord.h"

@implementation MagicalRecord (Setup)

+ (void) setupCoreDataStack
{
    [self setupCoreDataStackWithStoreNamed:[self defaultStoreName]];
}

+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName
{
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;

	NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:storeName];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];

    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

+ (void) setupAutoMigratingCoreDataStack
{
    [self setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[self defaultStoreName]];
}

+ (void) setupAutoMigratingCoreDataStackWithSqliteStoreNamed:(NSString *)storeName;
{
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;

    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithAutoMigratingSqliteStoreNamed:storeName];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];

    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(NSString *)storeName //depricated
{
    [self setupAutoMigratingCoreDataStackWithSqliteStoreNamed:storeName];
}

+ (void) setupManuallyMigratingCoreDataStack;
{
    [self setupAutoMigratingCoreDataStackWithSqliteStoreNamed:[self defaultStoreName]];
}

+ (void) setupManuallyMigratingCoreDataStackWithSqliteStoreNamed:(NSString *)storeName;
{
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;

    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithManuallyMigratingSqliteStoreNamed:storeName];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];

    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

+ (void) setupCoreDataStackWithInMemoryStore;
{
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;
    
	NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithInMemoryStore];
	[NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
	
    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

+ (void) setupCoreDataStackWithStoreAtURL:(NSURL *)url;
{
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;

	NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreAtURL:url];
	[NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];

    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

@end
