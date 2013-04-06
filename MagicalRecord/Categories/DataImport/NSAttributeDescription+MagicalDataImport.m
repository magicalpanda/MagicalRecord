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
                NSString *dateFormat = [[self userInfo] valueForKey:kMagicalRecordImportCustomDateFormatKey];
                value = dateFromString([value description], dateFormat ?: kMagicalRecordImportDefaultDateFormatString);
            }
            //            value = adjustDateForDST(value);
        }
        else if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]]))
        {
            value = [value stringValue];
        }
        else if (((attributeType == NSInteger16AttributeType) ||
                  (attributeType == NSInteger32AttributeType) ||
                  (attributeType == NSInteger64AttributeType) ||
                  (attributeType == NSBooleanAttributeType)) &&
                 ([value isKindOfClass:[NSString class]]))
        {
            value = @([value integerValue]);
        }
        else if ((attributeType == NSFloatAttributeType) &&
                 ([value isKindOfClass:[NSString class]]))
        {
            value = @([value doubleValue]);
        }
    }
    
    return value == [NSNull null] ? nil : value;   
}

@end
