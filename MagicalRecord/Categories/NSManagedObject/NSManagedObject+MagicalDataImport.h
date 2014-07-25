//
//  NSManagedObject+JSONHelpers.h
//
//  Created by Saul Mora on 6/28/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

extern NSString * const kMagicalRecordImportCustomDateFormatKey;
extern NSString * const kMagicalRecordImportDefaultDateFormatString;
extern NSString * const kMagicalRecordImportUnixTimeString;
extern NSString * const kMagicalRecordImportAttributeKeyMapKey;
extern NSString * const kMagicalRecordImportAttributeValueClassNameKey;

extern NSString * const kMagicalRecordImportRelationshipMapKey;
extern NSString * const kMagicalRecordImportRelationshipLinkedByKey;
extern NSString * const kMagicalRecordImportRelationshipTypeKey;

@interface NSManagedObject (MagicalRecord_DataImport)

/**
 When a managed object is the target of a MagicalRecord import, this property will be true.
 
 @discussion We've observed issues during imports with NSManagedObject subclasses that implement `- (id)valueForUndefinedKey:`. If you experience problems, you can insert an early return at the start of that method that checks this property and returns `nil` if it is true.

 @since Available in v2.3 and later.
 */
@property (readonly, nonatomic, assign, getter=MR_isImporting) BOOL MR_importing;

- (BOOL) MR_importValuesForKeysWithObject:(id)objectData;

+ (instancetype) MR_importFromObject:(id)data;
+ (instancetype) MR_importFromObject:(id)data inContext:(NSManagedObjectContext *)context;

+ (NSArray *) MR_importFromArray:(NSArray *)listOfObjectData;
+ (NSArray *) MR_importFromArray:(NSArray *)listOfObjectData inContext:(NSManagedObjectContext *)context;

@end

@interface NSManagedObject (MagicalRecord_DataImportControls)

- (BOOL) shouldImport:(id)data;
- (void) willImport:(id)data;
- (void) didImport:(id)data;

@end
