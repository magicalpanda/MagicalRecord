//
//  OCHamcrest - HCIsDictionaryContainingKey.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCBaseMatcher.h>


/**
    Matches dictionaries containing a key satisfying a given matcher.

    @b Factory: @ref hasKey
    @ingroup collection_matchers
 */
@interface HCIsDictionaryContainingKey : HCBaseMatcher
{
    id<HCMatcher> keyMatcher;
}

+ (id)isDictionaryContainingKey:(id<HCMatcher>)theKeyMatcher;
- (id)initWithKeyMatcher:(id<HCMatcher>)theKeyMatcher;

@end


#pragma mark -

/**
    Matches dictionaries containing a key satisfying a given matcher.

    @b Synonym: @ref hasKey
    @param matcherOrValue  A matcher, or a value for @ref equalTo matching.
    @see HCIsDictionaryContainingKey
    @ingroup collection_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_hasKey(id matcherOrValue);

/**
    hasKey(matcherOrValue) -
    Matches dictionaries containing a key satisfying a given matcher.

    Synonym for @ref HC_hasKey, available if @c HC_SHORTHAND is defined.
    @param matcherOrValue  A matcher, or a value for @ref equalTo matching.
    @see HCIsDictionaryContainingKey
    @ingroup collection_matchers
 */
#ifdef HC_SHORTHAND
    #define hasKey HC_hasKey
#endif
