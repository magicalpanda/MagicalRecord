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

- (NSString *)MR_lookupKeyForProperty:(NSPropertyDescription *)propertyDescription
{
    NSString *attributeName = nil;
    NSDictionary *userInfo = [propertyDescription userInfo];
    NSString *lookupKey = nil;
    id value = nil;

    for (NSUInteger i = 1; i < kMagicalRecordImportMaximumAttributeFailoverDepth && value == nil; i++)
    {
        attributeName = [NSString stringWithFormat:@"%@.%tu", kMagicalRecordImportAttributeKeyMapKey, i];
        lookupKey = [userInfo objectForKey:attributeName];
        if (lookupKey == nil) //stop after first nil key, means there are no more to look for
        {
            break;
        }
        value = [self valueForKeyPath:lookupKey];
    }

    NSString *basicLookupKey = [userInfo objectForKey:kMagicalRecordImportAttributeKeyMapKey] ?: [propertyDescription name];

    return value != nil ? lookupKey : basicLookupKey;
}

- (id)MR_valueForAttribute:(NSAttributeDescription *)attributeInfo
{
    NSString *lookupKey = [self MR_lookupKeyForProperty:attributeInfo];
    return lookupKey ? [self valueForKeyPath:lookupKey] : nil;
}

- (NSString *)MR_lookupKeyForRelationship:(NSRelationshipDescription *)relationshipInfo
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

- (id)MR_relatedValueForRelationship:(NSRelationshipDescription *)relationshipInfo
{
    NSString *lookupKey = [self MR_lookupKeyForRelationship:relationshipInfo];
    return lookupKey ? [self valueForKeyPath:lookupKey] : nil;
}

@end
