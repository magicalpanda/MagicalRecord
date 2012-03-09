//
//  NSManagedObjectContext+MagicalSaves.m
//  Magical Record
//
//  Created by Saul Mora on 3/9/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObjectContext+MagicalSaves.h"

@interface NSManagedObjectContext (InternalMagicalSaves)

- (void) MR_saveErrorCallback:(void(^)(NSError *))errorCallback;

@end


@implementation NSManagedObjectContext (MagicalSaves)

- (void) MR_saveErrorCallback:(void(^)(NSError *))errorCallback;
{
    MRLog(@"Saving %@Context%@", self == [[self class] MR_defaultContext] ? @" *** Default *** ": @"", ([NSThread isMainThread] ? @" *** on Main Thread ***" : @""));

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
        [self MR_saveErrorCallback:errorCallback];
    }];
    [[self parentContext] MR_saveNestedContextsErrorHandler:errorCallback];
}

- (void) MR_save;
{
    [self MR_saveErrorCallback:nil];
}

- (void) MR_saveErrorHandler:(void (^)(NSError *))errorCallback;
{
    [self performBlockAndWait:^{
        [self MR_saveErrorCallback:errorCallback];
    }];
}

- (void) MR_saveInBackground;
{
    [self MR_saveInBackgroundErrorHandler:nil];
}

- (void) MR_saveInBackgroundErrorHandler:(void (^)(NSError *))errorCallback;
{
    [self performBlock:^{
        [self MR_saveErrorCallback:errorCallback];
    }];
}

@end
