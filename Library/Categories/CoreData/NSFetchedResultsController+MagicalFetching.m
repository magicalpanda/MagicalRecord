//
//  NSFetchedResultsController+MagicalFetching.m
//  TradeShow
//
//  Created by Saul Mora on 2/5/13.
//  Copyright (c) 2013 Magical Panda Software. All rights reserved.
//

#import "NSFetchedResultsController+MagicalFetching.h"
#import "NSError+MagicalRecordErrorHandling.h"

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
@implementation NSFetchedResultsController (MagicalFetching)

- (void) MR_performFetch;
{
    NSError *error = nil;
    BOOL success = [self performFetch:&error];
    
    if (!success)
    {
        [[error MR_coreDataDescription] MR_logToConsole];
    }
}

@end
#endif
