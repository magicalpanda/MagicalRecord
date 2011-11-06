//
//  NSNumber+MagicalDataImport.h
//  Magical Record
//
//  Created by Saul Mora on 9/4/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef MR_SHORTHAND
	#define MR_lookupKeyForAttribute lookupKeyForAttribute
	#define MR_relatedValueForRelationship relatedValueForRelationship
#endif

@interface NSNumber (MagicalRecord_DataImport)

- (NSString *) MR_lookupKeyForAttribute:(NSAttributeDescription *)attributeInfo;
- (id) MR_relatedValueForRelationship:(NSRelationshipDescription *)relationshipInfo;

@end
