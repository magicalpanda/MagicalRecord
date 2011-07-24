//
//  OCHamcrest - HCAllOf.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCBaseMatcher.h>


/**
    Calculates the logical conjunction of multiple matchers.

    Evaluation is shortcut, so subsequent matchers are not called if an earlier matcher returns
    @c NO.

    @b Factory: @ref allOf
    @ingroup core_matchers
 */
@interface HCAllOf : HCBaseMatcher
{
    NSArray *matchers;
}

+ (id)allOf:(NSArray *)theMatchers;
- (id)initWithMatchers:(NSArray *)theMatchers;

@end


#pragma mark -

/**
    Evaluates to @c YES only if @em all of the given matchers evaluate to @c YES.
 
    @b Synonym: @ref allOf
    @param matcherOrValue1  Comma-separated list of matchers - or values for @ref equalTo matching - ending with @c nil.
    @see HCAllOf
    @ingroup core_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_allOf(id matcherOrValue1, ...);

/**
    allOf(matcherOrValue1, ...) -
    Evaluates to @c YES only if @em all of the given matchers evaluate to @c YES.

    Synonym for @ref HC_allOf, available if @c HC_SHORTHAND is defined.
    @param matcherOrValue1  Comma-separated list of matchers - or values for @ref equalTo matching - ending with @c nil.
    @see HCAllOf
    @ingroup core_matchers
 */
#ifdef HC_SHORTHAND
    #define allOf HC_allOf
#endif
