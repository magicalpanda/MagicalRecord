//
//  MagicalRecord+Actions.m
//
//  Created by Saul Mora on 2/24/11.
//  Copyright 2011 Magical Panda Software. All rights reserved.
//

#import "CoreData+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalRecord.h"

#if MR_LOG_LEVEL >= 0
static NSInteger ddLogLevel = MR_LOG_LEVEL;
#endif

dispatch_queue_t saveQueue(void);
dispatch_queue_t saveQueue()
{
    static dispatch_queue_t serial_save_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serial_save_queue = dispatch_queue_create("com.magicalpanda.magicalrecord.serialsavequeue", DISPATCH_QUEUE_SERIAL);
    });
    return serial_save_queue;
}

@implementation MagicalRecord (Actions)

#pragma mark - Asynchronous saving

+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;
{
    [self saveWithBlock:block identifier:NSStringFromSelector(_cmd) completion:nil];
}

+ (void) saveWithIdentifier:(NSString *)identifier block:(void(^)(NSManagedObjectContext *))block;
{
    [self saveWithBlock:block identifier:identifier completion:nil];
}

+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;
{
    [self saveWithBlock:block identifier:NSStringFromSelector(_cmd) completion:completion];
}

+ (void) saveWithBlock:(void (^)(NSManagedObjectContext *))block identifier:(NSString *)contextWorkingName completion:(MRSaveCompletionHandler)completion;
{
    MRLog(@"Dispatching save request: %@", contextWorkingName);
    dispatch_async(saveQueue(), ^{
        MRLog(@"%@ save starting", contextWorkingName);
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_confinementContext];
        [localContext MR_setWorkingName:contextWorkingName];
        
        if (block)
        {
            block(localContext);
        }

        [localContext MR_saveWithOptions:MRSaveParentContexts|MRSaveSynchronously completion:completion];
        MRLog(@"%@ save completed", contextWorkingName);
    });
}

+ (void) saveUsingCurrentThreadContextWithBlock:(void (^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];

    [localContext performBlock:^{
        if (block) {
            block(localContext);
        }

        [localContext MR_saveWithOptions:MRSaveParentContexts completion:completion];
    }];
}


#pragma mark - Synchronous saving

+ (void) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;
{
//    NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_rootSavingContext];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_confinementContext];
    
    if (block)
    {
        block(localContext);
    }

    [localContext MR_saveWithOptions:MRSaveParentContexts|MRSaveSynchronously completion:nil];
//    [localContext performBlockAndWait:^{
//        if (block) {
//            block(localContext);
//        }
//
//        [localContext MR_saveWithOptions:MRSaveParentContexts|MRSaveSynchronously completion:nil];
//    }];
}

+ (void) saveUsingCurrentThreadContextWithBlockAndWait:(void (^)(NSManagedObjectContext *localContext))block;
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];

    [localContext performBlockAndWait:^{
        if (block)
        {
            block(localContext);
        }

        [localContext MR_saveWithOptions:MRSaveParentContexts|MRSaveSynchronously completion:nil];
    }];
}


#pragma mark - Deprecated methods

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

+ (void) saveInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block;
{
    [[self class] saveWithBlock:block completion:nil];
}

+ (void) saveInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(void(^)(void))completion;
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_confinementContext];

    if (block)
    {
        block(localContext);
    }
 
    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (completion)
        {
            completion();
        } 
    }];
}

+ (void) saveInBackgroundUsingCurrentContextWithBlock:(void (^)(NSManagedObjectContext *localContext))block completion:(void (^)(void))completion errorHandler:(void (^)(NSError *error))errorHandler;
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];

    [localContext performBlock:^{
        if (block)
        {
            block(localContext);
        }

        [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            if (success)
            {
                if (completion)
                {
                    completion();
                }
            }
            else
            {
                if (errorHandler)
                {
                    errorHandler(error);
                }
            }
        }];
    }];
}

#pragma clang diagnostic pop // ignored "-Wdeprecated-implementations"

@end
