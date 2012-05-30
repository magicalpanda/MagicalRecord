//
//  MagicalImportFunctions.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


NSDate * adjustDateForDST(NSDate *date);
NSDate * dateFromString(NSString *value, NSString *format);
NSString * attributeNameFromString(NSString *value);
NSString * primaryKeyNameFromString(NSString *value);

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
UIColor * UIColorFromString(NSString *serializedColor);

#else
#import <AppKit/AppKit.h>
NSColor * NSColorFromString(NSString *serializedColor);

#endif
extern id (*colorFromString)(NSString *);

