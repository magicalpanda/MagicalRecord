//
//  NSEntityDescription+MagicalDataImport.h
//  Magical Record
//
//  Created by Saul Mora on 9/5/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//


@interface NSEntityDescription (MagicalRecord_DataImport)

- (NSAttributeDescription *) MR_primaryAttributeToRelateBy;
- (NSManagedObject *) MR_createInstanceInContext:(NSManagedObjectContext *)context;

@end
