//
//  NSString+MagicalRecord.h
//  wetter-com-iphone
//
//  Created by Manuel "StuFF mc" Carrasco Molina on 26.01.13.
//  Copyright (c) 2013 grandcentrix GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MagicalRecord)

#define MR_SORT_KEY_SEPARATOR @","
@property (strong, nonatomic, readonly) NSArray *MR_sortKeys;

@end
