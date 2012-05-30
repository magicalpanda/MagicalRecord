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
    NSString *lookupKey = [[self userInfo] valueForKey:kMagicalRecordImportRelationshipLinkedByKey] ?: primaryKeyNameFromString([self name]);
    NSDictionary *attributesByName = [self attributesByName];
                                    
    if ([attributesByName count] == 0) return nil;
    
    NSAttributeDescription *primaryAttribute = [attributesByName objectForKey:lookupKey];

    return primaryAttribute;
}

- (NSManagedObject *) MR_createInstanceInContext:(NSManagedObjectContext *)context;
{
    Class relatedClass = NSClassFromString([self managedObjectClassName]);
    NSManagedObject *newInstance = [relatedClass MR_createInContext:context];
   
    return newInstance;
}


@end
