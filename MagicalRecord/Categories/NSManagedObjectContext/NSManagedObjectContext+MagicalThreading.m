//
//  NSManagedObjectContext+MagicalThreading.m
//  Magical Record
//
//  Created by Saul Mora on 3/9/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObjectContext+MagicalThreading.h"

static NSString const * kMagicalRecordManagedObjectContextKey = @"MagicalRecord_NSManagedObjectContextForThreadKey";

@implementation NSManagedObjectContext (MagicalThreading)

+ (void)MR_resetContextForCurrentThread
{
    [[NSManagedObjectContext MR_contextForCurrentThread] reset];
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

+ (NSManagedObjectContext *) MR_contextThatNotifiesDefaultContextOnMainThreadWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
    NSManagedObjectContext *context = [self MR_contextWithStoreCoordinator:coordinator];
    MRLog(@"Creating new context");
    return context;
}

+ (NSManagedObjectContext *) MR_contextThatNotifiesDefaultContextOnMainThread;
{    
    __block NSManagedObjectContext *(^findLastContext)(NSManagedObjectContext *) = nil;
    findLastContext = ^NSManagedObjectContext *(NSManagedObjectContext *context)
    {
        if ([context parentContext] == nil)
        {
            return context;
        }
        return findLastContext([context parentContext]);
    };
    
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
    NSManagedObjectContext *lastContext = findLastContext(defaultContext);
    NSManagedObjectContext *context = nil;
    
    context = [[self alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [context setParentContext:lastContext];
    
    MRLog(@"Created context %@: set %@ context as parent [defaultContext: %@]", context, lastContext, defaultContext);
    
    return context;
}

@end
