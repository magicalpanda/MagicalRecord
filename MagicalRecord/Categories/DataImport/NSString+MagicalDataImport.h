//
//  NSString+MagicalRecord_MagicalDataImport.h
//  Magical Record
//
//  Created by Saul Mora on 12/10/11.
//  Copyright (c) 2011 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#if __has_include(<MagicalRecord/MagicalRecord.h>)
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>
#else
#import "MagicalRecordXcode7CompatibilityMacros.h"
#endif

@interface NSString (MagicalRecord_DataImport)

- (MR_nonnull NSString *) MR_capitalizedFirstCharacterString;

@end
