//
//  NSFetchedResultsController+MagicalRecord.h
//  wetter-com-iphone
//
//  Created by Manuel "StuFF mc" Carrasco Molina on 26.01.13.
//  Copyright (c) 2013 grandcentrix GmbH. All rights reserved.
//

#import <CoreData/CoreData.h>

#if TARGET_OS_IPHONE

@interface NSFetchedResultsController (MagicalRecord)

- (NSInteger)MR_numberOfObjectsInSection:(NSUInteger)section;
- (NSUInteger)MR_fuzzyNumberOfObjectsInSection:(NSUInteger)section;

@end

#endif
