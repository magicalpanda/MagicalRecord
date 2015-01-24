//
//  NSManagedObject+MagicalDataImport.h
//
//  Created by Saul Mora on 6/28/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const kMagicalRecordImportCustomDateFormatKey;
extern NSString * const kMagicalRecordImportDefaultDateFormatString;
extern NSString * const kMagicalRecordImportUnixTimeString;
extern NSString * const kMagicalRecordImportAttributeKeyMapKey;
extern NSString * const kMagicalRecordImportDistinctAttributeKey;
extern NSString * const kMagicalRecordImportAttributeValueClassNameKey;

extern NSString * const kMagicalRecordImportRelationshipMapKey;
extern NSString * const kMagicalRecordImportRelationshipLinkedByKey;
extern NSString * const kMagicalRecordImportRelationshipTypeKey;

extern NSString * const kMagicalRecordImportAttributeUseDefaultValueWhenNotPresent;

@protocol MagicalRecordDataImportProtocol <NSObject>

@optional
- (BOOL) shouldImport:(id)data;
- (void) willImport:(id)data;
- (void) didImport:(id)data;

@end

@interface NSManagedObject (MagicalRecordDataImport) <MagicalRecordDataImportProtocol>

+ (id) MR_importFromObject:(id)data;
+ (id) MR_importFromObject:(id)data inContext:(NSManagedObjectContext *)context;

+ (NSArray *) MR_importFromArray:(id<NSFastEnumeration>)listOfObjectData;
+ (NSArray *) MR_importFromArray:(id<NSFastEnumeration>)listOfObjectData inContext:(NSManagedObjectContext *)context;

@end

