//
//  NSDictionary+MagicalDataImport.h
//  Magical Record
//
//  Created by Saul Mora on 9/4/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSObject (MagicalRecordDataImport)

- (NSString *) MR_lookupKeyForProperty:(NSPropertyDescription *)propertyDescription;
- (id) MR_valueForAttribute:(NSAttributeDescription *)attributeInfo;

- (NSString *) MR_lookupKeyForRelationship:(NSRelationshipDescription *)relationshipInfo;
- (id) MR_relatedValueForRelationship:(NSRelationshipDescription *)relationshipInfo;

@end
