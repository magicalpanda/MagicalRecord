//
//  NSManagedObjectContext+MagicalSaves.m
//  Magical Record
//
//  Created by Saul Mora on 3/9/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObjectContext+MagicalSaves.h"

@implementation NSManagedObjectContext (MagicalSaves)

- (BOOL) MR_saveNestedContexts:(BOOL)saveParents errorHandler:(void(^)(NSError *))errorCallback;
{
	__block NSError *error = nil;
	__block BOOL saved = NO;
	
	@try
	{
        [self performBlockAndWait:^{
            MRLog(@"Saving %@Context%@", 
                  self == [[self class] MR_defaultContext] ? @" *** Default *** ": @"",
                  ([NSThread isMainThread] ? @" *** on Main Thread ***" : @""));
            
            saved = [self save:&error];
        }];
	}
	@catch (NSException *exception)
	{
		MRLog(@"Problem saving: %@", (id)[exception userInfo] ?: (id)[exception reason]);
	}
	@finally 
    {
        NSManagedObjectContext *parentContext = [self parentContext];
        if (saved && saveParents)
        {
            return saved && [parentContext MR_saveNestedContexts:saveParents errorHandler:errorCallback];
        }
        if (!saved)
        {
            [MagicalRecord handleErrors:error];
        }
        return saved;
    }
}

- (BOOL) MR_saveNestedContextsErrorHandler:(void (^)(NSError *))errorCallback;
{
    return [self MR_saveNestedContexts:YES errorHandler:errorCallback];
}

- (BOOL) MR_saveWithErrorHandler:(void (^)(NSError *))errorCallback;
{
    return [self MR_saveNestedContexts:NO errorHandler:errorCallback];
}

- (BOOL) MR_save;
{
    return [self MR_saveNestedContexts:NO errorHandler:nil];
}

#pragma mark - Threading Save Helpers

- (BOOL) MR_saveOnBackgroundThread;
{
	[self performSelectorInBackground:@selector(MR_save) withObject:nil];
    
	return YES;
}

- (BOOL) MR_saveOnMainThread;
{
	@synchronized(self)
	{
		[self performSelectorOnMainThread:@selector(MR_save) withObject:nil waitUntilDone:YES];
	}
    
	return YES;
}

@end
