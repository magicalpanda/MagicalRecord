//
//  NSPersistentStoreCoordinator+MagicalRecord.m
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "CoreData+MagicalRecord.h"
#import "MagicalRecordStack.h"

#if MR_LOG_LEVEL >= 0
static NSInteger ddLogLevel = MR_LOG_LEVEL;
#endif

//static NSPersistentStoreCoordinator *defaultCoordinator_ = nil;
NSString * const kMagicalRecordPSCDidCompleteiCloudSetupNotification = @"kMagicalRecordPSCDidCompleteiCloudSetupNotification";

@interface NSDictionary (MagicalRecordAdditions)

- (NSMutableDictionary*) MR_dictionaryByMergingDictionary:(NSDictionary*)d; 
+ (NSDictionary *) MR_defaultSqliteStoreOptions;
+ (NSDictionary *) MR_autoMigrationOptions;
+ (NSDictionary *) MR_manualMigrationOptions;

@end 

@interface MagicalRecord (iCloudPrivate)

+ (void) setICloudEnabled:(BOOL)enabled;

@end

@implementation NSPersistentStoreCoordinator (MagicalRecord)

//+ (NSPersistentStoreCoordinator *) MR_defaultStoreCoordinator
//{
//    if (defaultCoordinator_ == nil && [MagicalRecord shouldAutoCreateDefaultPersistentStoreCoordinator])
//    {
//        [self MR_setDefaultStoreCoordinator:[self MR_newPersistentStoreCoordinator]];
//    }
//	return defaultCoordinator_;
//}
//
//+ (void) MR_setDefaultStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
//{
//	defaultCoordinator_ = coordinator;
//    
//    if (defaultCoordinator_ != nil)
//    {
//        NSArray *persistentStores = [defaultCoordinator_ persistentStores];
//        
//        if ([persistentStores count] && [NSPersistentStore MR_defaultPersistentStore] == nil)
//        {
//            [NSPersistentStore MR_setDefaultPersistentStore:[persistentStores objectAtIndex:0]];
//        }
//    }
//}

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
    NSURL *url = [storeFileName isKindOfClass:[NSURL class]] ? storeFileName : [NSPersistentStore MR_urlForStoreName:storeFileName];
    return [self MR_addSqliteStoreAtURL:url withOptions:options];
}

- (NSPersistentStore *) MR_reinitializeStoreAtURL:(NSURL *)url fromError:(NSError *)error withOptions:(NSDictionary *__autoreleasing)options;
{
    if (![MagicalRecord shouldDeleteStoreOnModelMismatch]) return nil;

    NSPersistentStore *store = nil;
    BOOL isMigrationError = [error code] == NSPersistentStoreIncompatibleVersionHashError || [error code] == NSMigrationMissingSourceModelError;
    if ([[error domain] isEqualToString:NSCocoaErrorDomain] && isMigrationError)
    {
        if ([[error domain] isEqualToString:NSCocoaErrorDomain] && isMigrationError)
        {
            // Could not open the database, so... kill it! (AND WAL bits)
            NSString *rawURL = [url absoluteString];
            NSURL *shmSidecar = [NSURL URLWithString:[rawURL stringByAppendingString:@"-shm"]];
            NSURL *walSidecar = [NSURL URLWithString:[rawURL stringByAppendingString:@"-wal"]];

            for (NSURL *toRemove in [NSArray arrayWithObjects:url, shmSidecar, walSidecar, nil])
            {
                [[NSFileManager defaultManager] removeItemAtURL:toRemove error:nil];
            }

            MRLog(@"Removed incompatible model version: %@", [url lastPathComponent]);
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

    MRLog(@"Adding store at [%@] to NSPSC with options [%@]", url, options);
    @try {
        
        NSError *error = nil;
        NSPersistentStore *store = [self addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration:nil
                                                                URL:url
                                                            options:options
                                                              error:&error];
        if (store == nil && error == nil)
        {
            store = [self MR_reinitializeStoreAtURL:url fromError:error withOptions:options];
        }
        if (error)
        {
            MRLog(@"Unable to setup store at URL: %@", url);
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
+ (NSPersistentStoreCoordinator *) MR_coordinatorWithPersistentStore:(NSPersistentStore *)persistentStore;
{
    NSManagedObjectModel *model = [[MagicalRecordStack defaultStack] model];
    NSPersistentStoreCoordinator *psc = [[self alloc] initWithManagedObjectModel:model];

    [psc MR_addSqliteStoreNamed:[persistentStore URL] withOptions:nil];

    return psc;
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreNamed:(NSString *)storeFileName withOptions:(NSDictionary *)options
{
    NSManagedObjectModel *model = [[MagicalRecordStack defaultStack] model];
    NSPersistentStoreCoordinator *psc = [[self alloc] initWithManagedObjectModel:model];
    
    [psc MR_addSqliteStoreNamed:storeFileName withOptions:options];
    return psc;
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreNamed:(NSString *)storeFileName
{
	return [self MR_coordinatorWithSqliteStoreNamed:storeFileName withOptions:nil];
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreAtURL:(NSURL *)url;
{
    NSManagedObjectModel *model = [[MagicalRecordStack defaultStack] model];
    NSPersistentStoreCoordinator *psc = [[self alloc] initWithManagedObjectModel:model];

    [psc MR_addSqliteStoreAtURL:url withOptions:nil];
    return psc;
}

@end


