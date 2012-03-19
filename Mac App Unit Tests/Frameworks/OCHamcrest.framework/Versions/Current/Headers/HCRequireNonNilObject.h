//
//  OCHamcrest - HCRequireNonNilObject.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <Foundation/Foundation.h>
#import <objc/objc-api.h>


/**
    Throws an NSException if @a obj is @c nil.
    @ingroup helpers
*/
OBJC_EXPORT void HCRequireNonNilObject(id obj);
