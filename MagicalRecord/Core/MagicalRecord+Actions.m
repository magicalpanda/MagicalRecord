//
//  ARCoreDataAction.m
//  Freshpod
//
//  Created by Saul Mora on 2/24/11.
//  Copyright 2011 Magical Panda Software. All rights reserved.
//

#import "CoreData+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "MagicalRecordPersistenceStrategy.h"

static dispatch_queue_t background_action_queue;

dispatch_queue_t action_queue(void);
dispatch_queue_t action_queue(void)
{
    if (background_action_queue == NULL)
    {
        background_action_queue = dispatch_queue_create("com.magicalpanda.magicalrecord.actionQueue", DISPATCH_QUEUE_SERIAL);
    }
    return background_action_queue;
}

void reset_action_queue(void);
void reset_action_queue(void)
{
    if (background_action_queue != NULL)
    {
        //        dispatch_release(background_action_queue);
        background_action_queue = NULL;
    }
}

@implementation MagicalRecord (Actions)

+ (void) saveInBackgroundUsingContext:(NSManagedObjectContext *)localContext block:(void (^)(NSManagedObjectContext *))block completion:(void(^)(void))completion errorHandler:(void(^)(NSError *))errorHandler;
{
    dispatch_group_t completionGroup = dispatch_group_create();
        [localContext performBlock:^{
            block(localContext);
            // Save the context we were given
            [localContext MR_saveErrorHandler:nil];
            if (localContext.parentContext) {
                // If we're doing nested contexs, save parent
                dispatch_group_enter(completionGroup);
                [localContext.parentContext performBlock:^{
                    [localContext.parentContext MR_saveErrorHandler:nil];
                    dispatch_group_leave(completionGroup);
                }];
            }

            // If the context has a parent context, this code will execute after the save.
            // If not, it will execute immediately
            dispatch_group_notify(completionGroup, dispatch_get_main_queue(), ^{
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion();
                    });
                }

                dispatch_release(completionGroup);
            });
        }];
 
}

+ (void) saveInBackgroundWithBlock:(void (^)(NSManagedObjectContext *))block completion:(void (^)(void))completion errorHandler:(void (^)(NSError *))errorHandler;
{
    NSManagedObjectContext *savingContext = [[MagicalRecord persistenceStrategy] contextToUseForBackgroundSaves];
    [self saveInBackgroundUsingContext:savingContext block:block completion:completion errorHandler:errorHandler];
}

+ (void) saveInBackgroundUsingCurrentContextWithBlock:(void (^)(NSManagedObjectContext *))block completion:(void (^)(void))completion errorHandler:(void (^)(NSError *))errorHandler;
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    [self saveInBackgroundUsingContext:localContext block:block completion:completion errorHandler:errorHandler];
}
                                    
+ (void) saveWithBlock:(void (^)(NSManagedObjectContext *localContext))block completion:(void (^)(void))completion errorHandler:(void (^)(NSError *))errorHandler;
{
    NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_defaultContext];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextWithParent:mainContext];

    block(localContext);
    
    if ([localContext hasChanges]) 
    {
        [localContext MR_saveNestedContextsErrorHandler:errorHandler];
    }
    
    if (completion)
    {
        dispatch_async(dispatch_get_main_queue(), completion);
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

@end
