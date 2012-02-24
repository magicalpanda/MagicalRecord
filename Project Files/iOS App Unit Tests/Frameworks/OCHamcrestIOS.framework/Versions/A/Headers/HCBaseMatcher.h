//
//  OCHamcrest - HCBaseMatcher.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <Foundation/Foundation.h>
#import <OCHamcrestIOS/HCMatcher.h>

#import <objc/objc-api.h>   // Convenience header, to provide OBJC_EXPORT


/**
    Base class for all HCMatcher implementations.

    Most implementations can just implement @c -matches: and let
    <tt>-matches:describingMismatchTo:</tt> call it. But if it makes more sense to generate the
    mismatch description during the matching, override <tt>-matches:describingMismatchTo:</tt> and
    have @c -matches: call it with a @c nil description.

    @ingroup core
 */
@interface HCBaseMatcher : NSObject <HCMatcher>
@end
