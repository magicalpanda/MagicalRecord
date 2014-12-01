//
//  MagicalRecord+ChainSave.m
//  Magical Record
//
//  Created by Lee on 8/27/14.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObjectContext+MagicalChainSave.h"

@implementation NSManagedObjectContext(MagicalRecord_ChainSave)
- (void) MR_saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;
{
    [self saveWithBlock:block completion:nil];
}

- (void) MR_saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextWithParent:self];
    
    [localContext MR_setWorkingName:NSStringFromSelector(_cmd)];
    
    [localContext performBlock:^{
        if (block) {
            block(localContext);
        }
        
        [localContext MR_saveWithOptions:MRSaveParentContexts completion:completion];
    }];
}

#pragma mark - Synchronous saving

- (void) MR_saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextWithParent:self];
    
    [localContext MR_setWorkingName:NSStringFromSelector(_cmd)];
    
    [localContext performBlockAndWait:^{
        if (block) {
            block(localContext);
        }
        
        [localContext MR_saveWithOptions:MRSaveParentContexts|MRSaveSynchronously completion:nil];
    }];
}

@end
