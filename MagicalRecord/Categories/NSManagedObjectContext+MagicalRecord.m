//
//  NSManagedObjectContext+MagicalRecord.m
//
//  Created by Saul Mora on 11/23/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "CoreData+MagicalRecord.h"
#import <objc/runtime.h>

static NSManagedObjectContext *defaultManageObjectContext_ = nil;


@interface NSManagedObjectContext (MagicalRecordInternal)

- (void) MR_mergeChangesFromNotification:(NSNotification *)notification;
- (void) MR_mergeChangesOnMainThread:(NSNotification *)notification;

@end


@implementation NSManagedObjectContext (MagicalRecord)

+ (NSManagedObjectContext *) MR_defaultContext
{
	@synchronized (self)
	{
        return defaultManageObjectContext_;
	}
}

+ (void) MR_setDefaultContext:(NSManagedObjectContext *)moc
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

+ (void) MR_initializeDefaultContextWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
    if ([self MR_defaultContext] == nil)
    {
        NSManagedObjectContext *context = [self MR_context];
        
        [context performBlockAndWait:^{
            [context setPersistentStoreCoordinator:coordinator];
        }];
        
        [self MR_setDefaultContext:context];
    }
}

+ (void) MR_resetDefaultContext
{
    void (^resetBlock)(void) = ^{
        [[NSManagedObjectContext MR_defaultContext] reset];
    };
    
    dispatch_async(dispatch_get_main_queue(), resetBlock);
}

+ (NSManagedObjectContext *) MR_context;
{
    NSManagedObjectContext *context = [[self alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    return context;
}

+ (NSManagedObjectContext *) MR_newMainQueueContext;
{
    NSManagedObjectContext *context = [[self alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    return context;    
}

+ (NSManagedObjectContext *) MR_contextThatPushesChangesToDefaultContext;
{
    NSManagedObjectContext *context = [self MR_defaultContext];
    NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [childContext setParentContext:context];
    return childContext;
}

+ (NSManagedObjectContext *) MR_contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
	NSManagedObjectContext *context = nil;
    if (coordinator != nil)
	{
        MRLog(@"Creating MOContext %@", [NSThread isMainThread] ? @" *** On Main Thread ***" : @"");
        
        context = [self MR_context];
        [context performBlockAndWait:^{
            [context setPersistentStoreCoordinator:coordinator];
        }];
    }
    return context;
}


@end
