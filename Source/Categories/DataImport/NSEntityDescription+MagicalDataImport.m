//
//  NSEntityDescription+MagicalDataImport.m
//  Magical Record
//
//  Created by Saul Mora on 9/5/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "CoreData+MagicalRecord.h"

NSString * const kMagicalRecordImportPrimaryAttributeKey = @"primaryAttributeKey";

@implementation NSEntityDescription (MagicalRecord_DataImport)

- (NSAttributeDescription *) MR_primaryKeyAttribute;
{
    NSString *lookupKey = [[self userInfo] valueForKey:kMagicalRecordImportPrimaryAttributeKey] ?: primaryKeyNameFromString([self name]);
    NSAttributeDescription *primaryAttribute = [[self attributesByName] valueForKey:lookupKey];
    
    if (primaryAttribute == nil)
    {
        NSAssert3(primaryAttribute != nil, @"Unable to determine primary attribute for %@. Specify either an attribute named %@ or the primary key in userInfo named '%@'", [self name], primaryKeyNameFromString([self name]), kMagicalRecordImportPrimaryAttributeKey);
    }

    return primaryAttribute;
}

@end
