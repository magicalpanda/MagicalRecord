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

@interface NSManagedObjectContext (MagicalRecordPrivate)

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

+ (void) MR_setDefaultContext:(NSManagedObjectContext *)moc
{
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_defaultStoreCoordinator];
    if ([MagicalRecordHelpers isICloudEnabled]) 
    {
        [defaultManageObjectContext_ MR_stopObservingiCloudChangesInCoordinator:coordinator];
    }
    
    MR_RETAIN(moc);
    MR_RELEASE(defaultManageObjectContext_);

    defaultManageObjectContext_ = moc;
    
    if ([MagicalRecordHelpers isICloudEnabled]) 
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

- (void) MR_observeContext:(NSManagedObjectContext *)otherContext
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(MR_mergeChangesFromNotification:)
												 name:NSManagedObjectContextDidSaveNotification
											   object:otherContext];
}

- (void) MR_observeContextOnMainThread:(NSManagedObjectContext *)otherContext
{
    //	MRLog(@"Start Observing on Main Thread");
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(MR_mergeChangesOnMainThread:)
												 name:NSManagedObjectContextDidSaveNotification
											   object:otherContext];
}

- (void) MR_stopObservingContext:(NSManagedObjectContext *)otherContext
{
    //	MRLog(@"Stop Observing Context");
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:NSManagedObjectContextDidSaveNotification
												  object:otherContext];
}

#pragma mark - Merge Helpers

- (void) MR_observeiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
    if (![MagicalRecordHelpers isICloudEnabled]) return;
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(MR_mergeChangesFromiCloud:)
                                                 name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                               object:coordinator];
    
}

- (void) MR_stopObservingiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
    if (![MagicalRecordHelpers isICloudEnabled]) return;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSPersistentStoreDidImportUbiquitousContentChangesNotification 
                                                  object:coordinator];
}

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

#pragma mark - Save Helpers

- (BOOL) MR_save;
{
	return [self MR_saveWithErrorHandler:nil];
}

#ifdef NS_BLOCKS_AVAILABLE
- (BOOL) MR_saveWithErrorHandler:(void (^)(NSError *))errorCallback;
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
        if (saved && [self respondsToSelector:@selector(parentContext)] && [self performSelector:@selector(parentContext)])
        {
            [[self parentContext] MR_saveWithErrorHandler:errorCallback];
        }
        if (!saved)
        {
            if (errorCallback)
            {
                errorCallback(error);
            }
            else if (error)
            {
                [MagicalRecordHelpers handleErrors:error];
            }
        }
    }
	return saved && error == nil;
}
#endif

- (void) MR_saveWrapper;
{
#if MR_USE_ARC
    @autoreleasepool
    {
        [self MR_save];
    }
#else
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self MR_save];
    [pool drain];
#endif
}

#pragma mark - Threading Helpers

- (BOOL) MR_saveOnBackgroundThread;
{
	[self performSelectorInBackground:@selector(MR_saveWrapper) withObject:nil];

	return YES;
}

- (BOOL) MR_saveOnMainThread;
{
	@synchronized(self)
	{
		[self performSelectorOnMainThread:@selector(MR_saveWrapper) withObject:nil waitUntilDone:YES];
	}

	return YES;
}

- (BOOL) MR_notifiesMainContextOnSave;
{
    THREAD_ISOLATION_ENABLED(
    NSNumber *notifies = objc_getAssociatedObject(self, kMagicalRecordNotifiesMainContextAssociatedValueKey);
    return notifies ? [notifies boolValue] : NO;
                             )
    PRIVATE_QUEUES_ENABLED(
                           return [self parentContext] == [[self class] MR_defaultContext];
                           )
    return NO;
}

- (void) MR_setNotifiesMainContextOnSave:(BOOL)enabled;
{
    NSManagedObjectContext *mainContext = [[self class] MR_defaultContext];
    if (self != mainContext) 
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        THREAD_ISOLATION_ENABLED(
        SEL selector = enabled ? @selector(MR_observeContextOnMainThread:) : @selector(MR_stopObservingContext:);
        objc_setAssociatedObject(self, kMagicalRecordNotifiesMainContextAssociatedValueKey, [NSNumber numberWithBool:enabled], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        [mainContext performSelector:selector withObject:self];
                                 )
#pragma clang diagnostic pop

        PRIVATE_QUEUES_ENABLED(
                               if (enabled)
                               {
                                   [self setParentContext:mainContext];
                               }
                               )
    }
}

#pragma mark - Creation Helpers

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
        THREAD_ISOLATION_ENABLED(
                         MRLog(@"Creating context in Thread Isolation Mode");
                         context = [[NSManagedObjectContext alloc] init];
                         [context setPersistentStoreCoordinator:coordinator];
                                 )
        PRIVATE_QUEUES_ENABLED(
            MRLog(@"Creating context in Context Private Queue Mode");
            context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [context performBlockAndWait:^{
                [context setPersistentStoreCoordinator:coordinator];
            }];
        )

        MR_AUTORELEASE(context);
    }
    return context;
}

+ (NSManagedObjectContext *) MR_contextThatNotifiesDefaultContextOnMainThreadWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
    NSManagedObjectContext *context = [self MR_contextWithStoreCoordinator:coordinator];
    context.MR_notifiesMainContextOnSave = YES;
    return context;
}

+ (NSManagedObjectContext *) MR_context;
{
	return [self MR_contextWithStoreCoordinator:[NSPersistentStoreCoordinator MR_defaultStoreCoordinator]];
}

+ (NSManagedObjectContext *) MR_contextThatNotifiesDefaultContextOnMainThread;
{
    NSManagedObjectContext *context = nil;
    
    THREAD_ISOLATION_ENABLED
    (
         MRLog(@"Creating Context - Using Thread Isolation Mode");
         context = [self MR_context];
         context.MR_notifiesMainContextOnSave = YES;
    )
    
    PRIVATE_QUEUES_ENABLED
    (
        MRLog(@"Creating Context - Using Private queue mode");
        context = [[self alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        if (context != [self MR_defaultContext])
        {
            [context setParentContext:[NSManagedObjectContext MR_defaultContext]];
        }
    )
    
    return context;
}

@end
