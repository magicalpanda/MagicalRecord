//
//  MagicalRecord+Actions.m
//
//  Created by Saul Mora on 2/24/11.
//  Copyright 2011 Magical Panda Software. All rights reserved.
//

#import "CoreData+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalRecord.h"

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
        MRDispatchQueueRelease(background_action_queue);
        background_action_queue = NULL;
    }
}

@implementation MagicalRecord (Actions)

+ (void) saveInBackgroundUsingContext:(NSManagedObjectContext *)localContext block:(void (^)(NSManagedObjectContext *))block completion:(void(^)(void))completion errorHandler:(void(^)(NSError *))errorHandler;
{
    dispatch_async(action_queue(), ^{
        block(localContext);
        
        [localContext MR_saveNestedContextsErrorHandler:errorHandler completion:completion];
    });
}

+ (void) saveInBackgroundWithBlock:(void (^)(NSManagedObjectContext *))block completion:(void (^)(void))completion errorHandler:(void (^)(NSError *))errorHandler;
{
    NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_defaultContext];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextWithParent:mainContext];
    
    [self saveInBackgroundUsingContext:localContext block:block completion:completion errorHandler:errorHandler];
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
        [localContext MR_saveErrorHandler:errorHandler];
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
