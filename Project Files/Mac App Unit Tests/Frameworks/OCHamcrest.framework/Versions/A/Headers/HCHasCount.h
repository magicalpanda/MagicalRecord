//
//  OCHamcrest - HCHasCount.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrest/HCBaseMatcher.h>


/**
    Matches collections for which @c -count satisfies a given matcher.

    @b Factory: @ref hasCount, @ref hasCountOf
    @ingroup collection_matchers
 */
@interface HCHasCount : HCBaseMatcher
{
    id<HCMatcher> countMatcher;
}

+ (id)hasCount:(id<HCMatcher>)matcher;
- (id)initWithCount:(id<HCMatcher>)matcher;

@end


#pragma mark -

/**
    Matches collections for which @c -count satisfies a given matcher.

    @b Synonym: @ref hasCount
    @see HCHasCount
    @ingroup collection_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_hasCount(id<HCMatcher> matcher);

/**
    hasCount(matcher) -
    Matches collections for which @c -count satisfies a given matcher.

    Synonym for @ref HC_hasCount, available if @c HC_SHORTHAND is defined.
    @see HCHasCount
    @ingroup collection_matchers
 */
#ifdef HC_SHORTHAND
    #define hasCount HC_hasCount
#endif


/**
    Matches collections for which @c -count equals a given count.
 
    @b Synonym: @ref hasCountOf
    @see HCHasCount
    @ingroup collection_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_hasCountOf(NSUInteger count);

/**
    hasCountOf(count) -
    Matches collections for which @c -count equals a given NSUInteger count.

    Synonym for @ref HC_hasCountOf, available if @c HC_SHORTHAND is defined.
    @see HCHasCount
    @ingroup collection_matchers
 */
#ifdef HC_SHORTHAND
    #define hasCountOf HC_hasCountOf
#endif
