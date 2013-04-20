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
    NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_rootSavingContext];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextWithParent:mainContext];
    
    MRSaveCompletionHandler newCompletionBlock;
    newCompletionBlock = [self completionBlockWithMergeFromCompletionBlock:completion];

    [localContext performBlock:^{
        if (block) {
            block(localContext);
        }

        [localContext MR_saveWithOptions:MRSaveParentContexts completion:newCompletionBlock];
    }];
}

+ (void) saveUsingCurrentThreadContextWithBlock:(void (^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    MRSaveCompletionHandler newCompletionBlock;
    newCompletionBlock = [self completionBlockWithMergeFromCompletionBlock:completion];

    [localContext performBlock:^{
        if (block) {
            block(localContext);
        }

        [localContext MR_saveWithOptions:MRSaveParentContexts completion:newCompletionBlock];
    }];
}


#pragma mark - Synchronous saving

+ (void) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;
{
    NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_rootSavingContext];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextWithParent:mainContext];

    [localContext performBlockAndWait:^{
        if (block) {
            block(localContext);
        }

        [localContext MR_saveWithOptions:MRSaveParentContexts|MRSaveSynchronously completion:nil];
    }];
    
    [self refreshDefaultContext];
}

+ (void) saveUsingCurrentThreadContextWithBlockAndWait:(void (^)(NSManagedObjectContext *localContext))block;
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];

    [localContext performBlockAndWait:^{
        if (block) {
            block(localContext);
        }

        [localContext MR_saveWithOptions:MRSaveParentContexts|MRSaveSynchronously completion:nil];
    }];
    
    [self refreshDefaultContext];
}


#pragma mark - Post Save Merge Block Creation

+ (MRSaveCompletionHandler)completionBlockWithMergeFromCompletionBlock:(MRSaveCompletionHandler)completion
{
    MRSaveCompletionHandler newCompletionBlock = ^(BOOL success, NSError *error) {
        if (success) {
            [self refreshDefaultContext];
        }
        
        if (completion) {
            completion(success, error);
        }
    };
    return newCompletionBlock;
}

+ (void)refreshDefaultContext
{
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
    
    [defaultContext performBlockAndWait:^{
        NSSet *registeredObjects = [defaultContext registeredObjects];
        
        for (NSManagedObject *object in registeredObjects) {
            [defaultContext refreshObject:object mergeChanges:[object hasChanges]];
        }
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
    NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_defaultContext];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextWithParent:mainContext];

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
