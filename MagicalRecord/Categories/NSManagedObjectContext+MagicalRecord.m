//
//  NSManagedObjectContext+MagicalRecord.m
//
//  Created by Saul Mora on 11/23/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "CoreData+MagicalRecord.h"
#import <objc/runtime.h>

static NSManagedObjectContext *defaultManageObjectContext_ = nil;
static NSString const * kMagicalRecordManagedObjectContextKey = @"MagicalRecord_NSManagedObjectContextForThreadKey";
static void const * kMagicalRecordNotifiesMainContextAssociatedValueKey = @"kMagicalRecordNotifiesMainContextOnSave";
       NSString * const kMagicalRecordDidMergeChangesFromiCloudNotification = @"kMagicalRecordDidMergeChangesFromiCloudNotification";

@interface NSManagedObjectContext (MagicalRecordInternal)

- (void) MR_mergeChangesFromNotification:(NSNotification *)notification;
- (void) MR_mergeChangesOnMainThread:(NSNotification *)notification;

@end


@implementation NSManagedObjectContext (MagicalRecord)

+ (NSManagedObjectContext *)MR_defaultContext
{
	@synchronized (self)
	{
        return defaultManageObjectContext_;
	}
}

+ (void)MR_setDefaultContext:(NSManagedObjectContext *)moc
{
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_defaultStoreCoordinator];
    if ([MagicalRecord isICloudEnabled]) 
    {
        [defaultManageObjectContext_ MR_stopObservingiCloudChangesInCoordinator:coordinator];
    }
    
    defaultManageObjectContext_ = moc;
    
    if ([MagicalRecord isICloudEnabled]) 
    {
        [defaultManageObjectContext_ MR_observeiCloudChangesInCoordinator:coordinator];
    }
}

+ (void)MR_resetDefaultContext
{
    void (^resetBlock)(void) = ^{
        [[NSManagedObjectContext MR_defaultContext] reset];
    };
    
    dispatch_async(dispatch_get_main_queue(), resetBlock);
}

+ (void)MR_resetContextForCurrentThread
{
    [[NSManagedObjectContext MR_contextForCurrentThread] reset];
}

#pragma mark - Context Observation Helpers

- (void) MR_observeContext:(NSManagedObjectContext *)otherContext
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(MR_mergeChangesFromNotification:)
												 name:NSManagedObjectContextDidSaveNotification
											   object:otherContext];
}

- (void) MR_observeContextOnMainThread:(NSManagedObjectContext *)otherContext
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(MR_mergeChangesOnMainThread:)
												 name:NSManagedObjectContextDidSaveNotification
											   object:otherContext];
}

- (void) MR_stopObservingContext:(NSManagedObjectContext *)otherContext
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:NSManagedObjectContextDidSaveNotification
												  object:otherContext];
}

#pragma mark - Context iCloud Merge Helpers

- (void) MR_mergeChangesFromiCloud:(NSNotification *)notification;
{
    [self performBlock:^{
        
        MRLog(@"Merging changes From iCloud %@context%@", 
              self == [NSManagedObjectContext MR_defaultContext] ? @"*** DEFAULT *** " : @"",
              ([NSThread isMainThread] ? @" *** on Main Thread ***" : @""));
        
        [self mergeChangesFromContextDidSaveNotification:notification];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kMagicalRecordDidMergeChangesFromiCloudNotification
                                                            object:self
                                                          userInfo:[notification userInfo]];
    }];
}

- (void) MR_mergeChangesFromNotification:(NSNotification *)notification;
{
	MRLog(@"Merging changes to %@context%@", 
          self == [NSManagedObjectContext MR_defaultContext] ? @"*** DEFAULT *** " : @"",
          ([NSThread isMainThread] ? @" *** on Main Thread ***" : @""));
    
	[self mergeChangesFromContextDidSaveNotification:notification];
}

- (void) MR_mergeChangesOnMainThread:(NSNotification *)notification;
{
	if ([NSThread isMainThread])
	{
		[self MR_mergeChangesFromNotification:notification];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(MR_mergeChangesFromNotification:) withObject:notification waitUntilDone:YES];
	}
}

