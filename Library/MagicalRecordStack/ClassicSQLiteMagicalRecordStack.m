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

- (NSManagedObjectContext *)newConfinementContext;
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_confinementContext];
    [context setPersistentStoreCoordinator:self.coordinator];
    return context;
}

//TODO: does this go somewhere else?
- (void) saveWithBlock:(void (^)(NSManagedObjectContext *))block identifier:(NSString *)contextWorkingName completion:(MRSaveCompletionHandler)completion;
{
    MRLogVerbose(@"Dispatching save request: %@", contextWorkingName);
    dispatch_async(MR_saveQueue(), ^{
        MRLogVerbose(@"%@ save starting", contextWorkingName);

        NSManagedObjectContext *localContext = [self newConfinementContext];
        NSManagedObjectContext *mainContext = [self context];

        [mainContext MR_observeContext:localContext];
        [mainContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
        [localContext MR_setWorkingName:contextWorkingName];

        if (block)
        {
            block(localContext);
        }

        [localContext MR_saveWithOptions:MRSaveSynchronously completion:completion];
        [mainContext MR_stopObservingContext:localContext];
    });
}

@end
