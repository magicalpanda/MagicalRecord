//
//  NSFetchedResultsController+MagicalFetching.h
//  TradeShow
//
//  Created by Saul Mora on 2/5/13.
//  Copyright (c) 2013 Magical Panda Software. All rights reserved.
//

#import <CoreData/CoreData.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
/**
 Category methods to make working with NSFetchedResultsController simpler.

 @since Available in v3.0 and later.
 */
@interface NSFetchedResultsController (MagicalFetching)

/**
 Executes -performFetch: and logs any errors to the console.

 @since Available in v3.0 and later.
 */
- (void) MR_performFetch;

@end
#endif
