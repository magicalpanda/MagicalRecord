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

- (void) setupSqliteStoreNamed:(NSString *)storeFileName withOptions:(NSDictionary *)options
{
  NSError *error = nil;
  NSPersistentStore *store = [self addPersistentStoreWithType:NSSQLiteStoreType
                                                configuration:nil
                                                          URL:[NSPersistentStore urlForStoreName:storeFileName]
                                                      options:options
                                                        error:&error];
  if (!store)
  {
    [ActiveRecordHelpers handleErrors:error];
    if(![[NSFileManager defaultManager] removeItemAtPath:[NSPersistentStore stringForStoreName:storeFileName] error:&error]) {
      DDLogInfo(@"Deleting the store at url %@ failed: %@", storeFileName, error);
    }else {
      // try once again!
      store = [self addPersistentStoreWithType:NSSQLiteStoreType
                                 configuration:nil
                                           URL:[NSPersistentStore urlForStoreName:storeFileName]
                                       options:options
                                         error:&error];
      if (!store)
      {
        DDLogError(@"Error: Can't even recreate the persistent store.");
      }
    }
  }
  [NSPersistentStore setDetaultPersistentStore:store];
}

- (void) setupAutoMigratingSqliteStoreNamed:(NSString *) storeFileName
{
  NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                           [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                           nil];
  
  [self setupSqliteStoreNamed:storeFileName withOptions:options];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreNamed:(NSString *)storeFileName
{
    NSManagedObjectModel *model = [NSManagedObjectModel defaultManagedObjectModel];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    [psc setupAutoMigratingSqliteStoreNamed:storeFileName];

    return [psc autorelease];
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

    [NSPersistentStore setDetaultPersistentStore:[psc addInMemoryStore]];
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
