//
//  NSRelationshipDescription+MagicalDataImport.h
//  Magical Record
//
//  Created by Saul Mora on 9/4/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MagicalRecordXcode7CompatibilityMacros.h"

@interface NSRelationshipDescription (MagicalRecord_DataImport)

- (MR_nonnull NSString *) MR_primaryKey;

@end
