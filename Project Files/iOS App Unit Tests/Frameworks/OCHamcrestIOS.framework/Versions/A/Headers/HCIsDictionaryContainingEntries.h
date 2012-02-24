//
//  OCHamcrest - HCIsDictionaryContainingEntries.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCBaseMatcher.h>


/**
    Matches dictionaries containing key-value pairs satisfying given lists of keys and value
    matchers.
 
    @b Factory: @ref hasEntries
    @ingroup collection_matchers
 */
@interface HCIsDictionaryContainingEntries : HCBaseMatcher
{
    NSArray *keys;
    NSArray *valueMatchers;
}

+ (id)isDictionaryContainingKeys:(NSArray *)theKeys
                   valueMatchers:(NSArray *)theValueMatchers;

- (id)initWithKeys:(NSArray *)theKeys
     valueMatchers:(NSArray *)theValueMatchers;

@end


#pragma mark -

/**
    Matches dictionaries containing key-value pairs satisfying a given lists of alternating keys and
    value matchers.
 
    @b Synonym: @ref hasEntries
    @param keysAndValueMatchers  Alternating pairs of keys and value matchers - or straight values for @ref equalTo matching.
    @see HCIsDictionaryContainingEntries
    @ingroup collection_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_hasEntries(id keysAndValueMatchers, ...);

/**
    HC_hasEntries(id keysAndValueMatchers, ...) -
    Matches dictionaries containing key-value pairs satisfying a given lists of alternating keys and
    value matchers.

    Synonym for @ref HC_hasEntries, available if @c HC_SHORTHAND is defined.
    @param keysAndValueMatchers  Alternating pairs of keys and value matchers - or straight values for @ref equalTo matching.
    @see HCIsDictionaryContainingEntries
    @ingroup collection_matchers
 */
#ifdef HC_SHORTHAND
    #define hasEntries HC_hasEntries
#endif
