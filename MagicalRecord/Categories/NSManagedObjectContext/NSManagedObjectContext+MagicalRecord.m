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

static NSString * const kMagicalRecordNSManagedObjectContextWorkingName = @"kNSManagedObjectContextWorkingName";

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
    [self MR_clearNonMainThreadContextsCache];
}

- (NSString *) MR_description;
{
    NSString *contextLabel = [NSString stringWithFormat:@"*** %@ ***", [self MR_workingName]];
    NSString *onMainThread = [NSThread isMainThread] ? @"*** MAIN THREAD ***" : @"*** BACKGROUND THREAD ***";

    return [NSString stringWithFormat:@"<%@ (%p): %@> on %@", NSStringFromClass([self class]), self, contextLabel, onMainThread];
}

- (NSString *) MR_parentChain;
{
    NSMutableString *familyTree = [@"\n" mutableCopy];
    NSManagedObjectContext *currentContext = self;
    do
    {
        [familyTree appendFormat:@"- %@ (%p) %@\n", [currentContext MR_workingName], currentContext, (currentContext == self ? @"(*)" : @"")];
    }
    while ((currentContext = [currentContext parentContext]));

    return [NSString stringWithString:familyTree];
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
    if (iCloudSetupNotificationObserver)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:iCloudSetupNotificationObserver];
        iCloudSetupNotificationObserver = nil;
    }
    
    if ([MagicalRecord isICloudEnabled]) 
    {
        [defaultManagedObjectContext_ MR_stopObservingiCloudChangesInCoordinator:coordinator];
    }

    defaultManagedObjectContext_ = moc;
    [defaultManagedObjectContext_ MR_setWorkingName:@"DEFAULT"];
    
    if ((defaultManagedObjectContext_ != nil) && ([self MR_rootSavingContext] != nil)) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rootContextChanged:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:[self MR_rootSavingContext]];
    }
    
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
    MRLog(@"Set Default Context: %@", defaultManagedObjectContext_);
}

+ (void)rootContextChanged:(NSNotification *)notification {
    if ([NSThread isMainThread] == NO) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self rootContextChanged:notification];
        });
        
        return;
    }
    
    [[self MR_defaultContext] mergeChangesFromContextDidSaveNotification:notification];
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
    [rootSavingContext MR_setWorkingName:@"BACKGROUND SAVING (ROOT)"];
    MRLog(@"Set Root Saving Context: %@", rootSavingContext);
}

+ (void) MR_initializeDefaultContextWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
    if (defaultManagedObjectContext_ == nil)
    {
        NSManagedObjectContext *rootContext = [self MR_contextWithStoreCoordinator:coordinator];
        [self MR_setRootSavingContext:rootContext];
        
        NSManagedObjectContext *defaultContext = [self MR_newMainQueueContext];
        [self MR_setDefaultContext:defaultContext];
        
        [defaultContext setParentContext:rootContext];
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
    MRLog(@"Created Main Queue Context: %@", context);
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
        
        MRLog(@"-> Created Context %@", [context MR_workingName]);
    }
    return context;
}

- (void) MR_obtainPermanentIDsBeforeSaving;
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MR_contextWillSave:)
                                                 name:NSManagedObjectContextWillSaveNotification
                                               object:self];
    
    
}

- (void) MR_contextWillSave:(NSNotification *)notification
{
    NSManagedObjectContext *context = [notification object];
    NSSet *insertedObjects = [context insertedObjects];

    if ([insertedObjects count])
    {
        MRLog(@"Context %@ is about to save. Obtaining permanent IDs for new %lu inserted objects", [context MR_workingName], (unsigned long)[insertedObjects count]);
        NSError *error = nil;
        BOOL success = [context obtainPermanentIDsForObjects:[insertedObjects allObjects] error:&error];
        if (!success)
        {
            [MagicalRecord handleErrors:error];
        }
    }
}

- (void) MR_setWorkingName:(NSString *)workingName;
{
    [[self userInfo] setObject:workingName forKey:kMagicalRecordNSManagedObjectContextWorkingName];
}

- (NSString *) MR_workingName;
{
    NSString *workingName = [[self userInfo] objectForKey:kMagicalRecordNSManagedObjectContextWorkingName];
    if ([workingName length] == 0)
    {
        workingName = @"UNNAMED";
    }
    return workingName;
}

- (void) MR_deleteObjects:(id <NSFastEnumeration>)managedObjects
{
    for (NSManagedObject *managedObject in managedObjects)
    {
        [self deleteObject:managedObject];
    }
}

@end
