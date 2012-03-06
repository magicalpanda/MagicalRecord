//
//  OCHamcrest - HCIsAnything.h
//  Copyright 2012 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCBaseMatcher.h>


@interface HCIsAnything : HCBaseMatcher
{
    NSString *description;
}

+ (id)isAnything;
+ (id)isAnythingWithDescription:(NSString *)aDescription;

- (id)init;
- (id)initWithDescription:(NSString *)aDescription;

@end


OBJC_EXPORT id<HCMatcher> HC_anything();

/**
    Matches anything.
    
    This matcher always evaluates to @c YES. Specify this in composite matchers when the value of a 
    particular element is unimportant.
    
    (In the event of a name clash, don't \#define @c HC_SHORTHAND and use the synonym
    @c HC_anything instead.)

    @ingroup logical_matchers
 */
#ifdef HC_SHORTHAND
    #define anything() HC_anything()
#endif


OBJC_EXPORT id<HCMatcher> HC_anythingWithDescription(NSString *aDescription);

/**
    anythingWithDescription(description) -
    Matches anything.
    
    @param description  A string used to describe this matcher.
    
    This matcher always evaluates to @c YES. Specify this in collection matchers when the value of a 
    particular element in a collection is unimportant.
    
    (In the event of a name clash, don't \#define @c HC_SHORTHAND and use the synonym
    @c HC_anything instead.)

    @ingroup logical_matchers
 */
#ifdef HC_SHORTHAND
    #define anythingWithDescription HC_anythingWithDescription
#endif
