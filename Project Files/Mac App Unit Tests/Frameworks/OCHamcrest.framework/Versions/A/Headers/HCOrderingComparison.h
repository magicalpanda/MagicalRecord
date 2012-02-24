//
//  OCHamcrest - HCOrderingComparison.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrest/HCBaseMatcher.h>


@interface HCOrderingComparison : HCBaseMatcher
{
    id expected;
    NSComparisonResult minCompare;
    NSComparisonResult maxCompare;
    NSString *comparisonDescription;
}

+ (id)compare:(id)expectedValue
   minCompare:(NSComparisonResult)min
   maxCompare:(NSComparisonResult)max
   comparisonDescription:(NSString *)comparisonDescription;

- (id)initComparing:(id)expectedValue
         minCompare:(NSComparisonResult)min
         maxCompare:(NSComparisonResult)max
         comparisonDescription:(NSString *)comparisonDescription;

@end


#pragma mark -

/**
    Is value > expected?
 
    @b Synonym: @ref greaterThan
    @ingroup number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_greaterThan(id expected);

/**
    greaterThan(expected) -
    Is value > expected?

    Synonym for @ref HC_greaterThan, available if @c HC_SHORTHAND is defined.
    @ingroup number_matchers
 */
#ifdef HC_SHORTHAND
    #define greaterThan HC_greaterThan
#endif


/**
    Is value >= expected?
 
    @b Synonym: @ref greaterThanOrEqualTo
    @ingroup number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_greaterThanOrEqualTo(id expected);

/**
    greaterThanOrEqualTo(expected) -
    Is value >= expected?

    Synonym for @ref HC_greaterThan, available if @c HC_SHORTHAND is defined.
    @ingroup number_matchers
 */
#ifdef HC_SHORTHAND
    #define greaterThanOrEqualTo HC_greaterThanOrEqualTo
#endif


/**
    Is value < expected?
 
    @b Synonym: @ref lessThan
    @ingroup number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_lessThan(id expected);

/**
    lessThan(expected) -
    Is value < expected?

    Synonym for @ref HC_greaterThan, available if @c HC_SHORTHAND is defined.
    @ingroup number_matchers
 */
#ifdef HC_SHORTHAND
    #define lessThan HC_lessThan
#endif


/**
    Is value <= expected?
 
    @b Synonym: @ref lessThanOrEqualTo
    @ingroup number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_lessThanOrEqualTo(id expected);

/**
    lessThanOrEqualTo(expected) -
    Is value <= expected?

    Synonym for @ref HC_lessThanOrEqualTo, available if @c HC_SHORTHAND is defined.
    @ingroup number_matchers
 */
#ifdef HC_SHORTHAND
    #define lessThanOrEqualTo HC_lessThanOrEqualTo
#endif
