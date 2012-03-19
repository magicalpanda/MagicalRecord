//
//  OCHamcrest - HCIsCollectionContainingInAnyOrder.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrest/HCBaseMatcher.h>


/**
    Matches a collection if its elements, in any order, satisfy a list of matchers.

    @b Factory: @ref containsInAnyOrder
    @ingroup collection_matchers
 */
@interface HCIsCollectionContainingInAnyOrder : HCBaseMatcher
{
    NSMutableArray *matchers;
}

+ (id)isCollectionContainingInAnyOrder:(NSMutableArray *)itemMatchers;
- (id)initWithMatchers:(NSMutableArray *)itemMatchers;

@end


#pragma mark -

/**
    Matches a collection if its elements, in any order, satisfy a list of matchers.
 
    @b Synonym: @ref containsInAnyOrder
    @param itemMatcher1  Comma-separated list of matchers - or values for @ref equalTo matching - ending with @c nil.
    @see HCIsCollectionContainingInAnyOrder
    @ingroup collection_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_containsInAnyOrder(id itemMatcher1, ...);

/**
    containsInAnyOrder(itemMatcher1, ...) -
    Matches a collection if its elements, in any order, satisfy a list of matchers.

    Synonym for @ref HC_containsInAnyOrder, available if @c HC_SHORTHAND is defined.
    @param itemMatcher1  Comma-separated list of matchers - or values for @ref equalTo matching - ending with @c nil.
    @see HCIsCollectionContainingInAnyOrder
    @ingroup collection_matchers
 */
#ifdef HC_SHORTHAND
    #define containsInAnyOrder HC_containsInAnyOrder
#endif
