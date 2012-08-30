//
//  NSManagedObjectContext+MagicalRecord.m
//
//  Created by Saul Mora on 11/23/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "CoreData+MagicalRecord.h"
#import <objc/runtime.h>

static NSManagedObjectContext *rootSavingContext = nil;
static NSManagedObjectContext *defaultManagedObjectContext_ = nil;
static NSManagedObjectContext *backgroundWorkContext = nil;


@interface NSManagedObjectContext (MagicalRecordInternal)

- (void) MR_mergeChangesFromNotification:(NSNotification *)notification;
- (void) MR_mergeChangesOnMainThread:(NSNotification *)notification;
+ (void) MR_setDefaultContext:(NSManagedObjectContext *)moc;
+ (void) MR_setRootSavingContext:(NSManagedObjectContext *)context;

@end


@implementation NSManagedObjectContext (MagicalRecord)

+ (void) MR_cleanUp;
{
    [self MR_setDefaultContext:nil];
    [self MR_setRootSavingContext:nil];
}

- (NSString *) MR_description;
{
    NSString *contextName = (self == defaultManagedObjectContext_) ? @"*** DEFAULT ***" : @"";
    contextName = (self == rootSavingContext) ? @"*** BACKGROUND SAVE ***" : contextName;
    
    NSString *onMainThread = [NSThread isMainThread] ? @"*** MAIN THREAD ***" : @"";
    
    return [NSString stringWithFormat:@"%@: %@ Context %@", [self description], contextName, onMainThread];
}

+ (NSManagedObjectContext *) MR_defaultContext
{
	@synchronized (self)
	{
        NSAssert(defaultManagedObjectContext_ != nil, @"Default Context is nil! Did you forget to initialize the Core Data Stack?");
        return defaultManagedObjectContext_;
	}
}

+ (void) MR_setDefaultContext:(NSManagedObjectContext *)moc
{
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_defaultStoreCoordinator];
    if ([MagicalRecord isICloudEnabled]) 
    {
        [defaultManagedObjectContext_ MR_stopObservingiCloudChangesInCoordinator:coordinator];
    }

    defaultManagedObjectContext_ = moc;
    
    if ([MagicalRecord isICloudEnabled]) 
    {
        [defaultManagedObjectContext_ MR_observeiCloudChangesInCoordinator:coordinator];
    }
}

+ (NSManagedObjectContext *) MR_rootSavingContext;
{
    return rootSavingContext;
}

+ (void) MR_setRootSavingContext:(NSManagedObjectContext *)context;
{
    rootSavingContext = context;
    [rootSavingContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
}

+ (void) MR_initializeDefaultContextWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
    if (defaultManagedObjectContext_ == nil)
    {
        if ([MagicalRecord isRunningiOS6]) {
            MRLog(@"Wohoo! Running iOS 6, using nested contexts!");
            NSManagedObjectContext *rootContext = [self MR_contextWithStoreCoordinator:coordinator];
            
            [self MR_setRootSavingContext:rootContext];
            
            NSManagedObjectContext *defaultContext = [self MR_newMainQueueContext];
            [defaultContext setParentContext:rootSavingContext];
            
            [self MR_setDefaultContext:defaultContext];
        } else {
            MRLog(@"On iOS 5, nested contexts are trouble. Using parallel PSC's!");
            // We can't do nested contexts, so let's create a seperate psc and merge from there to main thread context
            
            NSPersistentStoreCoordinator *backgroundCoordinator = [NSPersistentStoreCoordinator MR_coordinatorWithAutoMigratingSqliteStoreNamed:[MagicalRecord defaultStoreName]];
            NSManagedObjectContext *rootContext = [self MR_contextWithStoreCoordinator:backgroundCoordinator];
            [self MR_setRootSavingContext:rootContext];
            rootContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
            // Now set up the UIQueue
            NSManagedObjectContext *defaultContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            defaultContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
            // Use the coordinator passed in
            [defaultContext setPersistentStoreCoordinator:coordinator];
            [self MR_setDefaultContext:defaultContext];
            
            [self MR_makeContext:rootContext mergeChangesToContext:defaultContext];
            [self MR_makeContext:defaultContext mergeChangesToContext:rootContext];
        }
    }
}

+ (void)MR_makeContext:(NSManagedObjectContext *)sourceContext mergeChangesToContext:(NSManagedObjectContext *)targetContext
{
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:sourceContext
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      [targetContext performBlock:^{
                                                          [targetContext mergeChangesFromContextDidSaveNotification:note];
                                                      }];
                                                  }];
}

+ (void)MR_makeContextObtainPermanentIDsBeforeSaving:(NSManagedObjectContext *)context
{
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextWillSaveNotification
                                                      object:context
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                     [context performBlockAndWait:^{
                                                         NSArray *insertedObjects = [[context insertedObjects] allObjects];
                                                         NSError *error;
                                                         if (![context obtainPermanentIDsForObjects:insertedObjects error:&error]) {
                                                             [MagicalRecord handleErrors:error];
                                                         }
                                                     }];
                                                  }];
}
+ (void) MR_resetDefaultContext
{
    void (^resetBlock)(void) = ^{
        [[NSManagedObjectContext MR_defaultContext] reset];
    };
    
    dispatch_async(dispatch_get_main_queue(), resetBlock);
}

+ (NSManagedObjectContext *) MR_contextWithoutParent;
{
    NSManagedObjectContext *context = [[self alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    return context;
}

+ (NSManagedObjectContext *) MR_context;
{
    NSManagedObjectContext *context = [[self alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setParentContext:[self MR_defaultContext]];
    return context;
}

+ (NSManagedObjectContext *) MR_contextWithParent:(NSManagedObjectContext *)parentContext;
{
    NSManagedObjectContext *context = [self MR_contextWithoutParent];
    [context setParentContext:parentContext];
    return context;
}

+ (NSManagedObjectContext *) MR_newMainQueueContext;
{
    NSManagedObjectContext *context = [[self alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    return context;    
}

+ (NSManagedObjectContext *) MR_contextThatPushesChangesToDefaultContext;
{
    NSManagedObjectContext *defaultContext = [self MR_defaultContext];
    NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [childContext setParentContext:defaultContext];
    return childContext;
}

+ (NSManagedObjectContext *) MR_contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
	NSManagedObjectContext *context = nil;
    if (coordinator != nil)
	{
        context = [self MR_contextWithoutParent];
        [context performBlockAndWait:^{
            [context setPersistentStoreCoordinator:coordinator];
        }];
        
        MRLog(@"-> Created %@", [context MR_description]);
    }
    return context;
}


@end
