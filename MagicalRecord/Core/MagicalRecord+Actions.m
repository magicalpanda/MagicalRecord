//
//  MagicalRecord+Actions.m
//
//  Created by Saul Mora on 2/24/11.
//  Copyright 2011 Magical Panda Software. All rights reserved.
//

#import "CoreData+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalRecord.h"

@interface MagicalRecord (Internal)

+ (void) didBeginSaveOperation;
+ (void) didEndSaveOperation;

@end

@implementation MagicalRecord (Actions)

#pragma mark - Asynchronous saving

+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;
{
    [self saveWithBlock:block completion:nil];
}

+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;
{
	[MagicalRecord didBeginSaveOperation];
	
    NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_defaultContext];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextWithParent:mainContext];

    [localContext performBlock:^{
        if (block) {
            block(localContext);
        }

        [localContext MR_saveWithOptions:MRSaveParentContexts|MRSaveSynchronously completion:completion];
		
		[MagicalRecord didEndSaveOperation];
    }];
}

+ (void) saveUsingCurrentThreadContextWithBlock:(void (^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;
{
	[MagicalRecord didBeginSaveOperation];
	
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];

    [localContext performBlock:^{
        if (block) {
            block(localContext);
        }

        [localContext MR_saveWithOptions:MRSaveParentContexts|MRSaveSynchronously completion:completion];
		
		[MagicalRecord didEndSaveOperation];
    }];
}


#pragma mark - Synchronous saving

+ (void) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;
{
	[MagicalRecord didBeginSaveOperation];
	
    NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_defaultContext];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextWithParent:mainContext];

    [localContext performBlockAndWait:^{
        if (block) {
            block(localContext);
        }

        [localContext MR_saveWithOptions:MRSaveParentContexts|MRSaveSynchronously completion:nil];
		
		[MagicalRecord didEndSaveOperation];
    }];
}

+ (void) saveUsingCurrentThreadContextWithBlockAndWait:(void (^)(NSManagedObjectContext *localContext))block;
{
	[MagicalRecord didBeginSaveOperation];
	
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];

    [localContext performBlockAndWait:^{
        if (block) {
            block(localContext);
        }

        [localContext MR_saveWithOptions:MRSaveParentContexts|MRSaveSynchronously completion:nil];
		
		[MagicalRecord didEndSaveOperation];
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
	[MagicalRecord didBeginSaveOperation];
	
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
		
		[MagicalRecord didEndSaveOperation];
    }];
}

+ (void) saveInBackgroundUsingCurrentContextWithBlock:(void (^)(NSManagedObjectContext *localContext))block completion:(void (^)(void))completion errorHandler:(void (^)(NSError *error))errorHandler;
{
	[MagicalRecord didBeginSaveOperation];
	
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
			[MagicalRecord didEndSaveOperation];
        }];
    }];
}

#pragma clang diagnostic pop // ignored "-Wdeprecated-implementations"

@end
