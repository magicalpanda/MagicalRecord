//
//  OCHamcrest - HCStringContainsInOrder.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCBaseMatcher.h>


/**
    Tests if a string contains a given list of substrings, in order.

    @b Factory: @ref stringContainsInOrder
    @ingroup text_matchers
 */
@interface HCStringContainsInOrder : HCBaseMatcher
{
    NSArray *substrings;
}

+ (id)containsInOrder:(NSArray *)substringList;
- (id)initWithSubstrings:(NSArray *)substringList;

@end


#pragma mark -

/**
    Tests if a string contains a given list of substrings, in order.

    @b Synonym: @ref stringContainsInOrder
    @param substring1  Comma-separated list of strings, ending with @c nil.
    @see HCStringContainsInOrder
    @ingroup text_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_stringContainsInOrder(NSString *substring1, ...);

/**
    stringContainsInOrder(substring1, ...) -
    Tests if a string contains a given list of substrings, in order.

    Synonym for @ref HC_stringContainsInOrder, available if @c HC_SHORTHAND is defined.
    @param substring1  Comma-separated list of strings, ending with @c nil.
    @see HCStringContainsInOrder
    @ingroup text_matchers
 */
#ifdef HC_SHORTHAND
    #define stringContainsInOrder HC_stringContainsInOrder
#endif
