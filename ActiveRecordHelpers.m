//
//  ActiveRecordHelpers.m
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "ActiveRecordHelpers.h"
#import "NSManagedObjectContext+ActiveRecord.h"
#import "NSPersistentStoreCoordinator+ActiveRecord.h"
#import "NSManagedObjectModel+ActiveRecord.h"
#import "NSPersistentStore+ActiveRecord.h"
#import <dispatch/dispatch.h>

@implementation ActiveRecordHelpers

+ (void) cleanUp
{
	[NSManagedObjectContext setDefaultContext:nil];
	[NSManagedObjectModel setDefaultManagedObjectModel:nil];
	[NSPersistentStoreCoordinator setDefaultStoreCoordinator:nil];
	[NSPersistentStore setDetaultPersistentStore:nil];
}

+ (void) handleErrors:(NSError *)error
{
	if (error)
	{
		NSDictionary *userInfo = [error userInfo];
		for (NSArray *detailedError in [userInfo allValues])
		{
			if ([detailedError isKindOfClass:[NSArray class]])
			{
				for (NSError *e in detailedError)
				{
					if ([e respondsToSelector:@selector(userInfo)])
					{
						ARLog(@"Error Details: %@", [e userInfo]);
					}
					else
					{
						ARLog(@"Error Details: %@", e);
					}
				}
			}
			else
			{
				ARLog(@"Error: %@", detailedError);
			}
		}
		ARLog(@"Error Domain: %@", [error domain]);
		ARLog(@"Recovery Suggestion: %@", [error localizedRecoverySuggestion]);	
	}
}

- (void) handleErrors:(NSError *)error
{
	[[self class] handleErrors:error];
}

+ (void) setupCoreDataStack
{
    NSManagedObjectContext *context = [NSManagedObjectContext context];
	[NSManagedObjectContext setDefaultContext:context];
}

+ (void) setupAutoMigratingCoreDataStack
{
    [self setupCoreDataStackWithAutoMigratingSqliteStoreNamed:kActiveRecordDefaultStoreFileName];
}

+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName
{
	NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator coordinatorWithSqliteStoreNamed:storeName];
	[NSPersistentStoreCoordinator setDefaultStoreCoordinator:coordinator];
	
	NSManagedObjectContext *context = [NSManagedObjectContext contextWithStoreCoordinator:coordinator];
	[NSManagedObjectContext setDefaultContext:context];
}

+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(NSString *)storeName
{
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator coordinatorWithAutoMigratingSqliteStoreNamed:storeName];
    [NSPersistentStoreCoordinator setDefaultStoreCoordinator:coordinator];
    
    NSManagedObjectContext *context = [NSManagedObjectContext contextWithStoreCoordinator:coordinator];
    [NSManagedObjectContext setDefaultContext:context];
}

+ (void) setupCoreDataStackWithInMemoryStore
{
	NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator coordinatorWithInMemoryStore];
	[NSPersistentStoreCoordinator setDefaultStoreCoordinator:coordinator];
	
	NSManagedObjectContext *context = [NSManagedObjectContext contextWithStoreCoordinator:coordinator];
	[NSManagedObjectContext setDefaultContext:context];
}

#ifdef NS_BLOCKS_AVAILABLE

+ (void) performSaveDataOperationWithBlock:(CoreDataBlock)block
{   
    NSManagedObjectContext *mainContext  = [NSManagedObjectContext defaultContext];
    NSManagedObjectContext *localContext = mainContext;
    
    if (![NSThread isMainThread]) 
    {
        
#if kCreateNewCoordinatorOnBackgroundOperations == 1
        NSPersistentStoreCoordinator *localCoordinator = [NSPersistentStoreCoordinator coordinatorWithPersitentStore:[NSPersistentStore defaultPersistentStore]];
        localContext = [NSManagedObjectContext contextThatNotifiesDefaultContextOnMainThreadWithCoordinator:localCoordinator];
#else
        localContext = [NSManagedObjectContext contextThatNotifiesDefaultContextOnMainThread];
#endif
        
        [mainContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
        [localContext setMergePolicy:NSOverwriteMergePolicy];
    }
    
    block(localContext);
    
    if ([localContext hasChanges]) 
    {
        [localContext save];
    }
    
    localContext.notifiesMainContextOnSave = NO;
    [mainContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
}

+ (void) performSaveDataOperationInBackgroundWithBlock:(CoreDataBlock)block
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self performSaveDataOperationWithBlock:block];
    });
}

+ (void) performSaveDataOperationInBackgroundWithBlock:(CoreDataBlock)block completion:(void(^)(void))callback
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self performSaveDataOperationWithBlock:block];
        
        if (callback) 
        {
            dispatch_async(dispatch_get_main_queue(), callback);
        }
    });
}

+ (void) performLookupOperationWithBlock:(CoreDataBlock)block
{
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    
    block(context);
}

#endif

@end
