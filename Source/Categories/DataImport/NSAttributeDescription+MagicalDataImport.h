//
//  NSAttributeDescription+MagicalDataImport.h
//  Magical Record
//
//  Created by Saul Mora on 9/4/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

#ifdef MR_SHORTHAND
	#define MR_primaryKey primaryKey
#endif

@interface NSAttributeDescription (MagicalRecord_DataImport)

- (NSString *) MR_primaryKey;

@end
