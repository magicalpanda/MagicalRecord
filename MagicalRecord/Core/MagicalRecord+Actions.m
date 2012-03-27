//
//  ARCoreDataAction.m
//  Freshpod
//
//  Created by Saul Mora on 2/24/11.
//  Copyright 2011 Magical Panda Software. All rights reserved.
//

#import "CoreData+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalRecord.h"

@implementation MagicalRecord (Actions)

+ (void) saveInBackgroundWithBlock:(void (^)(NSManagedObjectContext *))block completion:(void (^)(void))completion errorHandler:(void (^)(NSError *))errorHandler;
{
    NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_defaultContext];
    NSManagedObjectContext *localContext = mainContext;
    
    if (![NSThread isMainThread]) 
    {
        localContext = [NSManagedObjectContext MR_contextThatPushesChangesToDefaultContext];
        [mainContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
        [localContext setMergePolicy:NSOverwriteMergePolicy];
    }
    
    block(localContext);
    
    if ([localContext hasChanges]) 
    {
        [localContext MR_saveInBackgroundErrorHandler:errorHandler completion:^{
            [mainContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
            
            if (completion)
            {
                completion();
            }            
        }];
    }
}
                                    
+ (void) saveWithBlock:(void (^)(NSManagedObjectContext *localContext))block completion:(void (^)(void))completion errorHandler:(void (^)(NSError *))errorHandler;
{
    NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_defaultContext];
    NSManagedObjectContext *localContext = mainContext;

    if (![NSThread isMainThread]) 
    {
        localContext = [NSManagedObjectContext MR_contextThatPushesChangesToDefaultContext];
        [mainContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
        [localContext setMergePolicy:NSOverwriteMergePolicy];
    }
    
    block(localContext);
    
    if ([localContext hasChanges]) 
    {
        [localContext MR_saveErrorHandler:errorHandler];
    }

    [mainContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    
    if (completion)
    {
        completion();
    }
}

+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block
{   
    [self saveWithBlock:block completion:nil errorHandler:nil];
}

+ (void) saveInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block
{
    [self saveInBackgroundWithBlock:block completion:nil errorHandler:nil];
}

+ (void) saveInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(void(^)(void))callback
{
    [self saveInBackgroundWithBlock:block completion:callback errorHandler:nil];
}

//
//+ (void) saveInBackgroundWithBlock:(void (^)(NSManagedObjectContext *localContext))block completion:(void (^)(void))callback errorHandler:(void (^)(NSError *))errorHandler
//{
//    dispatch_async(background_save_queue(), ^{
//        [self saveWithBlock:block errorHandler:errorHandler];
//        
//        if (callback)
//        {
//            dispatch_async(dispatch_get_main_queue(), callback);
//        }
//    });
//}

@end
