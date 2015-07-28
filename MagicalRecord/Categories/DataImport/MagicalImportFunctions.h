//
//  MagicalImportFunctions.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MagicalRecordXcode7CompatibilityMacros.h"

NSDate *  __MR_nonnull MR_adjustDateForDST(NSDate *__MR_nonnull date);
NSDate * __MR_nonnull MR_dateFromString(NSString *__MR_nonnull value, NSString *__MR_nonnull format);
NSDate * __MR_nonnull MR_dateFromNumber(NSNumber *__MR_nonnull value, BOOL milliseconds);
NSNumber * __MR_nonnull MR_numberFromString(NSString *__MR_nonnull value);
NSString * __MR_nonnull MR_attributeNameFromString(NSString *__MR_nonnull value);
NSString * __MR_nonnull MR_primaryKeyNameFromString(NSString *__MR_nonnull value);

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
UIColor * __MR_nullable MR_colorFromString(NSString *__MR_nonnull serializedColor);
#else
#import <AppKit/AppKit.h>
NSColor * __MR_nullable MR_colorFromString(NSString *__MR_nonnull serializedColor);
#endif

NSInteger * __MR_nullable MR_newColorComponentsFromString(NSString *__MR_nonnull serializedColor);
