//
//  OCHamcrest - HCBaseDescription.h
//  Copyright 2012 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <Foundation/Foundation.h>
#import <OCHamcrestIOS/HCDescription.h>


/**
    Base class for all HCDescription implementations.
 
    @ingroup core
 */
@interface HCBaseDescription : NSObject <HCDescription>
@end


/**
    Methods that must be provided by subclasses of HCBaseDescription.
 */
@interface HCBaseDescription (SubclassMustImplement)

/**
    Append the string @a str to the description.
 */
- (void)append:(NSString *)str;

@end
