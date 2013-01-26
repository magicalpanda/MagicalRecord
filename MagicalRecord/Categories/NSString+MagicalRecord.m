//
//  NSString+MagicalRecord.m
//  wetter-com-iphone
//
//  Created by Manuel "StuFF mc" Carrasco Molina on 26.01.13.
//  Copyright (c) 2013 grandcentrix GmbH. All rights reserved.
//

#import "NSString+MagicalRecord.h"

@implementation NSString (MagicalRecord)

- (NSArray*)MR_sortKeys
{
    return [self componentsSeparatedByString:MR_SORT_KEY_SEPARATOR];
}

@end
