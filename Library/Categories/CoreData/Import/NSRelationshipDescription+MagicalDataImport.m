//
//  NSRelationshipDescription+MagicalDataImport.m
//  Magical Record
//
//  Created by Saul Mora on 9/4/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSRelationshipDescription+MagicalDataImport.h"
#import "NSManagedObject+MagicalDataImport.h"
#import "MagicalImportFunctions.h"
#import "MagicalRecord.h"

@implementation NSRelationshipDescription (MagicalRecordDataImport)

- (NSString *) MR_primaryKey;
{
    NSString *primaryKeyName = [[self userInfo] valueForKey:kMagicalRecordImportDistinctAttributeKey] ?: 
    MRPrimaryKeyNameFromString([[self destinationEntity] name]);
    
    return primaryKeyName;
}

@end
