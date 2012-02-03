//
//  OCHamcrest - HCSubstringMatcher.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCBaseMatcher.h>


@interface HCSubstringMatcher : HCBaseMatcher
{
    NSString *substring;
}

- (id)initWithSubstring:(NSString *)aSubstring;

@end
