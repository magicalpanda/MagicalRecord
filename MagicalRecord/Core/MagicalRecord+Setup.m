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

+ (void) setupAutoMigratingCoreDataStack
{
    [self setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[self defaultStoreName]];
}

+ (void) setupAutoMigratingCoreDataStackWithType:(NSString*)storeType
{
    [self setupCoreDataStackWithAutoMigratingCustomStoreNamed:[self defaultStoreName] andCustomStoreType:storeType];
}

+ (void) setupCoreDataStackWithType:(NSString*)storeType
{
    [self setupCoreDataStackWithStoreNamed:[self defaultStoreName] andCustomStoreType:storeType];
}

+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName andCustomStoreType:(NSString*)storeType {
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;
    
	NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithCustomStoreNamed:storeName storeType:storeType];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
	
    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName
{
    [self setupCoreDataStackWithStoreNamed:storeName andCustomStoreType:nil];
}

+ (void) setupCoreDataStackWithAutoMigratingCustomStoreNamed:(NSString *)storeName andCustomStoreType:(NSString*)storeType
{
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;
    
    if (!storeName) {
        storeName = [self defaultStoreName];
    }
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithAutoMigratingCustomStoreNamed:storeName storeType:storeType];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
    
    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(NSString *)storeName
{
    [self setupCoreDataStackWithAutoMigratingCustomStoreNamed:storeName andCustomStoreType:NSSQLiteStoreType];
}

+ (void) setupCoreDataStackWithInMemoryStore;
{
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;
    
	NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithInMemoryStore];
	[NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
	
    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

@end