- (void) MR_observeiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
    if (![MagicalRecord isICloudEnabled]) return;
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(MR_mergeChangesFromiCloud:)
                                                 name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                               object:coordinator];
    
}

- (void) MR_stopObservingiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
    if (![MagicalRecord isICloudEnabled]) return;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSPersistentStoreDidImportUbiquitousContentChangesNotification 
                                                  object:coordinator];
}

#pragma mark - Save Helpers

- (BOOL) MR_saveNestedContexts:(BOOL)saveParents errorHandler:(void(^)(NSError *))errorCallback;
{
	NSError *error = nil;
	BOOL saved = NO;
	
	@try
	{
		MRLog(@"Saving %@Context%@", 
              self == [[self class] MR_defaultContext] ? @" *** Default *** ": @"",
              ([NSThread isMainThread] ? @" *** on Main Thread ***" : @""));
        
		saved = [self save:&error];
	}
	@catch (NSException *exception)
	{
		MRLog(@"Problem saving: %@", (id)[exception userInfo] ?: (id)[exception reason]);	
	}
	@finally 
    {
        if (saved && saveParents)
        {
            [[self parentContext] MR_saveNestedContexts:saveParents errorHandler:errorCallback];
        }
        if (!saved)
        {
            if (errorCallback)
            {
                errorCallback(error);
            }
            if (error)
            {
                [MagicalRecord handleErrors:error];
            }
        }
    }
	return saved;
}

- (BOOL) MR_saveNestedContextsErrorHandler:(void (^)(NSError *))errorCallback;
{
    return [self MR_saveNestedContexts:YES errorHandler:errorCallback];
}

- (BOOL) MR_saveWithErrorHandler:(void (^)(NSError *))errorCallback;
{
    return [self MR_saveNestedContexts:NO errorHandler:errorCallback];
}

- (BOOL) MR_save;
{
    return [self MR_saveNestedContexts:NO errorHandler:nil];
}

#pragma mark - Threading Helpers

- (BOOL) MR_saveOnBackgroundThread;
{
	[self performSelectorInBackground:@selector(MR_save) withObject:nil];

	return YES;
}

- (BOOL) MR_saveOnMainThread;
{
	@synchronized(self)
	{
		[self performSelectorOnMainThread:@selector(MR_save) withObject:nil waitUntilDone:YES];
	}

	return YES;
}

#pragma mark - Creation Helpers

+ (NSManagedObjectContext *) MR_context;
{
    MRLog(@"Creating new context");
	return [self MR_contextWithStoreCoordinator:[NSPersistentStoreCoordinator MR_defaultStoreCoordinator]];
}

+ (NSManagedObjectContext *) MR_contextForCurrentThread;
{
	if ([NSThread isMainThread])
	{
		return [self MR_defaultContext];
	}
	else
	{
		NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
		NSManagedObjectContext *threadContext = [threadDict objectForKey:kMagicalRecordManagedObjectContextKey];
		if (threadContext == nil)
		{
			threadContext = [self MR_contextThatNotifiesDefaultContextOnMainThread];
			[threadDict setObject:threadContext forKey:kMagicalRecordManagedObjectContextKey];
		}
		return threadContext;
	}
}

+ (NSManagedObjectContext *) MR_contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
	NSManagedObjectContext *context = nil;
    if (coordinator != nil)
	{
        MRLog(@"Creating MOContext %@", [NSThread isMainThread] ? @" *** On Main Thread ***" : @"");
            MRLog(@"Creating context in Context Private Queue Mode");
            context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [context performBlockAndWait:^{
                [context setPersistentStoreCoordinator:coordinator];
            }];
    }
    return context;
}

+ (NSManagedObjectContext *) MR_contextThatNotifiesDefaultContextOnMainThreadWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
    NSManagedObjectContext *context = [self MR_contextWithStoreCoordinator:coordinator];
    MRLog(@"Creating new context");
    return context;
}

+ (NSManagedObjectContext *) MR_contextThatNotifiesDefaultContextOnMainThread;
{
    NSManagedObjectContext *context = nil;
    
    MRLog(@"Creating new context");
    context = [[self alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    if (context != [self MR_defaultContext])
    {
        [context setParentContext:[NSManagedObjectContext MR_defaultContext]];
    }
    
    return context;
}

@end
