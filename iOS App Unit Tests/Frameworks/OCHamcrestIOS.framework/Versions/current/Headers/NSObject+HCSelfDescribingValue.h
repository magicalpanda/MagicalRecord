//
//  OCHamcrest - NSObject+HCSelfDescribingValue.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <Foundation/Foundation.h>

@protocol HCDescription;

/**
    This category allows any object to satisfy the HCSelfDescribing protocol.

    @b Deprecated: No longer needed now that @ref appendDescriptionOf: handles all types of objects.

    @ingroup core
 */
@interface NSObject (HCSelfDescribingValue)

/**
    Generates a description of the object.

    @param description  The description to be appended to.
 */
- (void)describeTo:(id<HCDescription>)description      __attribute__((deprecated));

@end
