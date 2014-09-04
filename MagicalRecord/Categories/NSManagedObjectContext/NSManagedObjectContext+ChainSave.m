//
//  MagicalRecord+ChainSave.m
//  transformableTest
//
//  Created by Lee on 8/27/14.
//  Copyright (c) 2014 Lei. All rights reserved.
//

#import "NSManagedObjectContext+ChainSave.h"

@implementation NSManagedObjectContext(MagicalRecord_ChainSave)
- (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;
{
    [self saveWithBlock:block completion:nil];
}

- (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;
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

- (void) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;
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
