//
//  NSEntityDescription+MagicalDataImport.m
//  Magical Record
//
//  Created by Saul Mora on 9/5/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"
#import "NSEntityDescription+MagicalDataImport.h"

@implementation NSEntityDescription (MagicalRecordDataImport)

- (NSManagedObject *) MR_createInstanceInContext:(NSManagedObjectContext *)context;
{
    Class relatedClass = NSClassFromString([self managedObjectClassName]);
    NSManagedObject *newInstance = [relatedClass MR_createInContext:context];

    return newInstance;
}

- (NSAttributeDescription *) MR_attributeDescriptionForName:(NSString *)name;
{
    __block NSAttributeDescription *description = nil;

    NSDictionary *attributesByName = [self attributesByName];

    [attributesByName enumerateKeysAndObjectsUsingBlock:^(NSString *attributeName, NSAttributeDescription *attributeDescription, BOOL *stop) {
        if ([attributeName isEqualToString:name])
        {
            description = attributeDescription;

            *stop = YES;
        }
    }];

    return description;
}

- (NSAttributeDescription *) MR_primaryAttributeToRelateBy;
{
    NSString *lookupKey = [[self userInfo] valueForKey:kMagicalRecordImportRelationshipLinkedByKey] ?: MRPrimaryKeyNameFromString([self name]);

    return [self MR_attributeDescriptionForName:lookupKey];
}

- (NSAttributeDescription *) MR_primaryAttribute;
{
    NSString *lookupKey = [[self userInfo] valueForKey:kMagicalRecordImportDistinctAttributeKey];
    return [self MR_attributeDescriptionForName:lookupKey];
}

@end
