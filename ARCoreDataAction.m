//
//  ARCoreDataAction.m
//  Freshpod
//
//  Created by Saul Mora on 2/24/11.
//  Copyright 2011 Magical Panda Software. All rights reserved.
//

#import "ARCoreDataAction.h"

static dispatch_queue_t coredata_background_save_queue;

dispatch_queue_t background_save_queue()
{
    if (coredata_background_save_queue == NULL)
    {
        coredata_background_save_queue = dispatch_queue_create("com.doubleencore.coredata.backgroundsaves", 0);
    }
    return coredata_background_save_queue;
}

@implementation ARCoreDataAction

#ifdef NS_BLOCKS_AVAILABLE

+ (void) saveDataWithBlock:(CoreDataBlock)block
{   
    NSManagedObjectContext *mainContext  = [NSManagedObjectContext defaultContext];
    NSManagedObjectContext *localContext = mainContext;
    
    if (![NSThread isMainThread]) 
    {
        
#if kCreateNewCoordinatorOnBackgroundOperations == 1
        NSPersistentStoreCoordinator *localCoordinator = [NSPersistentStoreCoordinator coordinatorWithPersitentStore:[NSPersistentStore defaultPersistentStore]];
        localContext = [NSManagedObjectContext contextThatNotifiesDefaultContextOnMainThreadWithCoordinator:localCoordinator];
#else
        localContext = [NSManagedObjectContext contextThatNotifiesDefaultContextOnMainThread];
#endif
        
        [mainContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
        [localContext setMergePolicy:NSOverwriteMergePolicy];
    }
    
    block(localContext);
    
    if ([localContext hasChanges]) 
    {
        [localContext save];
    }
    
    localContext.notifiesMainContextOnSave = NO;
    [mainContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
}

+ (void) saveDataInBackgroundWithBlock:(CoreDataBlock)block
{
    dispatch_async(background_save_queue(), ^{
        [self saveDataWithBlock:block];
    });
}

+ (void) saveDataInBackgroundWithBlock:(CoreDataBlock)block completion:(void(^)(void))callback
{
    dispatch_async(background_save_queue(), ^{
        [self saveDataWithBlock:block];
        
        if (callback) 
        {
            dispatch_async(dispatch_get_main_queue(), callback);
        }
    });
}

+ (void) lookupWithBlock:(CoreDataBlock)block
{
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    
    block(context);
}

#endif

@end