//
//  OCHamcrest - HCIsSame.h
//  Copyright 2012 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCBaseMatcher.h>


@interface HCIsSame : HCBaseMatcher
{
    id object;
}

+ (id)isSameAs:(id)anObject;
- (id)initSameAs:(id)anObject;

@end


OBJC_EXPORT id<HCMatcher> HC_sameInstance(id object);

/**
    sameInstance(anObject) -
    Matches if evaluated object is the same instance as a given object.

    @param anObject  The object to compare against as the expected value.
    
    This matcher compares the address of the evaluated object to determine if it is the same object
    as @a anObject.
    
    (In the event of a name clash, don't \#define @c HC_SHORTHAND and use the synonym
    @c HC_sameInstance instead.)

    @ingroup object_matchers
 */
#ifdef HC_SHORTHAND
    #define sameInstance HC_sameInstance
#endif
