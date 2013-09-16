//
//  MagicalRecord+Actions.m
//
//  Created by Saul Mora on 2/24/11.
//  Copyright 2011 Magical Panda Software. All rights reserved.
//

#import "MagicalRecordStack+Actions.h"
#import "CoreData+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "MagicalRecordStack.h"

#if MR_LOG_LEVEL >= 0
static NSInteger ddLogLevel = MR_LOG_LEVEL;
#endif

dispatch_queue_t MR_saveQueue(void);
dispatch_queue_t MR_saveQueue()
{
    static dispatch_queue_t serial_save_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serial_save_queue = dispatch_queue_create("com.magicalpanda.magicalrecord.serialsavequeue", DISPATCH_QUEUE_SERIAL);
    });
    return serial_save_queue;
}

@implementation MagicalRecordStack (Actions)

#pragma mark - Asynchronous saving

- (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;
{
    [self saveWithBlock:block identifier:NSStringFromSelector(_cmd) completion:nil];
}

- (void) saveWithIdentifier:(NSString *)identifier block:(void(^)(NSManagedObjectContext *))block;
{
    [self saveWithBlock:block identifier:identifier completion:nil];
}

- (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;
{
    [self saveWithBlock:block identifier:NSStringFromSelector(_cmd) completion:completion];
}

- (void) saveWithBlock:(void (^)(NSManagedObjectContext *))block identifier:(NSString *)contextWorkingName completion:(MRSaveCompletionHandler)completion;
{
    MRLog(@"Dispatching save request: %@", contextWorkingName);
    dispatch_async(MR_saveQueue(), ^{
        MRLog(@"%@ save starting", contextWorkingName);
        
        NSManagedObjectContext *localContext = [self newConfinementContext];
        [localContext MR_setWorkingName:contextWorkingName];
        
        if (block)
        {
            block(localContext);
        }

        [localContext MR_saveWithOptions:MRSaveParentContexts|MRSaveSynchronously completion:completion];
    });
}

#pragma mark - Synchronous saving

- (void) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;
{
    NSManagedObjectContext *localContext = [self newConfinementContext];
    
    if (block)
    {
        block(localContext);
    }

    [localContext MR_saveWithOptions:MRSaveParentContexts|MRSaveSynchronously completion:nil];
}

@end
