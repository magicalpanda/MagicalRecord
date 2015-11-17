//
//  NSString+MagicalRecord_MagicalDataImport.m
//  Magical Record
//
//  Created by Saul Mora on 12/10/11.
//  Copyright (c) 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSString+MagicalDataImport.h"
#import "NSManagedObject+MagicalRecord.h"
#import "MagicalImportFunctions.h"

@implementation NSString (MagicalRecordDataImport)

- (NSString *)MR_capitalizedFirstCharacterString
{
    if ([self length] > 0)
    {
        NSString *firstChar = [[self substringToIndex:1] capitalizedString];
        return [firstChar stringByAppendingString:[self substringFromIndex:1]];
    }
    return self;
}

- (id)MR_relatedValueForRelationship:(__unused NSRelationshipDescription *)relationshipInfo
{
    return self;
}

- (NSString *)MR_lookupKeyForProperty:(__unused NSPropertyDescription *)propertyDescription
{
    return nil;
}

- (NSDate *)MR_dateWithFormat:(NSString *)dateFormat
{
    return MRDateFromString(self, dateFormat ?: kMagicalRecordImportDefaultDateFormatString);
}

@end
