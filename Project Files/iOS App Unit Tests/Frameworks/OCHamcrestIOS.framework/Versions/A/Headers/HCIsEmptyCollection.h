//
//  OCHamcrest - HCIsEmptyCollection.h
//  Copyright 2012 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCHasCount.h>


@interface HCIsEmptyCollection : HCHasCount

+ (id)isEmptyCollection;
- (id)init;

@end


OBJC_EXPORT id<HCMatcher> HC_empty();

/**
    Matches empty collection.

    This matcher invokes @c -count on the evaluated object to determine if the number of elements it
    contains is zero.
    
    (In the event of a name clash, don't \#define @c HC_SHORTHAND and use the synonym
    @c HC_empty instead.)

    @ingroup collection_matchers
 */
#ifdef HC_SHORTHAND
    #define empty() HC_empty()
#endif
