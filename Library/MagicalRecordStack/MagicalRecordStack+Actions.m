//
//  MagicalRecord+Actions.m
//
//  Created by Saul Mora on 2/24/11.
//  Copyright 2011 Magical Panda Software. All rights reserved.
//

#import "MagicalRecordStack+Actions.h"
#import "MagicalRecord.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "MagicalRecordStack.h"
#import "MagicalRecordLogging.h"

static dispatch_queue_t save_queue;
static dispatch_once_t save_queue_once_token;
static dispatch_once_t *save_queue_reset_token;

void MR_releaseSaveQueue(void);
dispatch_queue_t MR_newSaveQueue(void);

void MR_releaseSaveQueue(void)
{
    save_queue = nil;
    *save_queue_reset_token = 0;
}

dispatch_queue_t MR_newSaveQueue()
{
    return dispatch_queue_create("com.magicalpanda.magicalrecord.savequeue", DISPATCH_QUEUE_SERIAL);
}

dispatch_queue_t MR_saveQueue()
{
    dispatch_once(&save_queue_once_token, ^{
        save_queue_reset_token = &save_queue_once_token;
        save_queue = MR_newSaveQueue();
    });
    return save_queue;
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
    NSParameterAssert(block);
    MRLogVerbose(@"Dispatching save request: %@", contextWorkingName);
    dispatch_async(MR_saveQueue(), ^{
        @autoreleasepool
        {
            MRLogVerbose(@"%@ save starting", contextWorkingName);
            
            NSManagedObjectContext *localContext = [self newConfinementContext];
            [localContext MR_setWorkingName:contextWorkingName];
            
            block(localContext);

            MRContextSaveOptions saveOptions = (MRContextSaveOptions)(MRContextSaveOptionsSaveParentContexts | MRContextSaveOptionsSaveSynchronously);
            [localContext MR_saveWithOptions:saveOptions completion:completion];
        }
    });
}

#pragma mark - Synchronous saving

- (BOOL) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;
{
    return [self saveWithBlockAndWait:block error:nil];
}

- (BOOL) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block error:(NSError **)error;
{
    NSParameterAssert(block);
    NSManagedObjectContext *localContext = [self newConfinementContext];

    block(localContext);

    if (NO == [localContext hasChanges])
    {
        MRLogInfo(@"NO CHANGES IN ** %@ ** CONTEXT - NOT SAVING", [localContext MR_workingName]);

        return YES;
    }

    __block BOOL saveSuccess = YES;

    MRContextSaveOptions saveOptions = (MRContextSaveOptions)(MRContextSaveOptionsSaveParentContexts | MRContextSaveOptionsSaveSynchronously);
    [localContext MR_saveWithOptions:saveOptions completion:^(BOOL localSuccess, NSError *localSaveError) {
        saveSuccess = localSuccess;

        if (error != nil)
        {
            *error = localSaveError;
        }
    }];

    return saveSuccess;
}

@end
