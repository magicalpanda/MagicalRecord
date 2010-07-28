//
//  ActiveRecordHelpers.m
//  DocBook
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Willow Tree Mobile, Inc. All rights reserved.
//

#import "ActiveRecordHelpers.h"
#import "NSManagedObjectContext+ActiveRecord.h"
#import "NSPersistentStoreCoordinator+ActiveRecord.h"
#import "NSManagedObjectModel+ActiveRecord.h"
#import "NSPersistentStore+ActiveRecord.h"

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
						NSLog(@"Error Details: %@", [e userInfo]);
					}
					else
					{
						NSLog(@"Error Details: %@", e);
					}
				}
			}
			else
			{
				NSLog(@"Error: %@", detailedError);
			}
		}
		NSLog(@"Error Domain: %@", [error domain]);
		NSLog(@"Recovery Suggestion: %@", [error localizedRecoverySuggestion]);	
	}
}

- (void) handleErrors:(NSError *)error
{
	[[self class] handleErrors:error];
}

+ (void) setupDefaultCoreDataStack
{
    NSManagedObjectContext *context = [NSManagedObjectContext context];
	[NSManagedObjectContext setDefaultContext:context];
}

+ (void) setupAutoMigratingDefaultCoreDataStack
{
    [self setupCoreDataStackWithAutoMigratingSqliteStoreNamed:kActiveRecordDefaultStoreFileName];
}

+ (void) setupDefaultCoreDataStackWithStoreNamed:(NSString *)storeName
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

@end
