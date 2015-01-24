//
//  NSRelationshipDescription+MagicalDataImport.h
//  Magical Record
//
//  Created by Saul Mora on 9/4/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSRelationshipDescription (MagicalRecordDataImport)

- (NSString *) MR_primaryKey;

@end
