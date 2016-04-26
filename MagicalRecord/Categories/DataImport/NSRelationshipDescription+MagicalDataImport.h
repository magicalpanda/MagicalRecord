//
//  NSRelationshipDescription+MagicalDataImport.h
//  Magical Record
//
//  Created by Saul Mora on 9/4/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

#if __has_include(<MagicalRecord/MagicalRecord.h>)
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>
#else
#import "MagicalRecordXcode7CompatibilityMacros.h"
#endif

@interface NSRelationshipDescription (MagicalRecord_DataImport)

- (MR_nonnull NSString *) MR_primaryKey;

@end
