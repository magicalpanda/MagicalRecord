//
//  NSPersistentStoreCoordinator+MagicalRecord.m
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "CoreData+MagicalRecord.h"

//#import "NSPersistentStoreCoordinator+MagicalRecord.h"
//#import "NSManagedObjectModel+MagicalRecord.h"
//#import "NSPersistentStore+MagicalRecord.h"

static NSPersistentStoreCoordinator *defaultCoordinator_ = nil;

@implementation NSPersistentStoreCoordinator (MagicalRecord)

+ (NSPersistentStoreCoordinator *) MR_defaultStoreCoordinator
{
    @synchronized (self)
    {
        if (defaultCoordinator_ == nil)
        {
            defaultCoordinator_ = [self MR_newPersistentStoreCoordinator];
        }
    }
	return defaultCoordinator_;
}

+ (void) MR_setDefaultStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
	defaultCoordinator_ = coordinator;
}

- (void) createPathToStoreFileIfNeccessary:(NSURL *)urlForStore
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *pathToStore = [[urlForStore URLByDeletingLastPathComponent] path];
    
    NSError *error = nil;
    BOOL pathWasCreated = [fileManager createDirectoryAtPath:pathToStore withIntermediateDirectories:YES attributes:nil error:&error];

    if (!pathWasCreated) 
    {
        [MagicalRecordHelpers handleErrors:error];
    }
}

- (void) MR_setupSqliteStoreNamed:(id)storeFileName withOptions:(NSDictionary *)options
{
    NSURL *url = [storeFileName isKindOfClass:[NSURL class]] ? storeFileName : [NSPersistentStore MR_urlForStoreName:storeFileName];
    NSError *error = nil;
    
    [self createPathToStoreFileIfNeccessary:url];
    
    NSPersistentStore *store = [self addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil
                                                           URL:url
                                                       options:options
                                                         error:&error];
    if (!store) 
    {
        [MagicalRecordHelpers handleErrors:error];
    }
    [NSPersistentStore MR_setDefaultPersistentStore:store];        
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithPersitentStore:(NSPersistentStore *)persistentStore;
{
    NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    [psc MR_setupSqliteStoreNamed:[persistentStore URL] withOptions:nil];
    
    return psc;
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreNamed:(NSString *)storeFileName withOptions:(NSDictionary *)options
{
    NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    [psc MR_setupSqliteStoreNamed:storeFileName withOptions:options];
    
    return psc;
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreNamed:(NSString *)storeFileName
{
	return [self MR_coordinatorWithSqliteStoreNamed:storeFileName withOptions:nil];
}

- (void) MR_setupAutoMigratingSqliteStoreNamed:(NSString *) storeFileName
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];
    
    [self MR_setupSqliteStoreNamed:storeFileName withOptions:options];
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithAutoMigratingSqliteStoreNamed:(NSString *) storeFileName
{
    NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    [coordinator MR_setupAutoMigratingSqliteStoreNamed:storeFileName];
    
    //HACK: lame solution to fix automigration error "Migration failed after first pass"
    if ([[coordinator persistentStores] count] == 0) 
    {
        [coordinator performSelector:@selector(MR_setupAutoMigratingSqliteStoreNamed:) withObject:storeFileName afterDelay:0.5];
    }
    return coordinator;
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithInMemoryStore
{
	NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
	NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	
    [NSPersistentStore MR_setDefaultPersistentStore:[psc MR_addInMemoryStore]];
    return psc;
}

- (NSPersistentStore *) MR_addInMemoryStore
{
    NSError *error = nil;
    NSPersistentStore *store = [self addPersistentStoreWithType:NSInMemoryStoreType
                                                         configuration:nil 
                                                                   URL:nil
                                                               options:nil
                                                                 error:&error];
    if (!store)
    {
        [MagicalRecordHelpers handleErrors:error];
    }
    return store;
}

+ (NSPersistentStoreCoordinator *) MR_newPersistentStoreCoordinator
{
	return [self MR_coordinatorWithSqliteStoreNamed:kMagicalRecordDefaultStoreFileName];
}

@end
