//
//  OCHamcrest - HCIsInstanceOf.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCBaseMatcher.h>


/**
    Tests whether the value is an instance of a class (including subclasses).

    @b Factory: @ref instanceOf
    @ingroup core_matchers
 */
@interface HCIsInstanceOf : HCBaseMatcher
{
    Class theClass;
}

+ (id)isInstanceOf:(Class)type;
- (id)initWithType:(Class)type;

@end


#pragma mark -

/**
    Is the value an instance of a particular type?
 
    @b Synonym: @ref instanceOf
    @see HCIsInstanceOf
    @ingroup core_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_instanceOf(Class type);

/**
    instanceOf(type) -
    Is the value an instance of a particular type?

    Synonym for @ref HC_instanceOf, available if @c HC_SHORTHAND is defined.
    @see HCIsInstanceOf
    @ingroup core_matchers
 */
#ifdef HC_SHORTHAND
    #define instanceOf HC_instanceOf
#endif
