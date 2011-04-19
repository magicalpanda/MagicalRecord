//
//  NSPersistentStoreCoordinator+ActiveRecord.m
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "NSPersistentStoreCoordinator+ActiveRecord.h"
#import "NSManagedObjectModel+ActiveRecord.h"
#import "NSPersistentStore+ActiveRecord.h"

static NSPersistentStoreCoordinator *defaultCoordinator = nil;

@implementation NSPersistentStoreCoordinator (ActiveRecord)

+ (NSPersistentStoreCoordinator *) defaultStoreCoordinator
{
    @synchronized (self)
    {
        if (defaultCoordinator == nil)
        {
            defaultCoordinator = [self newPersistentStoreCoordinator];
        }
    }
	return defaultCoordinator;
}

+ (void) setDefaultStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
	[defaultCoordinator release];
	defaultCoordinator = [coordinator retain];
}

- (void) setupSqliteStoreNamed:(id)storeFileName withOptions:(NSDictionary *)options
{
    NSURL *url = [storeFileName isKindOfClass:[NSURL class]] ? storeFileName : [NSPersistentStore urlForStoreName:storeFileName];
    NSError *error = nil;
    NSPersistentStore *store = [self addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil
                                                           URL:url
                                                       options:options
                                                         error:&error];
    if (!store) 
    {
        [ActiveRecordHelpers handleErrors:error];
    }
    [NSPersistentStore setDefaultPersistentStore:store];        
}

+ (NSPersistentStoreCoordinator *) coordinatorWithPersitentStore:(NSPersistentStore *)persistentStore;
{
    NSManagedObjectModel *model = [NSManagedObjectModel defaultManagedObjectModel];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    [psc setupSqliteStoreNamed:[persistentStore URL] withOptions:nil];
    
    return [psc autorelease];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreNamed:(NSString *)storeFileName withOptions:(NSDictionary *)options
{
    NSManagedObjectModel *model = [NSManagedObjectModel defaultManagedObjectModel];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    [psc setupSqliteStoreNamed:storeFileName withOptions:options];
    
    return [psc autorelease];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreNamed:(NSString *)storeFileName
{
	return [self coordinatorWithSqliteStoreNamed:storeFileName withOptions:nil];
}

- (void) setupAutoMigratingSqliteStoreNamed:(NSString *) storeFileName
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];
    
    [self setupSqliteStoreNamed:storeFileName withOptions:options];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithAutoMigratingSqliteStoreNamed:(NSString *) storeFileName
{
    NSManagedObjectModel *model = [NSManagedObjectModel defaultManagedObjectModel];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    [coordinator setupAutoMigratingSqliteStoreNamed:storeFileName];
    
    //HACK: lame solution to fix automigration error "Migration failed after first pass"
    if ([[coordinator persistentStores] count] == 0) 
    {
        [coordinator performSelector:@selector(setupAutoMigratingSqliteStoreNamed:) withObject:storeFileName afterDelay:0.5];
    }
    return [coordinator autorelease];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithInMemoryStore
{
	NSManagedObjectModel *model = [NSManagedObjectModel defaultManagedObjectModel];
	NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	
    [NSPersistentStore setDefaultPersistentStore:[psc addInMemoryStore]];
	return [psc autorelease];
}

- (NSPersistentStore *) addInMemoryStore
{
    NSError *error = nil;
    NSPersistentStore *store = [self addPersistentStoreWithType:NSInMemoryStoreType
                                                         configuration:nil 
                                                                   URL:nil
                                                               options:nil
                                                                 error:&error];
    if (!store)
    {
        [ActiveRecordHelpers handleErrors:error];
    }
    return store;
}

+ (NSPersistentStoreCoordinator *) newPersistentStoreCoordinator
{
	return [[self coordinatorWithSqliteStoreNamed:kActiveRecordDefaultStoreFileName] retain];
}

@end
