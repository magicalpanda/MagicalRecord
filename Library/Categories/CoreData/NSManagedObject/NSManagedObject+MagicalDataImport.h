//
//  NSManagedObject+JSONHelpers.h
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
extern NSString * const kMagicalRecordImportRelationshipLinkedByKey;
extern NSString * const kMagicalRecordImportRelationshipTypeKey;

@interface NSManagedObject (MagicalRecord_DataImport)

- (BOOL) MR_importValuesForKeysWithObject:(id)objectData;

+ (id) MR_importFromObject:(id)data;
+ (id) MR_importFromObject:(id)data inContext:(NSManagedObjectContext *)context;

+ (NSArray *) MR_importFromArray:(NSArray *)listOfObjectData;
+ (NSArray *) MR_importFromArray:(NSArray *)listOfObjectData inContext:(NSManagedObjectContext *)context;

@end

@interface NSManagedObject (MagicalRecord_DataImportControls)

- (BOOL) shouldImport:(id)data;
- (void) willImport:(id)data;
- (void) didImport:(id)data;

@end
