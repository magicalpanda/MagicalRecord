//
//  OCHamcrest - HCIsIn.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCBaseMatcher.h>


/**
    Is the object present in the given collection?

    @b Factory: @ref isIn
    @ingroup collection_matchers
 */
@interface HCIsIn : HCBaseMatcher
{
    id collection;
}

+ (id)isInCollection:(id)aCollection;
- (id)initWithCollection:(id)aCollection;

@end


#pragma mark -

/**
    Is the object present in the given collection?
 
    @b Synonym: @ref isIn
    @see HCIsIn
    @ingroup collection_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_isIn(id aCollection);

/**
    isIn(collection) -
    Is the object present in the given collection?

    Synonym for @ref HC_isIn, available if @c HC_SHORTHAND is defined.
    @see HCIsIn
    @ingroup collection_matchers
 */
#ifdef HC_SHORTHAND
    #define isIn  HC_isIn
#endif
