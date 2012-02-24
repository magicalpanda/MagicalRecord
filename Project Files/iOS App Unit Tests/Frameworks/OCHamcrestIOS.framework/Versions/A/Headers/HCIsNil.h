//
//  OCHamcrest - HCIsNil.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCBaseMatcher.h>


/**
    Is the value @c nil?

    @b Factory: @ref nilValue, @ref notNilValue
    @ingroup core_matchers
*/
@interface HCIsNil : HCBaseMatcher

+ (id)isNil;

@end


#pragma mark -

/**
    Matches if the value is @c nil.
 
    @b Synonym: @ref nilValue
    @see HCIsNil
    @ingroup core_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_nilValue();

/**
    Matches if the value is @c nil.

    Synonym for @ref HC_nilValue, available if @c HC_SHORTHAND is defined.
    @see HCIsNil
    @ingroup core_matchers
 */
#ifdef HC_SHORTHAND
    #define nilValue()  HC_nilValue()
#endif


/**
    Matches if the value is not @c nil.
 
    @b Synonym: @ref notNilValue
    @see HCIsNil
    @see HCIsNot
    @ingroup core_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_notNilValue();

/**
    Matches if the value is not @c nil.

    Synonym for @ref HC_notNilValue, available if @c HC_SHORTHAND is defined.
    @see HCIsNil
    @see HCIsNot
    @ingroup core_matchers
 */
#ifdef HC_SHORTHAND
    #define notNilValue()  HC_notNilValue()
#endif
