//
//  NSManagedObject+JSONHelpers.m
//  Gathering
//
//  Created by Saul Mora on 6/28/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObject+JSONHelpers.h"


static NSString * const kNSManagedObjectAttributeJSONKeyMapKey = @"jsonKeyName";

@implementation NSString (JSONParsingHelpers)

- (NSDate *) ga_dateFromJSONString;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'Z'"];
    
    return [formatter dateFromString:self];
}

@end



@implementation NSManagedObject (NSManagedObject_JSONHelpers)


- (void) setValuesForKeysWithJSONDictionary:(NSDictionary *)jsonData
{
    NSDictionary *attributes = [[self entity] attributesByName];
    
    for (NSString *attributeName in attributes) 
    {
        NSAttributeDescription *attributeInfo = [attributes valueForKey:attributeName];
        
        NSString *lookupKey = [[attributeInfo userInfo] valueForKey:kNSManagedObjectAttributeJSONKeyMapKey] ?: attributeName;
        id value = [jsonData valueForKey:lookupKey];
        
        if (value == nil || [value isEqual:[NSNull null]])
        {
            continue;
        }
        
        NSAttributeType attributeType = [attributeInfo attributeType];
        if (attributeType == NSDateAttributeType)
        {
            value = [value ga_dateFromJSONString];
        }
        
        [self setValue:value forKey:attributeName];
    }
}
@end
