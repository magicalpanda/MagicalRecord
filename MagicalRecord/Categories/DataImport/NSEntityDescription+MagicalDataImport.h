//
//  NSEntityDescription+MagicalDataImport.h
//  Magical Record
//
//  Created by Saul Mora on 9/5/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//


@interface NSEntityDescription (MagicalRecord_DataImport)

- (NSAttributeDescription *) MR_primaryKeyAttribute;
- (NSManagedObject *) MR_createInstanceFromDictionary:(id)objectData inContext:(NSManagedObjectContext *)context;

@end
