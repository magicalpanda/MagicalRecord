//
//  MagicalRecord+Actions.m
//
//  Created by Saul Mora on 2/24/11.
//  Copyright 2011 Magical Panda Software. All rights reserved.
//

#import "CoreData+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalRecord.h"


@implementation MagicalRecord (Actions)

#pragma mark - Asynchronous saving

+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;
{
    [self saveWithBlock:block completion:nil];
}

+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;
{
    NSManagedObjectContext *savingContext  = [NSManagedObjectContext MR_rootSavingContext];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_newContextWithParent:savingContext];

    [localContext MR_setWorkingName:NSStringFromSelector(_cmd)];

    [localContext performBlock:^{
        if (block) {
            block(localContext);
        }

        [localContext MR_saveWithOptions:MRSaveParentContexts completion:completion];
    }];
}

+ (void) saveUsingCurrentThreadContextWithBlock:(void (^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];

    [localContext MR_setWorkingName:NSStringFromSelector(_cmd)];

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
    NSManagedObjectContext *savingContext  = [NSManagedObjectContext MR_rootSavingContext];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_newContextWithParent:savingContext];

    [localContext MR_setWorkingName:NSStringFromSelector(_cmd)];

    [localContext performBlockAndWait:^{
        if (block) {
            block(localContext);
        }

        [localContext MR_saveWithOptions:MRSaveParentContexts|MRSaveSynchronously completion:nil];
    }];
}

+ (void) saveUsingCurrentThreadContextWithBlockAndWait:(void (^)(NSManagedObjectContext *localContext))block;
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];

    [localContext MR_setWorkingName:NSStringFromSelector(_cmd)];

    [localContext performBlockAndWait:^{
        if (block) {
            block(localContext);
        }

        [localContext MR_saveWithOptions:MRSaveParentContexts|MRSaveSynchronously completion:nil];
    }];
}


#pragma mark - Deprecated methods

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

+ (void) saveInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block
{
    [[self class] saveWithBlock:block completion:nil];
}

+ (void) saveInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(void(^)(void))completion
{
    NSManagedObjectContext *savingContext  = [NSManagedObjectContext MR_rootSavingContext];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextWithParent:savingContext];

    [localContext MR_setWorkingName:NSStringFromSelector(_cmd)];

    [localContext performBlock:^{
        if (block)
        {
            block(localContext);
        }

        [localContext MR_saveToPersistentStoreAndWait];

        if (completion)
        {
            completion();
        }
    }];
}

+ (void) saveInBackgroundUsingCurrentContextWithBlock:(void (^)(NSManagedObjectContext *localContext))block completion:(void (^)(void))completion errorHandler:(void (^)(NSError *error))errorHandler;
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];

    [localContext MR_setWorkingName:NSStringFromSelector(_cmd)];

    [localContext performBlock:^{
        if (block) {
            block(localContext);
        }

        [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            if (success) {
                if (completion) {
                    completion();
                }
            }
            else {
                if (errorHandler) {
                    errorHandler(error);
                }
            }
        }];
    }];
}

#pragma clang diagnostic pop // ignored "-Wdeprecated-implementations"

@end
