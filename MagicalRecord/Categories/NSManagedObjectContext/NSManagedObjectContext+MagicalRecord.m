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
static id iCloudSetupNotificationObserver = nil;

#define kNSManagedObjectContextWorkingName @"kNSManagedObjectContextWorkingName"

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
    
    NSString *onMainThread = [NSThread isMainThread] ? @"*** MAIN THREAD ***" : @"*** SECONDARY THREAD ***";
    
    NSString *familyTree = [NSString string];
    NSManagedObjectContext *parentContext = [self parentContext];
    while (nil != parentContext) {
        familyTree = [familyTree stringByAppendingFormat:@" ==> %@;",[parentContext MR_contextWorkingName]];
        parentContext = [parentContext parentContext];
    }

    return [NSString stringWithFormat:@"%@: %@ Context %@ \nFamilyTree: %@", [self MR_contextWorkingName], contextName, onMainThread,familyTree];
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
    if (defaultManagedObjectContext_)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:defaultManagedObjectContext_];
    }
    
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_defaultStoreCoordinator];
    if (iCloudSetupNotificationObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:iCloudSetupNotificationObserver];
        iCloudSetupNotificationObserver = nil;
    }
    
    if ([MagicalRecord isICloudEnabled]) 
    {
        [defaultManagedObjectContext_ MR_stopObservingiCloudChangesInCoordinator:coordinator];
    }

    defaultManagedObjectContext_ = moc;
    [moc MR_obtainPermanentIDsBeforeSaving];
    if ([MagicalRecord isICloudEnabled]) 
    {
        [defaultManagedObjectContext_ MR_observeiCloudChangesInCoordinator:coordinator];
    }
    else
    {
        // If icloud is NOT enabled at the time of this method being called, listen for it to be setup later, and THEN set up observing cloud changes
        iCloudSetupNotificationObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kMagicalRecordPSCDidCompleteiCloudSetupNotification
                                                                           object:nil
                                                                            queue:[NSOperationQueue mainQueue]
                                                                       usingBlock:^(NSNotification *note) {
                                                                           [[NSManagedObjectContext MR_defaultContext] MR_observeiCloudChangesInCoordinator:coordinator];
                                                                       }];        
    }
}

+ (NSManagedObjectContext *) MR_rootSavingContext;
{
    return rootSavingContext;
}

+ (void) MR_setRootSavingContext:(NSManagedObjectContext *)context;
{
    if (rootSavingContext)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:rootSavingContext];
    }
    
    rootSavingContext = context;
    [context MR_obtainPermanentIDsBeforeSaving];
    [rootSavingContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    [rootSavingContext MR_setContextWorkingName:@"rootSavingsContext"];
}

+ (void) MR_initializeDefaultContextWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
    if (defaultManagedObjectContext_ == nil)
    {
        NSManagedObjectContext *rootContext = [self MR_contextWithStoreCoordinator:coordinator];
        
        [self MR_setRootSavingContext:rootContext];
        
        NSManagedObjectContext *defaultContext = [self MR_newMainQueueContext];
        [defaultContext MR_setContextWorkingName:@"defaultContext"];
        [defaultContext setParentContext:rootSavingContext];

        [self MR_setDefaultContext:defaultContext];
    }
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
    [context MR_obtainPermanentIDsBeforeSaving];
    return context;
}

+ (NSManagedObjectContext *) MR_newMainQueueContext;
{
    NSManagedObjectContext *context = [[self alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    return context;    
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

- (void) MR_obtainPermanentIDsBeforeSaving;
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextWillSave:)
                                                 name:NSManagedObjectContextWillSaveNotification
                                               object:self];
}

- (void)contextWillSave:(NSNotification *)notification
{
    NSManagedObjectContext *context = (NSManagedObjectContext *)notification.object;
    if (context.insertedObjects.count > 0) {
        NSArray *insertedObjects = [[context insertedObjects] allObjects];
        MRLog(@"Context %@ is about to save. Obtaining permanent IDs for new %lu inserted objects", [context MR_description], (unsigned long)[insertedObjects count]);
        NSError *error = nil;
        BOOL success = [context obtainPermanentIDsForObjects:insertedObjects error:&error];
        if (!success && error) {
            [MagicalRecord handleErrors:error];
        }
    }
}

- (void) MR_setContextWorkingName:(NSString *)workingName;
{
    [[self userInfo] setObject:workingName forKey:kNSManagedObjectContextWorkingName];
}

- (NSString *) MR_contextWorkingName;
{
    NSString *workingName = [[self userInfo] objectForKey:kNSManagedObjectContextWorkingName];
    if (nil == workingName) {
        workingName = @"UndefinedWorkingContext";
    }
    return workingName;
}


@end
