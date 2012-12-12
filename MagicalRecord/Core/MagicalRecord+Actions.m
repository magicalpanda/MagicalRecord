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
    NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_defaultContext];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextWithParent:mainContext];

    [localContext performBlock:^{
        if (block) {
            block(localContext);
        }

        [localContext MR_saveSelfAndParentContextsWithCompletion:completion];
    }];
}

+ (void) saveUsingCurrentContextWithBlock:(void (^)(NSManagedObjectContext *))block completion:(MRSaveCompletionHandler)completion;
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];

    [localContext performBlock:^{
        if (block) {
            block(localContext);
        }

        [localContext MR_saveSelfAndParentContextsWithCompletion:completion];
    }];
}


#pragma mark - Synchronous saving

+ (void) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;
{
    NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_defaultContext];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextWithParent:mainContext];

    [localContext performBlockAndWait:^{
        if (block) {
            block(localContext);
        }

        [localContext MR_saveSelfAndParentContextsAndWait];
    }];
}

+ (void) saveUsingCurrentContextWithBlockAndWait:(void (^)(NSManagedObjectContext *))block;
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];

    [localContext performBlockAndWait:^{
        if (block) {
            block(localContext);
        }

        [localContext MR_saveSelfAndParentContextsAndWait];
    }];
}


#pragma mark - Deprecated methods

+ (void) saveInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block
{
    [[self class] saveWithBlock:block completion:nil];
}

+ (void) saveInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(void(^)(void))completion
{
    NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_defaultContext];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextWithParent:mainContext];

    [localContext performBlock:^{
        if (block)
        {
            block(localContext);
        }

        [localContext MR_saveSelfAndParentContextsAndWait];

        if (completion)
        {
            completion();
        }
    }];
}

+ (void) saveInBackgroundUsingCurrentContextWithBlock:(void (^)(NSManagedObjectContext *))block completion:(void (^)(void))completion errorHandler:(void (^)(NSError *))errorHandler;
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];

    [localContext performBlock:^{
        if (block) {
            block(localContext);
        }

        [localContext MR_saveSelfAndParentContextsWithCompletion:^(BOOL success, NSError *error) {

            if (success) {
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

@end
