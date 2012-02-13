//
//  OCHamcrest - HCIs.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrest/HCBaseMatcher.h>


/**
    Decorates another HCMatcher, retaining the behavior but allowing tests to be slightly more
    expressive.

    For example:
@code
assertThat(cheese, equalTo(smelly))
@endcode
    vs.
@code
assertThat(cheese, is(equalTo(smelly)))
@endcode

    @b Factory: @ref is
    @ingroup core_matchers
 */
@interface HCIs : HCBaseMatcher
{
    id<HCMatcher> matcher;
}

+ (id)is:(id<HCMatcher>)aMatcher;
- (id)initWithMatcher:(id<HCMatcher>)aMatcher;

@end


/**
    Decorates another matcher, or provides a shortcut to the frequently used @ref is(equalTo(x)).

    If @a matcherOrValue is a matcher, its behavior is retained, but the test may be more expressive.

    If @a matcherOrValue is not a matcher, it is wrapped in an @ref equalTo matcher. This makes the
    following three statements the same:
@code
assertThat(cheese, equalTo(smelly))
assertThat(cheese, is(equalTo(smelly)))
assertThat(cheese, is(smelly))
@endcode
    Choose the style that makes your expression most readable. This will vary depending on context.

    @b Synonym: @ref is
    @see HCIs
    @ingroup core_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_is(id matcherOrValue);

/**
    is(matcherOrValue) -
    Decorates another matcher, or provides a shortcut to the frequently used @ref is(equalTo(x)).

    If @a matcherOrValue is a matcher, its behavior is retained, but the test may be more expressive.

    If @a matcherOrValue is not a matcher, it is wrapped in an @ref equalTo matcher. This makes the
    following three statements the same:
@code
assertThat(cheese, equalTo(smelly))
assertThat(cheese, is(equalTo(smelly)))
assertThat(cheese, is(smelly))
@endcode
    Choose the style that makes your expression most readable. This will vary depending on context.

    Synonym for @ref HC_is, available if @c HC_SHORTHAND is defined.
    @see HCIs
    @ingroup core_matchers
 */
#ifdef HC_SHORTHAND
    #define is HC_is
#endif
