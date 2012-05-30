//
//  OCHamcrest - HCIsNil.h
//  Copyright 2012 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCBaseMatcher.h>


@interface HCIsNil : HCBaseMatcher

+ (id)isNil;

@end


OBJC_EXPORT id<HCMatcher> HC_nilValue();

/**
    Matches if object is @c nil.

    (In the event of a name clash, don't \#define @c HC_SHORTHAND and use the synonym
    @c HC_nilValue instead.)

    @ingroup object_matchers
 */
#ifdef HC_SHORTHAND
    #define nilValue() HC_nilValue()
#endif


OBJC_EXPORT id<HCMatcher> HC_notNilValue();

/**
    Matches if object is not @c nil.
    
    (In the event of a name clash, don't \#define @c HC_SHORTHAND and use the synonym
    @c HC_notNilValue instead.)

    @ingroup object_matchers
 */
#ifdef HC_SHORTHAND
    #define notNilValue() HC_notNilValue()
#endif
