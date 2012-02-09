//
//  OCHamcrest - HCAssertThat.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <objc/objc-api.h>

@protocol HCMatcher;


/**
    Asserts that actual value satisfies matcher.

    If the matcher is not satisfied, an exception describing the mismatch is thrown. If you have
    linked against a OCUnit-compatible testing framework, this exception is a test failure.
    
    @param testCase A test case object that answers to @c -failWithException:

    @ingroup integration
 */
OBJC_EXPORT void HC_assertThatWithLocation(id testCase, id actual, id<HCMatcher> matcher,
                                           const char *fileName, int lineNumber);

/**
    Asserts that actual value satisfies matcher.

    If the matcher is not satisfied, an exception describing the mismatch is thrown.
 
    @b Synonym: @ref assertThat
    @see HC_assertThatWithLocation
    @ingroup integration
 */
#define HC_assertThat(actual, matcher)  \
    HC_assertThatWithLocation(self, actual, matcher, __FILE__, __LINE__)

/**
    assertThat(actual, matcher) -
    Asserts that actual value satisfies matcher.
 
    If the matcher is not satisfied, an exception describing the mismatch is thrown.
 
    Synonym for @ref HC_assertThat, available if @c HC_SHORTHAND is defined.
    @see HC_assertThatWithLocation
    @ingroup integration
 */
#ifdef HC_SHORTHAND
    #define assertThat HC_assertThat
#endif
