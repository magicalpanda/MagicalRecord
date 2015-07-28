//
//  NSAttributeDescription+MagicalDataImport.h
//  Magical Record
//
//  Created by Saul Mora on 9/4/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MagicalRecordXcode7CompatibilityMacros.h"

@interface NSAttributeDescription (MagicalRecord_DataImport)

- (MR_nullable NSString *) MR_primaryKey;
- (MR_nullable id) MR_valueForKeyPath:(MR_nonnull NSString *)keyPath fromObjectData:(MR_nonnull id)objectData;

@end
