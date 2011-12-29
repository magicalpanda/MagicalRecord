//
//  NSManagedObject+JSONHelpers.h
//  Gathering
//
//  Created by Saul Mora on 6/28/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

extern NSString * const kMagicalRecordImportCustomDateFormatKey;
extern NSString * const kMagicalRecordImportDefaultDateFormatString;
extern NSString * const kMagicalRecordImportAttributeKeyMapKey;
extern NSString * const kMagicalRecordImportAttributeValueClassNameKey;

extern NSString * const kMagicalRecordImportRelationshipMapKey;
extern NSString * const kMagicalRecordImportRelationshipPrimaryKey;
extern NSString * const kMagicalRecordImportRelationshipTypeKey;

@interface NSManagedObject (MagicalRecord_DataImport)

- (void) MR_importValuesForKeysWithDictionary:(id)objectData;
- (void) MR_updateValuesForKeysWithDictionary:(id)objectData;

+ (id) MR_importFromDictionary:(id)data;
+ (id) MR_importFromDictionary:(id)data inContext:(NSManagedObjectContext *)context;

+ (NSArray *) MR_importFromArray:(NSArray *)listOfObjectData;
+ (NSArray *) MR_importFromArray:(NSArray *)listOfObjectData inContext:(NSManagedObjectContext *)context;

+ (id) MR_updateFromDictionary:(id)objectData;
+ (id) MR_updateFromDictionary:(id)objectData inContext:(NSManagedObjectContext *)context;

+ (NSArray *) MR_updateFromArray:(NSArray *)listOfObjectData;
+ (NSArray *) MR_updateFromArray:(NSArray *)listOfObjectData inContext:(NSManagedObjectContext *)context;

@end
