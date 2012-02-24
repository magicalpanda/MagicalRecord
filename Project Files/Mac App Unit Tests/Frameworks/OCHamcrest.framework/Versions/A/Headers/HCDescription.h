//
//  OCHamcrest - HCDescription.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <Foundation/Foundation.h>


/**
    A description of an HCMatcher.
    
    An HCMatcher will describe itself to a description which can later be used for reporting.

    @ingroup core
 */
@protocol HCDescription

/**
    Appends some plain text to the description.
    
    @return @c self, for chaining.
 */
- (id<HCDescription>)appendText:(NSString *)text;

/**
    Appends description of given value to @c self.
 
    If the value implements the @ref HCSelfDescribing protocol, then it will be used.
    
    @return @c self, for chaining.
 */
- (id<HCDescription>)appendDescriptionOf:(id)value;

/**
    Appends an arbitary value to the description.
    
    @b Deprecated: Call @ref appendDescriptionOf: instead.

    @return @c self, for chaining.
 */
- (id<HCDescription>)appendValue:(id)value     __attribute__((deprecated));

/** 
    Appends a list of objects to the description.
    
    @return @c self, for chaining.
 */
- (id<HCDescription>)appendList:(NSArray *)values
                           start:(NSString *)start
                       separator:(NSString *)separator
                             end:(NSString *)end;

@end
