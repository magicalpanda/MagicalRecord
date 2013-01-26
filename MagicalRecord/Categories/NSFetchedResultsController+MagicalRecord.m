//
//  NSFetchedResultsController+MagicalRecord.m
//  wetter-com-iphone
//
//  Created by Manuel "StuFF mc" Carrasco Molina on 26.01.13.
//  Copyright (c) 2013 grandcentrix GmbH. All rights reserved.
//

#import "NSFetchedResultsController+MagicalRecord.h"

#if TARGET_OS_IPHONE

@implementation NSFetchedResultsController (MagicalRecord)

- (NSInteger)MR_numberOfObjectsInSection:(NSUInteger)section
{
    NSUInteger count = -1; // This means section out of index in a nicer way!
    if (section < self.sections.count) {
        id<NSFetchedResultsSectionInfo> info = self.sections[section];
        count = [info numberOfObjects];
    }
    return count;
}

- (NSUInteger)MR_fuzzyNumberOfObjectsInSection:(NSUInteger)section
{
    NSInteger count = [self MR_numberOfObjectsInSection:section];
    count = (count > 0) ? count : 0;
    return count;
}

@end

#endif
