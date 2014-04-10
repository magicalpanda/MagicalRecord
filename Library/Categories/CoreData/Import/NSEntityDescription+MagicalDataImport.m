//
//  NSEntityDescription+MagicalDataImport.m
//  Magical Record
//
//  Created by Saul Mora on 9/5/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"
#import "NSEntityDescription+MagicalDataImport.h"

@implementation NSEntityDescription (MagicalRecord_DataImport)

- (NSAttributeDescription *) MR_primaryAttributeToRelateBy;
{
    NSString *lookupKey = [[self userInfo] valueForKey:kMagicalRecordImportRelationshipLinkedByKey] ?: MR_primaryKeyNameFromString([self name]);

    return [self MR_attributeDescriptionForName:lookupKey];
}

- (NSManagedObject *) MR_createInstanceInContext:(NSManagedObjectContext *)context;
{
    Class relatedClass = NSClassFromString([self managedObjectClassName]);
    NSManagedObject *newInstance = [relatedClass MR_createInContext:context];
   
    return newInstance;
}

- (NSAttributeDescription *) MR_attributeDescriptionForName:(NSString *)name;
{
    __block NSAttributeDescription *description;

    NSDictionary *attributesByName = [self attributesByName];

    if ([attributesByName count] == 0) {
        return nil;
    }

    [attributesByName enumerateKeysAndObjectsUsingBlock:^(NSString *attributeName, NSAttributeDescription *attributeDescription, BOOL *stop) {
        if ([attributeName isEqualToString:name]) {
            description = attributeDescription;

            *stop = YES;
        }
    }];

    return description;
}

@end
