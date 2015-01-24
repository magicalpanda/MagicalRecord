//
//  NSAttributeDescription+MagicalDataImport.h
//  Magical Record
//
//  Created by Saul Mora on 9/4/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSAttributeDescription (MagicalRecordDataImport)

- (NSString *) MR_primaryKey;
- (id) MR_valueForKeyPath:(NSString *)keyPath fromObjectData:(id)objectData;

- (BOOL) MR_shouldUseDefaultValueIfNoValuePresent;

@end
