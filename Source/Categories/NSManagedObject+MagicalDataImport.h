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

@interface NSManagedObject (NSManagedObject_DataImport)

- (void) MR_importValuesForKeysWithDictionary:(NSDictionary *)objectData;
- (void) MR_updateValuesForKeysWithDictionary:(NSDictionary *)objectData;

+ (id) MR_importFromDictionary:(NSDictionary *)data;
+ (id) MR_importFromDictionary:(NSDictionary *)data inContext:(NSManagedObjectContext *)context;

+ (NSArray *) MR_importFromArray:(NSArray *)listOfObjectData;
+ (NSArray *) MR_importFromArray:(NSArray *)listOfObjectData inContext:(NSManagedObjectContext *)context;

+ (id) MR_updateFromDictionary:(NSDictionary *)objectData;
+ (id) MR_updateFromDictionary:(NSDictionary *)objectData inContext:(NSManagedObjectContext *)context;

@end


#ifdef MR_SHORTHAND

@interface NSManagedObject (NSManagedObject_DataImport_ShortHand)

- (void) importValuesForKeysWithDictionary:(NSDictionary *)objectData;
- (void) updateValuesForKeysWithDictionary:(NSDictionary *)objectData;

+ (id) importFromDictionary:(NSDictionary *)data;
+ (id) importFromDictionary:(NSDictionary *)data inContext:(NSManagedObjectContext *)context;

+ (NSArray *) importFromArray:(NSArray *)listOfObjectData;
+ (NSArray *) importFromArray:(NSArray *)listOfObjectData inContext:(NSManagedObjectContext *)context;

+ (id) updateFromDictionary:(NSDictionary *)objectData;
+ (id) updateFromDictionary:(NSDictionary *)objectData inContext:(NSManagedObjectContext *)context;

@end
#endif