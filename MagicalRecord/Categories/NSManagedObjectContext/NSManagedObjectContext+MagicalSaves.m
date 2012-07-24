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

@interface NSManagedObjectContext (InternalMagicalSaves)

- (void) MR_saveWithErrorCallback:(void(^)(NSError *))errorCallback;

@end


@implementation NSManagedObjectContext (MagicalSaves)

- (void) MR_saveWithErrorCallback:(void(^)(NSError *))errorCallback;
{
    if (![self hasChanges])
    {
        MRLog(@"NO CHANGES IN CONTEXT %@ - NOT SAVING", [self MR_description]);
        return;
    }
    
    MRLog(@"-> Saving %@", [self MR_description]);

    NSError *error = nil;
	BOOL saved = NO;
	@try
	{
        saved = [self save:&error];
	}
	@catch (NSException *exception)
	{
		MRLog(@"Unable to perform save: %@", (id)[exception userInfo] ?: (id)[exception reason]);
	}
	@finally 
    {
        if (!saved)
        {
            if (errorCallback)
            {
                errorCallback(error);
            }
            else
            {
                [MagicalRecord handleErrors:error];
            }
        }
    }
}

- (void) MR_saveNestedContexts;
{
    [self MR_saveNestedContextsErrorHandler:nil];
}

- (void) MR_saveNestedContextsErrorHandler:(void (^)(NSError *))errorCallback;
{
    [self performBlockAndWait:^{
        [self MR_saveWithErrorCallback:errorCallback];
    }];
    [[self parentContext] MR_saveNestedContextsErrorHandler:errorCallback];
}

- (void) MR_save;
{
    [self MR_saveErrorHandler:nil];    
}

- (void) MR_saveErrorHandler:(void (^)(NSError *))errorCallback;
{
    [self performBlockAndWait:^{
        [self MR_saveWithErrorCallback:errorCallback];
    }];
    
    if (self == [[self class] MR_defaultContext])
    {
        [[[self class] MR_rootSavingContext] MR_saveInBackgroundErrorHandler:errorCallback];
    }
}

- (void) MR_saveInBackgroundCompletion:(void (^)(void))completion;
{
    [self MR_saveInBackgroundErrorHandler:nil completion:completion];
}

- (void) MR_saveInBackgroundErrorHandler:(void (^)(NSError *))errorCallback;
{
    [self MR_saveInBackgroundErrorHandler:errorCallback completion:nil];
}

- (void) MR_saveInBackgroundErrorHandler:(void (^)(NSError *))errorCallback completion:(void (^)(void))completion;
{
    [self performBlockAndWait:^{
        [self MR_saveWithErrorCallback:errorCallback];
        
        // If it's the default context, save the rootSavingContext too, THEN call the completion handler
        if (self == [[self class] MR_defaultContext])
        {
            [[[self class] MR_rootSavingContext] MR_saveInBackgroundErrorHandler:errorCallback completion:completion];
        } else {
            // If it's a child context, or if we've hit the root context, call the completion block.
            // Basically, the ONLY time we don't call it's called on the default context, and there is an implied root save
            if (completion)
            {
                dispatch_async(dispatch_get_main_queue(), completion);
            }
        }
    }];

}

@end
