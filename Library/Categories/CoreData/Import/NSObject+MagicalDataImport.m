//
//  NSDictionary+MagicalDataImport.m
//  Magical Record
//
//  Created by Saul Mora on 9/4/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSObject+MagicalDataImport.h"
#import "MagicalRecord.h"
#import "MagicalRecordLogging.h"

NSUInteger const kMagicalRecordImportMaximumAttributeFailoverDepth = 10;

@implementation NSObject (MagicalRecordDataImport)

- (NSString *) MR_lookupKeyForProperty:(NSPropertyDescription *)propertyDescription;
{
    NSString *attributeName = [propertyDescription name];
    NSDictionary *userInfo = [propertyDescription userInfo];
    NSString *lookupKey = [userInfo valueForKey:kMagicalRecordImportAttributeKeyMapKey] ?: attributeName;
    
    id value = [self valueForKeyPath:lookupKey];
    
    for (NSUInteger i = 1; i < kMagicalRecordImportMaximumAttributeFailoverDepth && value == nil; i++)
    {
        attributeName = [NSString stringWithFormat:@"%@.%tu", kMagicalRecordImportAttributeKeyMapKey, i];
        lookupKey = [userInfo valueForKey:attributeName];
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
    NSString *lookupKey = [self MR_lookupKeyForProperty:attributeInfo];
    return lookupKey ? [self valueForKeyPath:lookupKey] : nil;
}

- (NSString *) MR_lookupKeyForRelationship:(NSRelationshipDescription *)relationshipInfo
{
    NSEntityDescription *destinationEntity = [relationshipInfo destinationEntity];
    if (destinationEntity == nil) 
    {
        MRLogWarn(@"Unable to find entity for type '%@'", [self valueForKey:kMagicalRecordImportRelationshipTypeKey]);
        return nil;
    }
    
    NSAttributeDescription *primaryKeyAttribute = [destinationEntity MR_primaryAttribute];
    NSString *lookupKey = [self MR_lookupKeyForProperty:primaryKeyAttribute] ?: [primaryKeyAttribute name];

    return lookupKey;
}

- (id) MR_relatedValueForRelationship:(NSRelationshipDescription *)relationshipInfo
{
    NSString *lookupKey = [self MR_lookupKeyForRelationship:relationshipInfo];
    return lookupKey ? [self valueForKeyPath:lookupKey] : nil;
}

@end
