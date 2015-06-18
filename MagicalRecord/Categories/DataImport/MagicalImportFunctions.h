//
//  MagicalImportFunctions.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>

__MR_nonnull NSDate *MR_adjustDateForDST(NSDate *__MR_nonnull date);
__MR_nonnull NSDate *MR_dateFromString(NSString *__MR_nonnull value, NSString *__MR_nonnull format);
__MR_nonnull NSDate *MR_dateFromNumber(NSNumber *__MR_nonnull value, BOOL milliseconds);
__MR_nonnull NSNumber *MR_numberFromString(NSString *__MR_nonnull value);
__MR_nonnull NSString *MR_attributeNameFromString(NSString *__MR_nonnull value);
__MR_nonnull NSString *MR_primaryKeyNameFromString(NSString *__MR_nonnull value);

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
__MR_nullable UIColor *MR_colorFromString(NSString *__MR_nonnull serializedColor);
#else
#import <AppKit/AppKit.h>
__MR_nullable NSColor *MR_colorFromString(NSString *__MR_nonnull serializedColor);
#endif

__MR_nullable NSInteger *MR_newColorComponentsFromString(NSString *__MR_nonnull serializedColor);
