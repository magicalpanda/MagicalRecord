//
//  NSFetchedResultsController+MagicalFetching.h
//  TradeShow
//
//  Created by Saul Mora on 2/5/13.
//  Copyright (c) 2013 Magical Panda Software. All rights reserved.
//

#import <CoreData/CoreData.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
@interface NSFetchedResultsController (MagicalFetching)

- (void) MR_performFetch;

@end
#endif
