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

@interface NSManagedObjectContext ()

- (void) mergeChangesFromNotification:(NSNotification *)notification;
- (void) mergeChangesOnMainThread:(NSNotification *)notification;

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
    [moc retain];
    [defaultManageObjectContext_ release];
    defaultManageObjectContext_ = moc;
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

+ (NSManagedObjectContext *)MR_contextForCurrentThread
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

- (void) MR_observeContext:(NSManagedObjectContext *)otherContext
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(mergeChangesFromNotification:)
												 name:NSManagedObjectContextDidSaveNotification
											   object:otherContext];
}

- (void) MR_observeContextOnMainThread:(NSManagedObjectContext *)otherContext
{
    //	ARLog(@"Start Observing on Main Thread");
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(mergeChangesOnMainThread:)
												 name:NSManagedObjectContextDidSaveNotification
											   object:otherContext];
}

- (void) MR_stopObservingContext:(NSManagedObjectContext *)otherContext
{
    //	ARLog(@"Stop Observing Context");
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:NSManagedObjectContextDidSaveNotification
												  object:otherContext];
}

- (void) mergeChangesFromNotification:(NSNotification *)notification
{
	ARLog(@"Merging changes to %@context%@", 
          self == [NSManagedObjectContext MR_defaultContext] ? @"*** DEFAULT *** " : @"",
          ([NSThread isMainThread] ? @" *** on Main Thread ***" : @""));
    
	[self mergeChangesFromContextDidSaveNotification:notification];
}

- (void) mergeChangesOnMainThread:(NSNotification *)notification
{
	if ([NSThread isMainThread])
	{
		[self mergeChangesFromNotification:notification];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(mergeChangesFromNotification:) withObject:notification waitUntilDone:YES];
	}
}

- (BOOL)MR_save
{
	return [self MR_saveWithErrorHandler:nil];
}

#ifdef NS_BLOCKS_AVAILABLE
- (BOOL) MR_saveWithErrorHandler:(void (^)(NSError *))errorCallback
{
	NSError *error = nil;
	BOOL saved = NO;
	
	@try
	{
		ARLog(@"Saving %@Context%@", 
              self == [[self class] MR_defaultContext] ? @" *** Default *** ": @"",
              ([NSThread isMainThread] ? @" *** on Main Thread ***" : @""));
        
		saved = [self save:&error];
	}
	@catch (NSException *exception)
	{
		ARLog(@"Problem saving: %@", (id)[exception userInfo] ?: (id)[exception reason]);	
	}
	@finally 
    {
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

- (void) saveWrapper
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED == __IPHONE_5_0
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

- (BOOL)MR_saveOnBackgroundThread
{
	[self performSelectorInBackground:@selector(saveWrapper) withObject:nil];

	return YES;
}

- (BOOL)MR_saveOnMainThread
{
	@synchronized(self)
	{
		[self performSelectorOnMainThread:@selector(saveWrapper) withObject:nil waitUntilDone:YES];
	}

	return YES;
}

- (BOOL)MR_notifiesMainContextOnSave
{
    NSNumber *notifies = objc_getAssociatedObject(self, @"notifiesMainContext");
    return notifies ? [notifies boolValue] : NO;
}

- (void) setMR_notifiesMainContextOnSave:(BOOL)enabled
{
    NSManagedObjectContext *mainContext = [[self class] MR_defaultContext];
    if (self != mainContext) 
    {
        SEL selector = enabled ? @selector(MR_observeContextOnMainThread:) : @selector(MR_stopObservingContext:);
        objc_setAssociatedObject(self, @"notifiesMainContext", [NSNumber numberWithBool:enabled], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [mainContext performSelector:selector withObject:self];
    }
}

+ (NSManagedObjectContext *) MR_contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
	NSManagedObjectContext *context = nil;
    if (coordinator != nil)
	{
        ARLog(@"Creating MOContext %@", [NSThread isMainThread] ? @" *** On Main Thread ***" : @"");
        context = [[[NSManagedObjectContext alloc] init] autorelease];
        [context setPersistentStoreCoordinator:coordinator];
    }
    return context;
}

+ (NSManagedObjectContext *) MR_contextThatNotifiesDefaultContextOnMainThreadWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
    NSManagedObjectContext *context = [self MR_contextWithStoreCoordinator:coordinator];
    context.MR_notifiesMainContextOnSave = YES;
    return context;
}

+ (NSManagedObjectContext *)MR_context
{
	return [self MR_contextWithStoreCoordinator:[NSPersistentStoreCoordinator MR_defaultStoreCoordinator]];
}

+ (NSManagedObjectContext *)MR_contextThatNotifiesDefaultContextOnMainThread
{
    NSManagedObjectContext *context = [self MR_context];
    context.MR_notifiesMainContextOnSave = YES;
    return context;
}

@end
