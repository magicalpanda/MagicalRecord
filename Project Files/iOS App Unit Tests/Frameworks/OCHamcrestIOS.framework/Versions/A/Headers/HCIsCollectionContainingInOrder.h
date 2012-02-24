//
//  OCHamcrest - HCIsCollectionContainingInOrder.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCBaseMatcher.h>


/**
    Matches a collection if its elements, in order, satisfy a list of matchers.

    @b Factory: @ref contains
    @ingroup collection_matchers
 */
@interface HCIsCollectionContainingInOrder : HCBaseMatcher
{
    NSArray *matchers;
}

+ (id)isCollectionContainingInOrder:(NSArray *)itemMatchers;
- (id)initWithMatchers:(NSArray *)itemMatchers;

@end


#pragma mark -

/**
    Matches a collection if its elements, in order, satisfy a list of matchers.
 
    @b Synonym: @ref contains
    @param itemMatcher1  Comma-separated list of matchers - or values for @ref equalTo matching - ending with @c nil.
    @see HCIsCollectionContainingInOrder
    @ingroup collection_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_contains(id itemMatcher1, ...);

/**
    contains(itemMatcher1, ...)
    matches a collection if its elements, in order, satisfy a list of matchers.

    Synonym for @ref HC_contains, available if @c HC_SHORTHAND is defined.
    @param itemMatcher1  Comma-separated list of matchers - or values for @ref equalTo matching - ending with @c nil.
    @see HCIsCollectionContainingInOrder
    @ingroup collection_matchers
 */
#ifdef HC_SHORTHAND
    #define contains HC_contains
#endif
