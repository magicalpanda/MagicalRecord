//
//  MagicalImportFunctions.m
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalImportFunctions.h"


#pragma mark - Data import helper functions

NSString * attributeNameFromString(NSString *value)
{
    NSString *firstCharacter = [[value substringToIndex:1] capitalizedString];
    return [firstCharacter stringByAppendingString:[value substringFromIndex:1]];
}

NSString * primaryKeyNameFromString(NSString *value)
{
    NSString *firstCharacter = [[value substringToIndex:1] lowercaseString];
    return [firstCharacter stringByAppendingFormat:@"%@ID", [value substringFromIndex:1]];
}

NSDate * adjustDateForDST(NSDate *date)
{
    NSTimeInterval dstOffset = [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate:date];
    NSDate *actualDate = [date dateByAddingTimeInterval:dstOffset];
    
    return actualDate;
}

NSDate * dateFromString(NSString *value, NSString *format)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:format];
    
    NSDate *parsedDate = [formatter dateFromString:value];
    
    return parsedDate;
}

NSNumber * numberFromString(NSString *value) {
    return [NSNumber numberWithDouble:[value doubleValue]];
}

NSInteger* newColorComponentsFromString(NSString *serializedColor);
NSInteger* newColorComponentsFromString(NSString *serializedColor)
{
    NSScanner *colorScanner = [NSScanner scannerWithString:serializedColor];
    NSString *colorType;
    [colorScanner scanUpToString:@"(" intoString:&colorType];
    
    NSInteger *componentValues = malloc(4 * sizeof(NSInteger));
    if ([colorType hasPrefix:@"rgba"])
    {
        NSCharacterSet *rgbaCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"(,)"];
        
        NSInteger *componentValue = componentValues;
        while (![colorScanner isAtEnd]) 
        {
            [colorScanner scanCharactersFromSet:rgbaCharacterSet intoString:nil];
            [colorScanner scanInteger:componentValue];
            componentValue++;
        }
    }
    //else if ([colorType hasPrefix:@"hsba"])
    //else if ([colorType hasPrefix:@""])
    return componentValues;
}

#if TARGET_OS_IPHONE

UIColor * UIColorFromString(NSString *serializedColor)
{
    NSInteger *componentValues = newColorComponentsFromString(serializedColor);
    UIColor *color = [UIColor colorWithRed:(componentValues[0] / 255.0f)
                                     green:(componentValues[1] / 255.0f)
                                      blue:(componentValues[2] / 255.0f)
                                     alpha:componentValues[3]];
    
    free(componentValues);
    return color;
}
id (*colorFromString)(NSString *) = UIColorFromString;

#else

NSColor * NSColorFromString(NSString *serializedColor)
{
    NSInteger *componentValues = newColorComponentsFromString(serializedColor);
    NSColor *color = [NSColor colorWithDeviceRed:(componentValues[0] / 255.0f)
                                           green:(componentValues[1] / 255.0f)
                                            blue:(componentValues[2] / 255.0f)
                                           alpha:componentValues[3]];
    free(componentValues);
    return color;
}
id (*colorFromString)(NSString *) = NSColorFromString;


#endif
