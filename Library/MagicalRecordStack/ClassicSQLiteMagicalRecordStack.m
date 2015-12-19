//
//  ClassicSQLiteMagicalRecordStack.m
//  MagicalRecord
//
//  Created by Saul Mora on 10/21/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "ClassicSQLiteMagicalRecordStack.h"
#import "MagicalRecordStack+Actions.h"
#import "NSManagedObjectContext+MagicalObserving.h"
#import "MagicalRecordLogging.h"

@implementation ClassicSQLiteMagicalRecordStack

- (NSManagedObjectContext *)newPrivateQueueContext
{
    NSManagedObjectContext *context = [super newPrivateQueueContext]; // TODO: This no longer represents a "classic" setup, as confinement concurrency is deprecated
    context.persistentStoreCoordinator = self.coordinator;
    context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;

    //TODO: This observation needs to be torn down by the user at this time :(
    [self.context MR_observeContextDidSave:context];

    return context;
}

- (void)saveWithBlock:(void (^)(NSManagedObjectContext *))block identifier:(NSString *)contextWorkingName completion:(MRSaveCompletionHandler)completion
{
    NSParameterAssert(block);

    MRLogVerbose(@"Dispatching save request: %@", contextWorkingName);
    dispatch_async(MR_saveQueue(), ^{
        MRLogVerbose(@"%@ save starting", contextWorkingName);

        NSManagedObjectContext *localContext = [self newPrivateQueueContext];
        NSManagedObjectContext *mainContext = [self context];

        [mainContext MR_observeContextDidSave:localContext];
        [mainContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
        localContext.name = contextWorkingName;

        block(localContext);

        [localContext MR_saveWithOptions:MRContextSaveOptionsSaveSynchronously completion:completion];
        [mainContext MR_stopObservingContextDidSave:localContext];
    });
}

@end
