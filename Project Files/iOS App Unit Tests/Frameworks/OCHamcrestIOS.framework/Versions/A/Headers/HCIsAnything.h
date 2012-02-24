//
//  OCHamcrest - HCIsAnything.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCBaseMatcher.h>


/**
    A matcher that always returns @c YES.

    @b Factory: @ref anything
    @ingroup core_matchers
 */
@interface HCIsAnything : HCBaseMatcher
{
    NSString *description;
}

+ (id)isAnything;
+ (id)isAnythingWithDescription:(NSString *)aDescription;

- (id)init;
- (id)initWithDescription:(NSString *)aDescription;

@end


#pragma mark -

/**
    This matcher always evaluates to @c YES.
 
    @b Synonym: @ref anything
    @see HCIsAnything
    @ingroup core_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_anything();

/**
    This matcher always evaluates to @c YES.

    Synonym for @ref HC_anything, available if @c HC_SHORTHAND is defined.
    @see HCIsAnything
    @ingroup core_matchers
 */
#ifdef HC_SHORTHAND
    #define anything() HC_anything()
#endif


/**
    This matcher always evaluates to @c YES.

    @b Synonym: @ref anythingWithDescription
    @param aDescription  A meaningful string used when describing itself.
    @see HCIsAnything
    @ingroup core_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_anythingWithDescription(NSString *aDescription);

/**
    anythingWithDescription(description) -
    This matcher always evaluates to @c YES.

    Synonym for @ref HC_anythingWithDescription, available if @c HC_SHORTHAND is defined.
    @param aDescription  A meaningful string used when describing itself.
    @see HCIsAnything
    @ingroup core_matchers
 */
#ifdef HC_SHORTHAND
    #define anythingWithDescription HC_anythingWithDescription
#endif
