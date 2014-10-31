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
    [context setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];

    //TODO: This observation needs to be torn down by the user at this time :(
    [self.context MR_observeContextDidSave:context];
    
    return context;
}

- (void) saveWithBlock:(void (^)(NSManagedObjectContext *))block identifier:(NSString *)contextWorkingName completion:(MRSaveCompletionHandler)completion;
{
    NSParameterAssert(block);

    MRLogVerbose(@"Dispatching save request: %@", contextWorkingName);
    dispatch_async(MR_saveQueue(), ^{
        MRLogVerbose(@"%@ save starting", contextWorkingName);

        NSManagedObjectContext *localContext = [self newConfinementContext];
        NSManagedObjectContext *mainContext = [self context];

        [mainContext MR_observeContextDidSave:localContext];
        [mainContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
        [localContext MR_setWorkingName:contextWorkingName];

        block(localContext);

        [localContext MR_saveWithOptions:MRContextSaveOptionsSaveSynchronously completion:completion];
        [mainContext MR_stopObservingContextDidSave:localContext];
    });
}

@end
