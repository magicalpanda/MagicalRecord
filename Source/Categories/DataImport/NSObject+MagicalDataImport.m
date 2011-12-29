//
//  NSDictionary+MagicalDataImport.m
//  Magical Record
//
//  Created by Saul Mora on 9/4/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSObject+MagicalDataImport.h"

NSUInteger const kMagicalRecordImportMaximumAttributeFailoverDepth = 10;


@implementation NSObject (MagicalRecord_DataImport)

//#warning If you implement valueForUndefinedKey: in any NSObject in your code, this may be the problem if something broke
//TODO: This method needs to be:
// 1) Renamed to MR_valueForUndefinedKey:
// 2) swizzled in and out only when importing data.
// This will be done in a really short update...stay tuned
- (id) MR_valueForUndefinedKey:(NSString *)key
{
    return nil;
}

- (NSString *) MR_lookupKeyForAttribute:(NSAttributeDescription *)attributeInfo;
{
    NSString *attributeName = [attributeInfo name];
    NSString *lookupKey = [[attributeInfo userInfo] valueForKey:kMagicalRecordImportAttributeKeyMapKey] ?: attributeName;
    
    id value = [self valueForKeyPath:lookupKey];
    
    for (int i = 1; i < kMagicalRecordImportMaximumAttributeFailoverDepth && value == nil; i++)
    {
        attributeName = [NSString stringWithFormat:@"%@.%d", kMagicalRecordImportAttributeKeyMapKey, i];
        lookupKey = [[attributeInfo userInfo] valueForKey:attributeName];
        if (lookupKey == nil) 
        {
            return nil;
        }
        value = [self valueForKeyPath:lookupKey];
    }
    
    return value != nil ? lookupKey : nil;
}

- (id) MR_valueForAttribute:(NSAttributeDescription *)attributeInfo
{
    NSString *lookupKey = [self MR_lookupKeyForAttribute:attributeInfo];
    return lookupKey ? [self valueForKeyPath:lookupKey] : nil;
}

- (NSString *) MR_lookupKeyForRelationship:(NSRelationshipDescription *)relationshipInfo
{
    NSEntityDescription *destinationEntity = [relationshipInfo destinationEntity];
    if (destinationEntity == nil) 
    {
        MRLog(@"Unable to find entity for type '%@'", [self valueForKey:kMagicalRecordImportRelationshipTypeKey]);
        return nil;
    }
    
    NSString *primaryKeyName = [relationshipInfo MR_primaryKey];
    
    NSAttributeDescription *primaryKeyAttribute = [[destinationEntity attributesByName] valueForKey:primaryKeyName];
    NSString *lookupKey = [[primaryKeyAttribute userInfo] valueForKey:kMagicalRecordImportAttributeKeyMapKey] ?: [primaryKeyAttribute name];
    
    return lookupKey;
}

- (id) MR_relatedValueForRelationship:(NSRelationshipDescription *)relationshipInfo
{
    NSString *lookupKey = [self MR_lookupKeyForRelationship:relationshipInfo];
    return lookupKey ? [self valueForKeyPath:lookupKey] : nil;
}

@end
