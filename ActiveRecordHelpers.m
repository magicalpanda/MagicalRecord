//
//  ActiveRecordHelpers.m
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "ActiveRecordHelpers.h"
#import "ARCoreDataAction.h"
#import "NSManagedObjectContext+ActiveRecord.h"
#import "NSPersistentStoreCoordinator+ActiveRecord.h"
#import "NSManagedObjectModel+ActiveRecord.h"
#import "NSPersistentStore+ActiveRecord.h"
#import <dispatch/dispatch.h>

static id errorHandlerTarget = nil;
static SEL errorHandlerAction = nil;

@implementation ActiveRecordHelpers

+ (void) cleanUp
{
	[ARCoreDataAction cleanUp];
	[NSManagedObjectContext setDefaultContext:nil];
	[NSManagedObjectModel setDefaultManagedObjectModel:nil];
	[NSPersistentStoreCoordinator setDefaultStoreCoordinator:nil];
	[NSPersistentStore setDefaultPersistentStore:nil];
}

+ (void) defaultErrorHandler:(NSError *)error
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

+ (void) handleErrors:(NSError *)error
{
	if (error)
	{
        // If a custom error handler is set, call that
        if (errorHandlerTarget != nil && errorHandlerAction != nil) 
		{
            [errorHandlerTarget performSelector:errorHandlerAction withObject:error];
        }
		else
		{
	        // Otherwise, fall back to the default error handling
	        [self defaultErrorHandler:error];			
		}
    }
}

+ (void) setErrorHandlerTarget:(id)target action:(SEL)action
{
    errorHandlerTarget = target;    /* Deliberately don't retain to avoid potential retain cycles */
    errorHandlerAction = action;
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
#pragma mark DEPRECATED_METHOD

+ (void) performSaveDataOperationWithBlock:(CoreDataBlock)block;
{
    [ARCoreDataAction saveDataWithBlock:block];
}

+ (void) performSaveDataOperationInBackgroundWithBlock:(CoreDataBlock)block;
{
    [ARCoreDataAction saveDataWithBlock:block];
}

+ (void) performLookupOperationWithBlock:(CoreDataBlock)block;
{
    [ARCoreDataAction lookupWithBlock:block];
}

+ (void) performSaveDataOperationInBackgroundWithBlock:(CoreDataBlock)block completion:(void(^)(void))callback;
{
    [ARCoreDataAction saveDataInBackgroundWithBlock:block completion:callback];
}

#endif

@end
