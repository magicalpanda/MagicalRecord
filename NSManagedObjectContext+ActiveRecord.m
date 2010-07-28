//
//  NSManagedObjectContext+ActiveRecord.m
//  Conference
//
//  Created by Saul Mora on 11/23/09.
//  Copyright 2009 Magical Panda Software, LLC. All rights reserved.
//

#import "NSManagedObject+ActiveRecord.h"
#import "NSManagedObjectContext+ActiveRecord.h"
#import "NSPersistentStoreCoordinator+ActiveRecord.h"

static NSManagedObjectContext *defaultManageObjectContext = nil;

@implementation NSManagedObjectContext (ActiveRecord)

+ (NSManagedObjectContext *)defaultContext
{
	@synchronized (self)
	{
		if (defaultManageObjectContext)
		{
			return defaultManageObjectContext;
		}
	}
	return nil;
}

+ (void) setDefaultContext:(NSManagedObjectContext *)moc
{
	[defaultManageObjectContext release];
	defaultManageObjectContext = [moc retain];
}

- (void) observeContext:(NSManagedObjectContext *)otherContext
{
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(mergeChangesFromNotification:) 
												 name:NSManagedObjectContextDidSaveNotification
											   object:otherContext];
}

- (void) observeContextOnMainThread:(NSManagedObjectContext *)otherContext
{
    //	NSLog(@"Start Observing on Main Thread");
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(mergeChangesOnMainThread:) 
												 name:NSManagedObjectContextDidSaveNotification
											   object:otherContext];	
}

- (void) stopObservingContext:(NSManagedObjectContext *)otherContext
{
    //	NSLog(@"Stop Observing Context");
	[[NSNotificationCenter defaultCenter] removeObserver:self 
													name:NSManagedObjectContextDidSaveNotification 
												  object:otherContext];
}

- (void) mergeChangesOnMainThread:(NSNotification *)notification
{
	[self performSelectorOnMainThread:@selector(mergeChangesFromNotification:) withObject:notification waitUntilDone:YES];
}

- (void) mergeChangesFromNotification:(NSNotification *)notification
{
	NSLog(@"Merging changes to context%@", [NSThread isMainThread] ? @" *** on Main Thread ***" : @"");
    //	NSAssert([NSThread isMainThread], @"Not on main thread");
	
//	for (id object in [self updatedObjects]) 
//	{
//		if ([[object changedValues] count] > 0)
//		{
//			[self refreshObject:object mergeChanges:NO];
//		}
//	}
	[self mergeChangesFromContextDidSaveNotification:notification];
}

- (BOOL) save
{
	NSError *error = nil;
	BOOL saved = NO;
	@try
	{
		NSLog(@"Saving Context%@", [NSThread isMainThread] ? @" *** on Main Thread ***" : @"");
		saved = [self save:&error];
	}
	@catch (NSException *exception)
	{
		NSLog(@"Problem saving: %@", [exception userInfo]);
	}
	
	[ActiveRecordHelpers handleErrors:error];

	return saved && error == nil; 
}

- (void) saveWrapper
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self save];
	[pool drain];
}

- (BOOL) saveOnBackgroundThread
{

	[self performSelectorInBackground:@selector(saveWrapper) withObject:nil];

	return YES;
}
	   
- (BOOL) saveOnMainThread
{
	@synchronized(self)
	{
		[self performSelectorOnMainThread:@selector(saveWrapper) withObject:nil waitUntilDone:YES];
	}

	return YES;
}

+ (NSManagedObjectContext *) contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
	NSManagedObjectContext *context = nil;
    if (coordinator != nil) 
	{
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:coordinator];
    }
    return [context autorelease];	
}

+ (NSManagedObjectContext *) context 
{
	return [self contextWithStoreCoordinator:[NSPersistentStoreCoordinator defaultStoreCoordinator]];
}

@end
