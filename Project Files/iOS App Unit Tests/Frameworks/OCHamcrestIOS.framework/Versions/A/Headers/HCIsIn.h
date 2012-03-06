//
//  OCHamcrest - HCIsIn.h
//  Copyright 2012 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCBaseMatcher.h>


@interface HCIsIn : HCBaseMatcher
{
    id collection;
}

+ (id)isInCollection:(id)aCollection;
- (id)initWithCollection:(id)aCollection;

@end


OBJC_EXPORT id<HCMatcher> HC_isIn(id aCollection);

/**
    isIn(aCollection) -
    Matches if evaluated object is present in a given collection.

    @param aCollection  The collection to search.
    
    This matcher invokes @c -containsObject: on @a aCollection to determine if the evaluated object
    is an element of the collection.
    
    (In the event of a name clash, don't \#define @c HC_SHORTHAND and use the synonym
    @c HC_isIn instead.)

    @ingroup collection_matchers
 */
#ifdef HC_SHORTHAND
    #define isIn HC_isIn
#endif
