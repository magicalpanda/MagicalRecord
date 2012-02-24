//
//  OCHamcrest - HCStringContains.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrest/HCSubstringMatcher.h>


/**
    Tests if the argument is a string that contains a substring.

    @b Factory: @ref containsString
    @ingroup text_matchers
 */
@interface HCStringContains : HCSubstringMatcher

+ (id)stringContains:(NSString *)aSubstring;

@end


#pragma mark -

/**
    Tests if the argument is a string that contains a substring.

    @b Synonym: @ref containsString
    @see HCStringContains
    @ingroup text_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_containsString(NSString *aSubstring);

/**
    containsString(substring) -
    Tests if the argument is a string that contains a substring.

    Synonym for @ref HC_containsString, available if @c HC_SHORTHAND is defined.
    @see HCStringContains
    @ingroup text_matchers
 */
#ifdef HC_SHORTHAND
    #define containsString HC_containsString
#endif
