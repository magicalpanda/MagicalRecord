//
//  OCHamcrest - HCIsCloseTo.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCBaseMatcher.h>


/**
    Is the argument a number close to a value, within some delta?

    @b Factory: @ref closeTo
    @ingroup number_matchers
 */
@interface HCIsCloseTo : HCBaseMatcher
{
    double value;
    double delta;
}

+ (id)isCloseTo:(double)aValue within:(double)aDelta;
- (id)initWithValue:(double)aValue delta:(double)aDelta;

@end


#pragma mark -

/**
    Is the argument a number close to a value, within some delta?
 
    @b Synonym: @ref closeTo
    @see HCIsCloseTo
    @ingroup number_matchers
*/
OBJC_EXPORT id<HCMatcher> HC_closeTo(double aValue, double aDelta);

/**
    closeTo(value, delta) -
    Is the argument a number close to a value, within some delta?

    Synonym for @ref HC_closeTo, available if @c HC_SHORTHAND is defined.
    @see HCIsCloseTo
    @ingroup number_matchers
 */
#ifdef HC_SHORTHAND
    #define closeTo HC_closeTo
#endif
