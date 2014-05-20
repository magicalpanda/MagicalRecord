//
//  NSNumber+MagicalDataImport.m
//  Magical Record
//
//  Created by Saul Mora on 9/4/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSNumber+MagicalDataImport.h"
#import "NSManagedObject+MagicalRecord.h"
#import "MagicalImportFunctions.h"

@implementation NSNumber (MagicalRecordDataImport)

- (id) MR_relatedValueForRelationship:(NSRelationshipDescription *)relationshipInfo
{
    return self;
}

- (NSString *) MR_lookupKeyForProperty:(NSPropertyDescription *)propertyDescription
{
    return nil;
}

- (NSDate *) MR_dateWithFormat:(NSString *)dateFormat;
{
    return MRDateFromNumber(self, [dateFormat isEqualToString:kMagicalRecordImportUnixTimeString]);
}

@end
