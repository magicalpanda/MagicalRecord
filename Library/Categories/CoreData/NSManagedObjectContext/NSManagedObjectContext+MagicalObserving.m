//
//  NSManagedObjectContext+MagicalObserving.m
//  Magical Record
//
//  Created by Saul Mora on 3/9/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObjectContext+MagicalObserving.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalSaves.h"
#import "MagicalRecordLogging.h"

NSString * const MagicalRecordDidMergeChangesFromiCloudNotification = @"kMagicalRecordDidMergeChangesFromiCloudNotification";

@implementation NSManagedObjectContext (MagicalObserving)

- (void) MR_performBlock:(void(^)(void))block;
{
    if ([self concurrencyType] == NSConfinementConcurrencyType)
    {
        block();
    }
    else
    {
        [self performBlock:block];
    }
}

- (void) MR_performBlockAndWait:(void(^)(void))block;
{
    if ([self concurrencyType] == NSConfinementConcurrencyType)
    {
        block();
    }
    else
    {
        [self performBlockAndWait:block];
    }
}

#pragma mark - Context Observation Helpers

- (void) MR_observeContextDidSave:(NSManagedObjectContext *)otherContext
{
    if (self == otherContext) return;

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self
                           selector:@selector(MR_mergeChangesFromNotification:)
                               name:NSManagedObjectContextDidSaveNotification
                             object:otherContext];
}

- (void) MR_observeContextOnMainThread:(NSManagedObjectContext *)otherContext
{
    if (self == otherContext) return;

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self
                           selector:@selector(MR_mergeChangesOnMainThread:)
                               name:NSManagedObjectContextDidSaveNotification
                             object:otherContext];
}

- (void) MR_stopObservingContextDidSave:(NSManagedObjectContext *)otherContext
{
    if (self == otherContext) return;

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self
                                  name:NSManagedObjectContextDidSaveNotification
                                object:otherContext];
}


- (void) MR_observeContextDidSaveAndSaveChangesToSelf:(NSManagedObjectContext *)otherContext
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

    [notificationCenter addObserver:self
                           selector:@selector(MR_mergeChangesFromNotificationAndSaveChangesToSelfOnly:)
                               name:NSManagedObjectContextDidSaveNotification
                             object:otherContext];
}

- (void) MR_mergeChangesFromNotificationAndSaveChangesToSelfOnly:(NSNotification *)notification
{
    MRLogVerbose(@"Merging changes to %@context%@", [self isEqual:[[MagicalRecordStack defaultStack] context]] ? @"*** DEFAULT *** " : @"", ([NSThread isMainThread] ? @" *** on Main Thread ***" : @"Background Thread"));

    [self mergeChangesFromContextDidSaveNotification:notification];
    [self MR_saveOnlySelfAndWait];
}

#pragma mark - Context iCloud Merge Helpers

- (void) MR_mergeChangesFromiCloud:(NSNotification *)notification;
{
    void (^mergeBlock)(void) = ^{
        
        MRLogInfo(@"Merging changes From iCloud to %@ %@",
              [self MR_workingName],
              ([NSThread isMainThread] ? @" *** on Main Thread ***" : @""));
        
        [self mergeChangesFromContextDidSaveNotification:notification];
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

        [notificationCenter postNotificationName:MagicalRecordDidMergeChangesFromiCloudNotification
                                          object:self
                                        userInfo:[notification userInfo]];
    };
    [self MR_performBlock:mergeBlock];
}

- (void) MR_mergeChangesFromNotification:(NSNotification *)notification;
{
    NSManagedObjectContext *fromContext = [notification object];

    if (fromContext == self) return;

    void (^mergeBlock)(void) = ^{
        MRLogVerbose(@"Merging changes from %@ to %@ %@",
              [fromContext MR_workingName], [self MR_workingName],
              ([NSThread isMainThread] ? @" *** on Main Thread ***" : @""));
        [self mergeChangesFromContextDidSaveNotification:notification];
    };

    [self MR_performBlock:mergeBlock];
}

- (void) MR_mergeChangesOnMainThread:(NSNotification *)notification;
{
	if ([NSThread isMainThread])
	{
		[self MR_mergeChangesFromNotification:notification];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(MR_mergeChangesFromNotification:)
                               withObject:notification
                            waitUntilDone:YES];
	}
}

- (void) MR_observeiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(MR_mergeChangesFromiCloud:)
                               name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                             object:coordinator];
    
}

- (void) MR_stopObservingiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self
                                  name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                object:coordinator];
}

@end

#pragma mark - Deprecated Methods — DO NOT USE
@implementation NSManagedObjectContext (MagicalObservingDeprecated)

- (void)MR_observeContext:(NSManagedObjectContext *)otherContext
{
    [self MR_observeContextDidSave:otherContext];
}

- (void)MR_stopObservingContext:(NSManagedObjectContext *)otherContext
{
    [self MR_stopObservingContextDidSave:otherContext];
}

@end
