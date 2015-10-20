//
//  NSManagedObject+JSONHelpers.h
//
//  Created by Saul Mora on 6/28/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>

OBJC_EXPORT NSString * __MR_nonnull const kMagicalRecordImportCustomDateFormatKey;
OBJC_EXPORT NSString * __MR_nonnull const kMagicalRecordImportDefaultDateFormatString;
OBJC_EXPORT NSString * __MR_nonnull const kMagicalRecordImportUnixTimeString;
OBJC_EXPORT NSString * __MR_nonnull const kMagicalRecordImportAttributeKeyMapKey;
OBJC_EXPORT NSString * __MR_nonnull const kMagicalRecordImportAttributeValueClassNameKey;

OBJC_EXPORT NSString * __MR_nonnull const kMagicalRecordImportRelationshipMapKey;
OBJC_EXPORT NSString * __MR_nonnull const kMagicalRecordImportRelationshipLinkedByKey;
OBJC_EXPORT NSString * __MR_nonnull const kMagicalRecordImportRelationshipTypeKey;

@protocol MagicalRecordDataImportProtocol <NSObject>

@optional
- (BOOL) shouldImport:(MR_nonnull id)data;
- (void) willImport:(MR_nonnull id)data;
- (void) didImport:(MR_nonnull id)data;

@end

@interface NSManagedObject (MagicalRecord_DataImport) <MagicalRecordDataImportProtocol>

- (BOOL) MR_importValuesForKeysWithObject:(MR_nonnull id)objectData;

+ (MR_nonnull instancetype) MR_importFromObject:(MR_nonnull id)data;
+ (MR_nonnull instancetype) MR_importFromObject:(MR_nonnull id)data inContext:(MR_nonnull NSManagedObjectContext *)context;

+ (MR_nonnull MR_NSArrayOfNSManagedObjects) MR_importFromArray:(MR_nonnull MR_GENERIC(NSArray, NSDictionary *) *)listOfObjectData;
+ (MR_nonnull MR_NSArrayOfNSManagedObjects) MR_importFromArray:(MR_nonnull MR_GENERIC(NSArray, NSDictionary *) *)listOfObjectData inContext:(MR_nonnull NSManagedObjectContext *)context;

@end
