//
//  NSAttributeDescription+MagicalDataImport.m
//  Magical Record
//
//  Created by Saul Mora on 9/4/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSAttributeDescription+MagicalDataImport.h"
#import "NSManagedObject+MagicalDataImport.h"
#import "NSString+MagicalDataImport.h"
#import "NSNumber+MagicalDataImport.h"
#import "MagicalImportFunctions.h"

@implementation NSAttributeDescription (MagicalRecordDataImport)

- (NSString *)MR_primaryKey
{
    return nil;
}

- (id)MR_colorValueForKeyPath:(NSString *)keyPath fromObjectData:(id)objectData
{
    id value = [objectData valueForKeyPath:keyPath];
    return MRColorFromString(value);
}

- (NSDate *)MR_dateValueForKeyPath:(NSString *)keyPath fromObjectData:(id)objectData
{
    id value = [objectData valueForKeyPath:keyPath];
    if (![value isKindOfClass:[NSDate class]])
    {
        NSDate *convertedValue = nil;
        NSString *dateFormat;
        NSUInteger index = 0;
        do
        {
            NSString *dateFormatKey = kMagicalRecordImportCustomDateFormatKey;
            if (index)
            {
                dateFormatKey = [dateFormatKey stringByAppendingFormat:@".%tu", index];
            }
            index++;
            dateFormat = [[self userInfo] objectForKey:dateFormatKey];

            convertedValue = [value MR_dateWithFormat:dateFormat];

        } while (!convertedValue && dateFormat);
        if(convertedValue!=nil){
            value = convertedValue;
        }
    }
    return value;
}

- (NSNumber *)MR_numberValueForKeyPath:(NSString *)keyPath fromObjectData:(id)objectData
{
    id value = [objectData valueForKeyPath:keyPath];
    if (![value isKindOfClass:[NSNumber class]])
    {
        value = MRNumberFromString([value description]);
    }
    return value;
}

- (NSNumber *)MR_booleanValueForKeyPath:(NSString *)keyPath fromObjectData:(id)objectData
{
    id value = [objectData valueForKeyPath:keyPath];
    return @([value boolValue]);
}

- (NSString *)MR_stringValueForKeyPath:(NSString *)keyPath fromObjectData:(id)objectData
{
    id value = [objectData valueForKeyPath:keyPath];
    return [value description];
}

- (BOOL)MR_isNumericAttributeType
{
    NSAttributeType attributeType = [self attributeType];
    return attributeType == NSInteger16AttributeType ||
           attributeType == NSInteger32AttributeType ||
           attributeType == NSInteger64AttributeType ||
           attributeType == NSDecimalAttributeType ||
           attributeType == NSDoubleAttributeType ||
           attributeType == NSFloatAttributeType;
}

- (BOOL)MR_isStringAttributeType
{
    NSAttributeType attributeType = [self attributeType];
    return attributeType == NSStringAttributeType;
}

- (BOOL)MR_isDateAttributeType
{
    NSAttributeType attributeType = [self attributeType];
    return attributeType == NSDateAttributeType;
}

- (BOOL)MR_isBooleanAttributeType
{
    NSAttributeType attributeType = [self attributeType];
    return attributeType == NSBooleanAttributeType;
}

- (BOOL)MR_isColorAttributeType
{
    BOOL isColorAttributeType = NO;
    NSString *desiredAttributeType = [[self userInfo] objectForKey:kMagicalRecordImportAttributeValueClassNameKey];
    if (desiredAttributeType)
    {
        isColorAttributeType = [desiredAttributeType hasSuffix:@"Color"];
    }
    return isColorAttributeType;
}

- (id)MR_valueForKeyPath:(NSString *)keyPath fromObjectData:(id)objectData
{
    id value = [objectData valueForKeyPath:keyPath];
    if ([value isEqual:[NSNull null]])
    {
        value = nil;
    }
    else if ([self MR_isColorAttributeType])
    {
        value = [self MR_colorValueForKeyPath:keyPath fromObjectData:objectData];
    }
    else if ([self MR_isDateAttributeType])
    {
        value = [self MR_dateValueForKeyPath:keyPath fromObjectData:objectData];
    }
    else if ([self MR_isNumericAttributeType])
    {
        value = [self MR_numberValueForKeyPath:keyPath fromObjectData:objectData];
    }
    else if ([self MR_isStringAttributeType])
    {
        value = [self MR_stringValueForKeyPath:keyPath fromObjectData:objectData];
    }
    else if ([self MR_isBooleanAttributeType])
    {
        value = [self MR_booleanValueForKeyPath:keyPath fromObjectData:objectData];
    }

    return value;
}

- (BOOL)MR_shouldUseDefaultValueIfNoValuePresent
{
    return [[[self userInfo] objectForKey:kMagicalRecordImportAttributeUseDefaultValueWhenNotPresent] boolValue];
}

@end
