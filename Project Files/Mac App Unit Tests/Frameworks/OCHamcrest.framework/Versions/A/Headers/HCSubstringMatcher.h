//
//  OCHamcrest - HCSubstringMatcher.h
//  Copyright 2012 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrest/HCBaseMatcher.h>


@interface HCSubstringMatcher : HCBaseMatcher
{
    NSString *substring;
}

- (id)initWithSubstring:(NSString *)aString;

@end
