//
//  OCHamcrest - HCStringEndsWith.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCSubstringMatcher.h>


/**
    Tests if the argument is a string that ends with a substring.

    @b Factory: @ref endsWith
    @ingroup text_matchers
 */
@interface HCStringEndsWith : HCSubstringMatcher

+ (id)stringEndsWith:(NSString *)aSubstring;

@end


#pragma mark -

/**
    Tests if the argument is a string that ends with a substring.
    
    @b Synonym: @ref endsWith
    @see HCStringEndsWith
    @ingroup text_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_endsWith(NSString *aSubstring);

/**
    endsWith(substring) -
    Tests if the argument is a string that ends with a substring.

    Synonym for @ref HC_endsWith, available if @c HC_SHORTHAND is defined.
    @see HCStringEndsWith
    @ingroup text_matchers
 */
#ifdef HC_SHORTHAND
    #define endsWith HC_endsWith
#endif
