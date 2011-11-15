//
//  NSPersistentStoreCoordinator+MagicalRecord.m
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "CoreData+MagicalRecord.h"

static NSPersistentStoreCoordinator *defaultCoordinator_ = nil;

@implementation NSPersistentStoreCoordinator (MagicalRecord)


+ (NSPersistentStoreCoordinator *) MR_defaultStoreCoordinator
{
    if (defaultCoordinator_ == nil && [MagicalRecordHelpers shouldAutoCreateDefaultPersistentStoreCoordinator])
    {
        defaultCoordinator_ = [self MR_newPersistentStoreCoordinator];
    }
	return defaultCoordinator_;
}

+ (void) MR_setDefaultStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
#ifndef NS_AUTOMATED_REFCOUNT_UNAVAILABLE
    [coordinator retain];
    [defaultCoordinator_ release];
#endif
	defaultCoordinator_ = coordinator;
    
    if (defaultCoordinator_ != nil && [NSPersistentStore MR_defaultPersistentStore] == nil)
    {
        NSArray *persistentStores = [defaultCoordinator_ persistentStores];
        if ([persistentStores count])
        {
            [NSPersistentStore MR_setDefaultPersistentStore:[persistentStores objectAtIndex:0]];
        }
    }
}

- (void) MR_createPathToStoreFileIfNeccessary:(NSURL *)urlForStore
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *pathToStore = [urlForStore URLByDeletingLastPathComponent];
    
    NSError *error = nil;
    BOOL pathWasCreated = [fileManager createDirectoryAtPath:[pathToStore path] withIntermediateDirectories:YES attributes:nil error:&error];

    if (!pathWasCreated) 
    {
        [MagicalRecordHelpers handleErrors:error];
    }
}

- (void) MR_setupSqliteStoreNamed:(id)storeFileName withOptions:(NSDictionary *)options
{
    NSURL *url = [storeFileName isKindOfClass:[NSURL class]] ? storeFileName : [NSPersistentStore MR_urlForStoreName:storeFileName];
    NSError *error = nil;
    
    [self MR_createPathToStoreFileIfNeccessary:url];
    
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
    
#ifndef NS_AUTOMATED_REFCOUNT_UNAVAILABLE
    [psc autorelease];
#endif
    return psc;
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreNamed:(NSString *)storeFileName withOptions:(NSDictionary *)options
{
    NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    [psc MR_setupSqliteStoreNamed:storeFileName withOptions:options];
    
#ifndef NS_AUTOMATED_REFCOUNT_UNAVAILABLE
    [psc autorelease];
#endif
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
#ifndef NS_AUTOMATED_REFCOUNT_UNAVAILABLE
    [coordinator autorelease];
#endif
    return coordinator;

}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithInMemoryStore
{
	NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
	NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    [psc MR_addInMemoryStore];

#ifndef NS_AUTOMATED_REFCOUNT_UNAVAILABLE
    [psc autorelease];
#endif
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
	NSPersistentStoreCoordinator *coordinator = [self MR_coordinatorWithSqliteStoreNamed:kMagicalRecordDefaultStoreFileName];
#ifndef NS_AUTOMATED_REFCOUNT_UNAVAILABLE
    [coordinator retain];
#endif
    return coordinator;

}

@end
