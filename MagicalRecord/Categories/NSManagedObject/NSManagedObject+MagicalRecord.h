//
//
//  Created by Saul Mora on 11/15/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecordDeprecationMacros.h>
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>

@interface NSManagedObject (MagicalRecord)

/**
 *  If the NSManagedObject subclass calling this method has implemented the `entityName` method, then the return value of that will be used.
 *  If `entityName` is not implemented, then the name of the class is returned. If the class is written in Swift, the module name will be removed.
 *
 *  @return String based name for the entity
 */
+ (MR_nonnull NSString *) MR_entityName;

+ (NSUInteger) MR_defaultBatchSize;
+ (void) MR_setDefaultBatchSize:(NSUInteger)newBatchSize;

+ (MR_nullable MR_NSArrayOfNSManagedObjects) MR_executeFetchRequest:(MR_nonnull NSFetchRequest *)request;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) MR_executeFetchRequest:(MR_nonnull NSFetchRequest *)request inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable instancetype) MR_executeFetchRequestAndReturnFirstObject:(MR_nonnull NSFetchRequest *)request;
+ (MR_nullable instancetype) MR_executeFetchRequestAndReturnFirstObject:(MR_nonnull NSFetchRequest *)request inContext:(MR_nonnull NSManagedObjectContext *)context;

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (BOOL) MR_performFetch:(MR_nonnull NSFetchedResultsController *)controller;

#endif

+ (MR_nullable NSEntityDescription *) MR_entityDescription;
+ (MR_nullable NSEntityDescription *) MR_entityDescriptionInContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable MR_GENERIC(NSArray, NSPropertyDescription *) *) MR_propertiesNamed:(MR_nonnull MR_GENERIC(NSArray, NSString *) *)properties;
+ (MR_nullable MR_GENERIC(NSArray, NSPropertyDescription *) *) MR_propertiesNamed:(MR_nonnull MR_GENERIC(NSArray, NSString *) *)properties inContext:(MR_nonnull NSManagedObjectContext *)context;

+ (MR_nullable instancetype) MR_createEntity;
+ (MR_nullable instancetype) MR_createEntityInContext:(MR_nonnull NSManagedObjectContext *)context;

- (BOOL) MR_deleteEntity;
- (BOOL) MR_deleteEntityInContext:(MR_nonnull NSManagedObjectContext *)context;

+ (BOOL) MR_deleteAllMatchingPredicate:(MR_nonnull NSPredicate *)predicate;
+ (BOOL) MR_deleteAllMatchingPredicate:(MR_nonnull NSPredicate *)predicate inContext:(MR_nonnull NSManagedObjectContext *)context;

+ (BOOL) MR_truncateAll;
+ (BOOL) MR_truncateAllInContext:(MR_nonnull NSManagedObjectContext *)context;

+ (MR_nonnull MR_GENERIC(NSArray, NSSortDescriptor *) *) MR_ascendingSortDescriptors:(MR_nonnull MR_GENERIC(NSArray, NSString *) *)attributesToSortBy;
+ (MR_nonnull MR_GENERIC(NSArray, NSSortDescriptor *) *) MR_descendingSortDescriptors:(MR_nonnull MR_GENERIC(NSArray, NSString *) *)attributesToSortBy;

- (MR_nullable instancetype) MR_inContext:(MR_nonnull NSManagedObjectContext *)otherContext;
- (MR_nullable instancetype) MR_inThreadContext;

@end

@protocol MagicalRecord_MOGenerator <NSObject>

@optional
+ (MR_nonnull NSString *)entityName;
- (MR_nullable instancetype) entityInManagedObjectContext:(MR_nonnull NSManagedObjectContext *)object;
- (MR_nullable instancetype) insertInManagedObjectContext:(MR_nonnull NSManagedObjectContext *)object;

@end

#pragma mark - Deprecated Methods — DO NOT USE
@interface NSManagedObject (MagicalRecordDeprecated)

+ (MR_nullable instancetype) MR_createInContext:(MR_nonnull NSManagedObjectContext *)context MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_createEntityInContext:");
- (BOOL) MR_deleteInContext:(MR_nonnull NSManagedObjectContext *)context MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_deleteEntityInContext:");

@end
