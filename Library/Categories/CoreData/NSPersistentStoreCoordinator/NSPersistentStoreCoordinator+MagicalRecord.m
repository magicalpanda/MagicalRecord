//
//  NSPersistentStoreCoordinator+MagicalRecord.m
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "NSDictionary+MagicalRecordAdditions.h"
#import "MagicalRecord.h"
#import "MagicalRecordLogging.h"

NSString * const MagicalRecordShouldDeletePersistentStoreOnModelMismatchKey = @"MagicalRecordShouldDeletePersistentStoreOnModelMistachKey";

@implementation NSPersistentStoreCoordinator (MagicalRecord)

+ (void) MR_createPathToStoreFileIfNeccessary:(NSURL *)urlForStore
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *pathToStore = [urlForStore URLByDeletingLastPathComponent];
    
    NSError *error = nil;
    BOOL pathWasCreated = [fileManager createDirectoryAtPath:[pathToStore path] withIntermediateDirectories:YES attributes:nil error:&error];

    if (!pathWasCreated) 
    {
        [[error MR_coreDataDescription] MR_logToConsole];
    }
}

- (NSPersistentStore *) MR_addSqliteStoreNamed:(id)storeFileName withOptions:(__autoreleasing NSDictionary *)options;
{
    NSURL *url = [storeFileName isKindOfClass:[NSURL class]] ? storeFileName : [NSPersistentStore MR_fileURLForStoreName:storeFileName];
    return [self MR_addSqliteStoreAtURL:url withOptions:options];
}

- (NSPersistentStore *) MR_reinitializeStoreAtURL:(NSURL *)url fromError:(NSError *)error withOptions:(NSDictionary *__autoreleasing)options;
{
    NSPersistentStore *store = nil;
    BOOL isMigrationError = [error code] == NSMigrationError ||
                            [error code] == NSMigrationMissingSourceModelError ||
                            [error code] == NSPersistentStoreIncompatibleVersionHashError;
    if ([[error domain] isEqualToString:NSCocoaErrorDomain] && isMigrationError)
    {
        if ([[error domain] isEqualToString:NSCocoaErrorDomain] && isMigrationError)
        {
            // Could not open the database, so... kill it! (AND WAL bits)
            [NSPersistentStore MR_removePersistentStoreFilesAtURL:url];
            MRLogInfo(@"Removed incompatible model version: %@", [url lastPathComponent]);
        }

        // Try one more time to create the store
        store = [self addPersistentStoreWithType:NSSQLiteStoreType
                                   configuration:nil
                                             URL:url
                                         options:options
                                           error:&error];
        if (store)
        {
            // If we successfully added a store, remove the error that was initially created
            error = nil;
        }
    }

    return store;
}

- (NSPersistentStore *) MR_addSqliteStoreAtURL:(NSURL *)url withOptions:(NSDictionary *__autoreleasing)options;
{
    [[self class] MR_createPathToStoreFileIfNeccessary:url];

    MRLogVerbose(@"Adding store at [%@] to NSPSC with options [%@]", url, options);
    @try {
        
        NSError *error = nil;
        NSPersistentStore *store = [self addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration:nil
                                                                URL:url
                                                            options:options
                                                              error:&error];
        
        if ([options MR_shouldDeletePersistentStoreOnModelMismatch] && store == nil && error != nil)
        {
            store = [self MR_reinitializeStoreAtURL:url fromError:error withOptions:options];
        }
        if (error)
        {
            MRLogError(@"Unable to setup store at URL: %@", url);
            [[error MR_coreDataDescription] MR_logToConsole];
        }
        return store;
    }
    @catch (NSException *exception)
    {
        [[exception description] MR_logToConsole];
    }
    return nil;
}

+ (NSPersistentStoreCoordinator *) MR_newPersistentStoreCoordinator
{
	NSPersistentStoreCoordinator *coordinator = [self MR_coordinatorWithSqliteStoreNamed:[MagicalRecord defaultStoreName]];

    return coordinator;
}

#pragma mark - Persistent Store Initializers

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithPersistentStore:(NSPersistentStore *)persistentStore;
{
    NSManagedObjectModel *defaultStackModel = [[MagicalRecordStack defaultStack] model];

    return [self MR_coordinatorWithPersistentStore:persistentStore andModel:defaultStackModel];;
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithPersistentStore:(NSPersistentStore *)persistentStore andModel:(NSManagedObjectModel *)model;
{
    return [self MR_coordinatorWithPersistentStore:persistentStore andModel:model withOptions:nil];
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithPersistentStore:(NSPersistentStore *)persistentStore andModel:(NSManagedObjectModel *)model withOptions:(NSDictionary *)options;
{
    NSPersistentStoreCoordinator *psc = [[self alloc] initWithManagedObjectModel:model];

    [psc MR_addSqliteStoreNamed:[persistentStore URL] withOptions:options];

    return psc;
}

#pragma mark - Store Name Initializers

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreNamed:(NSString *)storeFileName;
{
	return [self MR_coordinatorWithSqliteStoreNamed:storeFileName withOptions:nil];
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreNamed:(NSString *)storeFileName withOptions:(NSDictionary *)options;
{
    NSManagedObjectModel *defaultStackModel = [[MagicalRecordStack defaultStack] model];

    return [self MR_coordinatorWithSqliteStoreNamed:storeFileName andModel:defaultStackModel withOptions:options];
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreNamed:(NSString *)storeFileName andModel:(NSManagedObjectModel *)model withOptions:(NSDictionary *)options;
{
    NSPersistentStoreCoordinator *psc = [[self alloc] initWithManagedObjectModel:model];

    [psc MR_addSqliteStoreNamed:storeFileName withOptions:options];

    return psc;
}

#pragma mark - URL Initializers

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreAtURL:(NSURL *)url;
{
    NSManagedObjectModel *defaultStackModel = [[MagicalRecordStack defaultStack] model];

    return [self MR_coordinatorWithSqliteStoreAtURL:url andModel:defaultStackModel];
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreAtURL:(NSURL *)url andModel:(NSManagedObjectModel *)model;
{
    return [self MR_coordinatorWithSqliteStoreAtURL:url andModel:model withOptions:nil];
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreAtURL:(NSURL *)url andModel:(NSManagedObjectModel *)model withOptions:(NSDictionary *)options;
{
    NSPersistentStoreCoordinator *psc = [[self alloc] initWithManagedObjectModel:model];

    [psc MR_addSqliteStoreAtURL:url withOptions:options];

    return psc;
}

@end


