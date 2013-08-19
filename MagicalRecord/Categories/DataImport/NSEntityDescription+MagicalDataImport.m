//
//  NSEntityDescription+MagicalDataImport.m
//  Magical Record
//
//  Created by Saul Mora on 9/5/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "CoreData+MagicalRecord.h"

@implementation NSEntityDescription (MagicalRecord_DataImport)

- (NSAttributeDescription *) MR_primaryAttributeToRelateBy;
{
    NSEntityDescription *entityDescription = self;
    NSAttributeDescription *primaryAttribute = nil;
    do {
        NSDictionary *attributesByName = [entityDescription attributesByName];
        if ([attributesByName count]) {
            primaryAttribute = [attributesByName objectForKey:[entityDescription MR_lookupKey]];
        };
        entityDescription = entityDescription.superentity;
    } while (!primaryAttribute && entityDescription);

    return primaryAttribute;
}

- (NSManagedObject *) MR_createInstanceInContext:(NSManagedObjectContext *)context;
{
    Class relatedClass = NSClassFromString([self managedObjectClassName]);
    NSManagedObject *newInstance = [relatedClass MR_createInContext:context];
   
    return newInstance;
}

- (NSString*) MR_lookupKey
{
    NSString *primaryKeyName = [[self userInfo] valueForKey:kMagicalRecordImportRelationshipLinkedByKey] ?: primaryKeyNameFromString([self name]);
    if ([[[self attributesByName] allKeys] containsObject:primaryKeyName]) {
        return primaryKeyName;
    } else {
        NSString *primaryKeyNameInSuperentity = [[self superentity] MR_lookupKey];
        return primaryKeyNameInSuperentity ?: primaryKeyName;
    }
}

@end
