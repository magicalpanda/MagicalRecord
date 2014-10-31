//
//  NSManagedObjectContext+MagicalSaves.m
//  Magical Record
//
//  Created by Saul Mora on 3/9/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObjectContext+MagicalSaves.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSError+MagicalRecordErrorHandling.h"
#import "MagicalRecordStack.h"
#import "MagicalRecordLogging.h"

@implementation NSManagedObjectContext (MagicalSaves)

- (BOOL) MR_saveOnlySelfAndWait;
{
    __block BOOL saveResult = NO;

    [self MR_saveWithOptions:MRContextSaveOptionsSaveSynchronously completion:^(BOOL success, NSError *error) {
        saveResult = success;
    }];

    return saveResult;
}

- (BOOL) MR_saveOnlySelfAndWaitWithError:(NSError **)error;
{
    __block BOOL saveResult = NO;
    __block NSError *saveError;

    [self MR_saveWithOptions:MRContextSaveOptionsSaveSynchronously completion:^(BOOL localSuccess, NSError *localError) {
        saveResult = localSuccess;
        saveError = localError;
    }];

    if (error != nil) {
        *error = saveError;
    }

    return saveResult;
}

- (void) MR_saveOnlySelfWithCompletion:(MRSaveCompletionHandler)completion;
{
    [self MR_saveWithOptions:MRContextSaveOptionsNone completion:completion];
}

- (void) MR_saveToPersistentStoreWithCompletion:(MRSaveCompletionHandler)completion;
{
    [self MR_saveWithOptions:MRContextSaveOptionsSaveParentContexts completion:completion];
}

- (BOOL) MR_saveToPersistentStoreAndWait;
{
    __block BOOL saveResult = NO;

    MRContextSaveOptions saveOptions = (MRContextSaveOptions)(MRContextSaveOptionsSaveParentContexts | MRContextSaveOptionsSaveSynchronously);
    [self MR_saveWithOptions:saveOptions completion:^(BOOL success, NSError *error) {
        saveResult = success;
    }];

    return saveResult;
}

- (BOOL) MR_saveToPersistentStoreAndWaitWithError:(NSError **)error;
{
    __block BOOL saveResult = NO;
    __block NSError *saveError;

    MRContextSaveOptions saveOptions = (MRContextSaveOptions)(MRContextSaveOptionsSaveParentContexts | MRContextSaveOptionsSaveSynchronously);

    [self MR_saveWithOptions:saveOptions completion:^(BOOL localSuccess, NSError *localError) {
        saveResult = localSuccess;
        saveError = localError;
    }];

    if (error != nil) {
        *error = saveError;
    }

    return saveResult;
}

- (void) MR_saveWithOptions:(MRContextSaveOptions)saveOptions completion:(MRSaveCompletionHandler)completion;
{
    BOOL saveParentContexts = ((saveOptions & MRContextSaveOptionsSaveParentContexts) == MRContextSaveOptionsSaveParentContexts);
    BOOL saveSynchronously = ((saveOptions & MRContextSaveOptionsSaveSynchronously) == MRContextSaveOptionsSaveSynchronously);

    __block BOOL hasChanges = NO;

    if ([self concurrencyType] == NSConfinementConcurrencyType)
    {
        hasChanges = [self hasChanges];
    }
    else
    {
        [self performBlockAndWait:^{
            hasChanges = [self hasChanges];
        }];
    }

    if (!hasChanges)
    {
        MRLogInfo(@"NO CHANGES IN ** %@ ** CONTEXT - NOT SAVING", [self MR_workingName]);

        if (saveParentContexts && [self parentContext])
        {
            MRLogVerbose(@"Proceeding to save parent context %@", [[self parentContext] MR_description]);
        }
        else
        {
            if (completion)
            {
                completion(YES, nil);
            }

            return;
        }
    }

    void (^saveBlock)(void) = ^{
        NSString *optionsSummary = @"";
        optionsSummary = [optionsSummary stringByAppendingString:saveParentContexts ? @"Save Parents,":@""];
        optionsSummary = [optionsSummary stringByAppendingString:saveSynchronously ? @"Sync Save":@""];

        MRLogVerbose(@"→ Saving %@ [%@]", [self MR_description], optionsSummary);

        NSError *error = nil;
        BOOL saved = NO;

        @try
        {
            saved = [self save:&error];
        }
        @catch(NSException *exception)
        {
            MRLogError(@"Unable to perform save: %@", (id)[exception userInfo] ? : (id)[exception reason]);
        }
        @finally
        {
            if (!saved) {
                [[error MR_coreDataDescription] MR_logToConsole];

                if (completion) {
                    completion(saved, error);
                }
            } else {
                // If we should not save the parent context, or there is not a parent context to save (root context), call the completion block
                if ((YES == saveParentContexts) && [self parentContext]) {
                    MRContextSaveOptions parentContentSaveOptions = (MRContextSaveOptions)(MRContextSaveOptionsSaveParentContexts | MRContextSaveOptionsSaveSynchronously);
                    [[self parentContext] MR_saveWithOptions:parentContentSaveOptions completion:completion];
                }
                // If we are not the default context (And therefore need to save the root context, do the completion action if one was specified
                else {
                    MRLogInfo(@"→ Finished saving: %@", [self MR_description]);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
                    NSUInteger numberOfInsertedObjects = [[self insertedObjects] count];
                    NSUInteger numberOfUpdatedObjects = [[self updatedObjects] count];
                    NSUInteger numberOfDeletedObjects = [[self deletedObjects] count];
#pragma clang diagnostic pop
                    
                    MRLogVerbose(@"Objects - Inserted %tu, Updated %tu, Deleted %tu", numberOfInsertedObjects, numberOfUpdatedObjects, numberOfDeletedObjects);

                    if (completion) {
                        completion(saved, error);
                    }
                }
            }
        }
    };

    if ([self concurrencyType] == NSConfinementConcurrencyType)
    {
        saveBlock();
    }
    else if (YES == saveSynchronously)
    {
        [self performBlockAndWait:saveBlock];
    }
    else
    {
        [self performBlock:saveBlock];
    }
}

@end
