//
//  NSManagedObjectContext+MagicalRecord.m
//
//  Created by Saul Mora on 11/23/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "CoreData+MagicalRecord.h"
#import "MagicalRecordStack.h"
#import <objc/runtime.h>

#if MR_LOG_LEVEL >= 0
static NSInteger ddLogLevel = MR_LOG_LEVEL;
#endif


static id iCloudSetupNotificationObserver = nil;

static NSString * const kMagicalRecordNSManagedObjectContextWorkingName = @"kNSManagedObjectContextWorkingName";

@interface NSManagedObjectContext (MagicalRecordInternal)


@end


@implementation NSManagedObjectContext (MagicalRecord)

+ (void) MR_cleanUp;
{
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


//+ (void) MR_setDefaultContext:(NSManagedObjectContext *)moc
//{
//    if (defaultManagedObjectContext_)
//    {
//        [[NSNotificationCenter defaultCenter] removeObserver:defaultManagedObjectContext_];
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_defaultStoreCoordinator];
//    if (iCloudSetupNotificationObserver)
//    {
//        [[NSNotificationCenter defaultCenter] removeObserver:iCloudSetupNotificationObserver];
//        iCloudSetupNotificationObserver = nil;
//    }
//    
//    if ([MagicalRecord isICloudEnabled]) 
//    {
//        [defaultManagedObjectContext_ MR_stopObservingiCloudChangesInCoordinator:coordinator];
//    }
//
//    defaultManagedObjectContext_ = moc;
//    [defaultManagedObjectContext_ MR_setWorkingName:@"DEFAULT"];
//    
//    if ((defaultManagedObjectContext_ != nil) && ([self MR_rootSavingContext] != nil)) {
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(rootContextChanged:)
//                                                     name:NSManagedObjectContextDidSaveNotification
//                                                   object:[self MR_rootSavingContext]];
//    }
//    
////    [moc MR_obtainPermanentIDsBeforeSaving];
//    if ([MagicalRecord isICloudEnabled])
//    {
//        [defaultManagedObjectContext_ MR_observeiCloudChangesInCoordinator:coordinator];
//    }
//    else
//    {
//        // If icloud is NOT enabled at the time of this method being called, listen for it to be setup later, and THEN set up observing cloud changes
//        iCloudSetupNotificationObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kMagicalRecordPSCDidCompleteiCloudSetupNotification
//                                                                           object:nil
//                                                                            queue:[NSOperationQueue mainQueue]
//                                                                       usingBlock:^(NSNotification *note) {
//                                                                           [[NSManagedObjectContext MR_defaultContext] MR_observeiCloudChangesInCoordinator:coordinator];
//                                                                       }];        
//    }
//    MRLog(@"Set Default Context: %@", defaultManagedObjectContext_);
//}


//+ (void) MR_setRootSavingContext:(NSManagedObjectContext *)context;
//{
//    if (backgroundSavingContext)
//    {
//        [[NSNotificationCenter defaultCenter] removeObserver:backgroundSavingContext];
//    }
//    
//    backgroundSavingContext = context;
//
//    [backgroundSavingContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
//    [backgroundSavingContext MR_setWorkingName:@"BACKGROUND SAVING (ROOT)"];
//    MRLog(@"Set Root Saving Context: %@", backgroundSavingContext);
//}

+ (NSManagedObjectContext *) MR_context;
{
    return [self MR_privateQueueContext];
}

+ (NSManagedObjectContext *)MR_confinementContext;
{
    return [self MR_confinementContextWithParent:[[MagicalRecordStack defaultStack] context]];
}

+ (NSManagedObjectContext *) MR_confinementContextWithParent:(NSManagedObjectContext *)parentContext;
{
    NSManagedObjectContext *context = [[self alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
    [context setParentContext:parentContext];
    [context MR_setWorkingName:@"Confinement"];
    return context;
}

+ (NSManagedObjectContext *) MR_mainQueueContext;
{
    NSManagedObjectContext *context = [[self alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [context setParentContext:[[MagicalRecordStack defaultStack] context]];
    [context MR_setWorkingName:@"Main Queue"];
    return context;
}

+ (NSManagedObjectContext *) MR_privateQueueContext;
{
    NSManagedObjectContext *context = [[self alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setParentContext:[[MagicalRecordStack defaultStack] context]];
    [context MR_setWorkingName:@"Private Queue"];
    return context;
}

+ (NSManagedObjectContext *) MR_contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
	NSManagedObjectContext *context = nil;
    if (coordinator != nil)
	{
        context = [[self alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        context.MR_workingName = @"Private Queue";
        
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
            [[error MR_coreDataDescription] MR_logToConsole];
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
    if (nil == workingName)
    {
        workingName = @"UNNAMED";
    }
    return workingName;
}


@end
