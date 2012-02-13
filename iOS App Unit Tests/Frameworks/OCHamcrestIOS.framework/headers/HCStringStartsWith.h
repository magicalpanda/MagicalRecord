//
//  OCHamcrest - HCStringStartsWith.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCSubstringMatcher.h>


/**
    Tests if the argument is a string that starts with a substring.

    @b Factory: @ref startsWith
    @ingroup text_matchers
 */
@interface HCStringStartsWith : HCSubstringMatcher

+ (id)stringStartsWith:(NSString *)aSubstring;

@end


#pragma mark -

/**
    Tests if the argument is a string that starts with a substring.
    
    @b Synonym: @ref startsWith
    @see HCStringStartsWith
    @ingroup text_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_startsWith(NSString *aSubstring);

/**
    startsWith(substring) -
    Tests if the argument is a string that starts with a substring.

    Synonym for @ref HC_startsWith, available if @c HC_SHORTHAND is defined.
    @see HCStringStartsWith
    @ingroup text_matchers
 */
#ifdef HC_SHORTHAND
    #define startsWith HC_startsWith
#endif
