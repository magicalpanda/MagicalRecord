//
//  NSManagedObjectContext+MagicalSaves.m
//  Magical Record
//
//  Created by Saul Mora on 3/9/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObjectContext+MagicalSaves.h"
#import "MagicalRecord+ErrorHandling.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "MagicalRecord.h"

@implementation NSManagedObjectContext (MagicalSaves)

- (void)MR_saveOnlySelfWithCompletion:(MRSaveCompletionHandler)completion;
{
    [self MR_saveWithOptions:0 completion:completion];
}

- (void)MR_saveOnlySelfAndWait;
{
    [self MR_saveWithOptions:MRSaveSynchronously completion:nil];
}

- (void) MR_saveToPersistentStoreWithCompletion:(MRSaveCompletionHandler)completion;
{
    [self MR_saveWithOptions:MRSaveParentContexts completion:completion];
}

- (void) MR_saveToPersistentStoreAndWait;
{
    [self MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:nil];
}

- (void)MR_saveWithOptions:(MRSaveContextOptions)mask completion:(MRSaveCompletionHandler)completion;
{
    BOOL syncSave           = ((mask & MRSaveSynchronously) == MRSaveSynchronously);
    BOOL saveParentContexts = ((mask & MRSaveParentContexts) == MRSaveParentContexts);

    if (![self hasChanges]) {
        MRLog(@"NO CHANGES IN ** %@ ** CONTEXT - NOT SAVING", [self MR_workingName]);

        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NO, nil);
            });
        }
        
        return;
    }

    MRLog(@"→ Saving %@", [self MR_description]);
    MRLog(@"→ Save Parents? %@", @(saveParentContexts));
    MRLog(@"→ Save Synchronously? %@", @(syncSave));

    id saveBlock = ^{
        NSError *error = nil;
        BOOL     saved = NO;

        @try
        {
            saved = [self save:&error];
        }
        @catch(NSException *exception)
        {
            MRLog(@"Unable to perform save: %@", (id)[exception userInfo] ? : (id)[exception reason]);
        }

        @finally
        {
            if (!saved) {
                [MagicalRecord handleErrors:error];

                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(saved, error);
                    });
                }
            } else {
                // If we're the default context, save to disk too (the user expects it to persist)
                if (self == [[self class] MR_defaultContext]) {
                    [[[self class] MR_rootSavingContext] MR_saveWithOptions:MRSaveSynchronously completion:completion];
                }
                // If we're saving parent contexts, do so
                else if ((YES == saveParentContexts) && [self parentContext]) {
                    [[self parentContext] MR_saveWithOptions:MRSaveSynchronously | MRSaveParentContexts completion:completion];
                }
                // If we are not the default context (And therefore need to save the root context, do the completion action if one was specified
                else {
                    MRLog(@"→ Finished saving: %@", [self MR_description]);

                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(saved, error);
                        });
                    }
                }
            }
        }
    };

    if (YES == syncSave) {
        [self performBlockAndWait:saveBlock];
    } else {
        [self performBlock:saveBlock];
    }
}

#pragma mark - Deprecated methods
// These methods will be removed in MagicalRecord 3.0

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

- (void)MR_save;
{
    [self MR_saveToPersistentStoreAndWait];
}

- (void)MR_saveWithErrorCallback:(void (^)(NSError *error))errorCallback;
{
    [self MR_saveWithOptions:MRSaveSynchronously|MRSaveParentContexts completion:^(BOOL success, NSError *error) {
        if (!success) {
            if (errorCallback) {
                errorCallback(error);
            }
        }
    }];
}

- (void)MR_saveInBackgroundCompletion:(void (^)(void))completion;
{
    [self MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            if (completion) {
                completion();
            }
        }
    }];
}

- (void)MR_saveInBackgroundErrorHandler:(void (^)(NSError *error))errorCallback;
{
    [self MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            if (errorCallback) {
                errorCallback(error);
            }
        }
    }];
}

- (void)MR_saveInBackgroundErrorHandler:(void (^)(NSError *error))errorCallback completion:(void (^)(void))completion;
{
    [self MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            if (completion) {
                completion();
            }
        } else {
            if (errorCallback) {
                errorCallback(error);
            }
        }
    }];
}

- (void)MR_saveNestedContexts;
{
    [self MR_saveToPersistentStoreWithCompletion:nil];
}

- (void)MR_saveNestedContextsErrorHandler:(void (^)(NSError *error))errorCallback;
{
    [self MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            if (errorCallback) {
                errorCallback(error);
            }
        }
    }];
}

- (void)MR_saveNestedContextsErrorHandler:(void (^)(NSError *error))errorCallback completion:(void (^)(void))completion;
{
    [self MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            if (completion) {
                completion();
            }
        } else {
            if (errorCallback) {
                errorCallback(error);
            }
        }
    }];
}

#pragma clang diagnostic pop // ignored "-Wdeprecated-implementations"

@end
