//
//  NSAttributeDescription+MagicalDataImport.m
//  Magical Record
//
//  Created by Saul Mora on 9/4/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSAttributeDescription+MagicalDataImport.h"
#import "NSManagedObject+MagicalDataImport.h"
#import "MagicalImportFunctions.h"

@implementation NSAttributeDescription (MagicalRecord_DataImport)

- (NSString *) MR_primaryKey;
{
    return nil;
}

- (id) MR_valueForKeyPath:(NSString *)keyPath fromObjectData:(id)objectData;
{
    id value = [objectData valueForKeyPath:keyPath];
    
    NSAttributeType attributeType = [self attributeType];
    NSString *desiredAttributeType = [[self userInfo] valueForKey:kMagicalRecordImportAttributeValueClassNameKey];
    if (desiredAttributeType) 
    {
        if ([desiredAttributeType hasSuffix:@"Color"])
        {
            value = colorFromString(value);
        }
    }
    else 
    {
        if (attributeType == NSDateAttributeType)
        {
            if (![value isKindOfClass:[NSDate class]]) 
            {
                NSDate *convertedValue = nil;
                NSString *dateFormat;
                NSUInteger index = 0;
                do {
                    NSMutableString *dateFormatKey = [kMagicalRecordImportCustomDateFormatKey mutableCopy];
                    if (index) {
                        [dateFormatKey appendFormat:@".%tu", index];
                    }
                    index++;
                    dateFormat = [[self userInfo] valueForKey:dateFormatKey];
                    convertedValue = dateFromString([value description], dateFormat ?: kMagicalRecordImportDefaultDateFormatString);
                } while (!convertedValue && dateFormat);
                value = convertedValue;
            }
            //            value = adjustDateForDST(value);
        }
        else if (attributeType == NSInteger16AttributeType ||
                 attributeType == NSInteger32AttributeType ||
                 attributeType == NSInteger64AttributeType ||
                 attributeType == NSDecimalAttributeType ||
                 attributeType == NSDoubleAttributeType ||
                 attributeType == NSFloatAttributeType) {
            if (![value isKindOfClass:[NSNumber class]] && value != [NSNull null]) {
                value = numberFromString([value description]);
            }
        }
    }
    
    return value == [NSNull null] ? nil : value;   
}

@end
