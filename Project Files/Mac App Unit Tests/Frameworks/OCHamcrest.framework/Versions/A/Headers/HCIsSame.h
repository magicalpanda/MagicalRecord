//
//  OCHamcrest - HCIsSame.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrest/HCBaseMatcher.h>


/**
    Is the item the same object as another?

    @b Factory: @ref sameInstance
    @ingroup core_matchers
*/
@interface HCIsSame : HCBaseMatcher
{
    id object;
}

+ (id)isSameAs:(id)anObject;
- (id)initSameAs:(id)anObject;

@end


#pragma mark -

/**
    Evaluates to @c YES only when the argument is this same object.
 
    @b Synonym: @ref sameInstance
    @see HCIsSame
    @ingroup core_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_sameInstance(id object);

/**
    sameInstance(object) -
    Evaluates to @c YES only when the argument is this same object.

    Synonym for @ref HC_sameInstance, available if @c HC_SHORTHAND is defined.
    @see HCIsSame
    @ingroup core_matchers
 */
#ifdef HC_SHORTHAND
    #define sameInstance HC_sameInstance
#endif
