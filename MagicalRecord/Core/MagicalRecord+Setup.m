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

#if MR_LOG_LEVEL >= 0
static NSInteger ddLogLevel = MR_LOG_LEVEL;
#endif

@implementation MagicalRecord (Setup)

+ (void) setupCoreDataStack
{
    [self setupCoreDataStackWithStoreNamed:[self defaultStoreName]];
}

+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName
{
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;

    MRLog(@"Setting up Core Data Stack with store named: %@", storeName);
	NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:storeName];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];

    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

+ (void) setupCoreDataStackWithStoreAtURL:(NSURL *)url;
{
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;

    MRLog(@"Setting up Core Data Stack with store at URL: %@", url);
	NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreAtURL:url];
	[NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];

    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

#pragma mark - Auto Migration Stack Setup

+ (void) setupAutoMigratingCoreDataStack
{
    [self setupAutoMigratingCoreDataStackWithSqliteStoreNamed:[self defaultStoreName]];
}

+ (void) setupAutoMigratingCoreDataStackWithSqliteStoreNamed:(NSString *)storeName;
{
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;

    MRLog(@"Setting up AUTO MIGRATING Core Data Stack with store named: %@", storeName);
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithAutoMigratingSqliteStoreNamed:storeName];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];

    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

+ (void) setupAutoMigratingCoreDataStackWithSqliteStoreAtURL:(NSURL *)url;
{
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;

    MRLog(@"Setting up AUTO MIGRATING Core Data Stack with store at url: %@", url);
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithAutoMigratingSqliteStoreAtURL:url];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];

    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

#pragma mark - Manual Migration Stack Setup

+ (void) setupManuallyMigratingCoreDataStack;
{
    [self setupManuallyMigratingCoreDataStackWithSqliteStoreNamed:[self defaultStoreName]];
}

+ (void) setupManuallyMigratingCoreDataStackWithSqliteStoreNamed:(NSString *)storeName;
{
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;

    MRLog(@"Setting up MANUALLY MIGRATING Core Data Stack with store named: %@", storeName);
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithManuallyMigratingSqliteStoreNamed:storeName];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];

    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

+ (void) setupManuallyMigratingCoreDataStackWithSqliteStoreAtURL:(NSURL *)url;
{
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;

    MRLog(@"Setting up MANUALLY MIGRATING Core Data Stack with store at url: %@", url);
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithManuallyMigratingSqliteStoreAtURL:url];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];

    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

#pragma mark - In Memory Stack Setup

+ (void) setupCoreDataStackWithInMemoryStore;
{
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;

    MRLog(@"Setting up IN MEMORY Core Data Stack");
	NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithInMemoryStore];
	[NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
	
    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

@end
