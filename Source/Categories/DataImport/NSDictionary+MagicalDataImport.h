//
//  NSDictionary+MagicalDataImport.h
//  Magical Record
//
//  Created by Saul Mora on 9/4/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef MR_SHORTHAND
	#define MR_lookupKeyForAttribute lookupKeyForAttribute
	#define MR_lookupKeyForRelationship lookupKeyForRelationship
	#define MR_relatedValueForRelationship relatedValueForRelationship
	#define MR_valueForAttribute valueForAttribute
#endif

@interface NSDictionary (MagicalRecord_DataImport)

- (NSString *) MR_lookupKeyForAttribute:(NSAttributeDescription *)attributeInfo;
- (id) MR_valueForAttribute:(NSAttributeDescription *)attributeInfo;

- (NSString *) MR_lookupKeyForRelationship:(NSRelationshipDescription *)relationshipInfo;
- (id) MR_relatedValueForRelationship:(NSRelationshipDescription *)relationshipInfo;

@end
