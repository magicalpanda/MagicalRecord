//
//  OCHamcrest - HCIsCollectionContaining.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCBaseMatcher.h>


/**
    Matches a collection if any element satisfies a given matcher.

    @b Factory: @ref hasItem, @ref hasItems
    @ingroup collection_matchers
 */
@interface HCIsCollectionContaining : HCBaseMatcher
{
    id<HCMatcher> elementMatcher;
}

+ (id)isCollectionContaining:(id<HCMatcher>)anElementMatcher;
- (id)initWithMatcher:(id<HCMatcher>)anElementMatcher;

@end


#pragma mark -

/**
    Matches a collection if any element satifies a given matcher.
 
    @b Synonym: @ref hasItem
    @param matcherOrValue  A matcher, or a value for @ref equalTo matching.
    @see HCIsCollectionContaining
    @ingroup collection_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_hasItem(id matcherOrValue);

/**
    hasItem(matcherOrValue) -
    Matches a collection if any element satifies a given matcher.

    Synonym for @ref HC_hasItem, available if @c HC_SHORTHAND is defined.
    @param matcherOrValue  A matcher, or a value for @ref equalTo matching.
    @see HCIsCollectionContaining
    @ingroup collection_matchers
 */
#ifdef HC_SHORTHAND
    #define hasItem HC_hasItem
#endif


/**
    Matches a collection if all matchers are satisfied by any of the collection's elements.
 
    @b Synonym: @ref hasItems
    @param matcherOrValue1  Comma-separated list of matchers - or values for @ref equalTo matching - ending with @c nil.
    @see HCIsCollectionContaining
    @ingroup collection_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_hasItems(id matcherOrValue1, ...);

/**
    hasItems(matcherOrValue1, ...) -
    Matches a collection if all matchers are satisfied by any of the collection's elements.

    Synonym for @ref HC_hasItems, available if @c HC_SHORTHAND is defined.
    @param matcherOrValue1  Comma-separated list of matchers - or values for @ref equalTo matching - ending with @c nil.
    @see HCIsCollectionContaining
    @ingroup collection_matchers
 */
#ifdef HC_SHORTHAND
    #define hasItems HC_hasItems
#endif
