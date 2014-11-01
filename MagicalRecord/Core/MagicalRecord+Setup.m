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


static NSOperationQueue *coreDataMainQueue;

+ (void)load
{
    coreDataMainQueue = [NSOperationQueue mainQueue];
}

+ (void)MR_setMainThread:(NSOperationQueue*)queue
{
    queue.maxConcurrentOperationCount = 1;
//    NSAssert([NSManagedObjectContext MR_defaultContext] == nil, @"main thread mast be seted before coreData stack setup");
    coreDataMainQueue = queue;
}

+ (NSOperationQueue*)MR_mainThread
{
    return coreDataMainQueue;
}


+ (void) setupCoreDataStack
{
    NSAssert([NSOperationQueue mainQueue] == CoreDataMainThread, @"core data stack setup mast be called from CoreDataMainThread");
    
    [self setupCoreDataStackWithStoreNamed:[self defaultStoreName]];
}

+ (void) setupAutoMigratingCoreDataStack
{
    NSAssert([NSOperationQueue mainQueue] == CoreDataMainThread, @"core data stack setup mast be called from CoreDataMainThread");
    
    [self setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[self defaultStoreName]];
}

+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName
{
    NSAssert([NSOperationQueue mainQueue] == CoreDataMainThread, @"core data stack setup mast be called from CoreDataMainThread");
    
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;
    
	NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:storeName];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
	
    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(NSString *)storeName
{
    NSAssert([NSOperationQueue mainQueue] == CoreDataMainThread, @"core data stack setup mast be called from CoreDataMainThread");
    
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;
    
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithAutoMigratingSqliteStoreNamed:storeName];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
    
    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

+ (void) setupCoreDataStackWithStoreAtURL:(NSURL *)storeURL
{
    NSAssert([NSOperationQueue mainQueue] == CoreDataMainThread, @"core data stack setup mast be called from CoreDataMainThread");
    
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;
    
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreAtURL:storeURL];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
    
    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreAtURL:(NSURL *)storeURL
{
    NSAssert([NSOperationQueue mainQueue] == CoreDataMainThread, @"core data stack setup mast be called from CoreDataMainThread");
    
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;
    
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithAutoMigratingSqliteStoreAtURL:storeURL];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
    
    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

+ (void) setupCoreDataStackWithInMemoryStore;
{
    NSAssert([NSOperationQueue mainQueue] == CoreDataMainThread, @"core data stack setup mast be called from CoreDataMainThread");
    
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;
    
	NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithInMemoryStore];
	[NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
	
    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

@end
