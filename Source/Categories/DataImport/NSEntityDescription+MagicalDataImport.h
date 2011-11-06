//
//  NSEntityDescription+MagicalDataImport.h
//  Magical Record
//
//  Created by Saul Mora on 9/5/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#ifdef MR_SHORTHAND
	#define MR_primaryKeyAttribute primaryKeyAttribute
#endif

@interface NSEntityDescription (MagicalRecord_DataImport)

- (NSAttributeDescription *) MR_primaryKeyAttribute;

@end
