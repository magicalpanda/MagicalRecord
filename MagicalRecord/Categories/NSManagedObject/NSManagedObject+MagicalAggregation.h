//
//  NSManagedObject+MagicalAggregation.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>

@interface NSManagedObject (MagicalAggregation)

+ (MR_nonnull NSNumber *) MR_numberOfEntities;
+ (MR_nonnull NSNumber *) MR_numberOfEntitiesWithContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nonnull NSNumber *) MR_numberOfEntitiesWithPredicate:(MR_nullable NSPredicate *)searchTerm;
+ (MR_nonnull NSNumber *) MR_numberOfEntitiesWithPredicate:(MR_nullable NSPredicate *)searchTerm inContext:(MR_nonnull NSManagedObjectContext *)context;

+ (NSUInteger) MR_countOfEntities;
+ (NSUInteger) MR_countOfEntitiesWithContext:(MR_nonnull NSManagedObjectContext *)context;
+ (NSUInteger) MR_countOfEntitiesWithPredicate:(MR_nullable NSPredicate *)searchFilter;
+ (NSUInteger) MR_countOfEntitiesWithPredicate:(MR_nullable NSPredicate *)searchFilter inContext:(MR_nonnull NSManagedObjectContext *)context;

+ (BOOL) MR_hasAtLeastOneEntity;
+ (BOOL) MR_hasAtLeastOneEntityInContext:(MR_nonnull NSManagedObjectContext *)context;

- (MR_nullable id) MR_minValueFor:(MR_nonnull NSString *)property;
- (MR_nullable id) MR_maxValueFor:(MR_nonnull NSString *)property;

+ (MR_nullable id) MR_aggregateOperation:(MR_nonnull NSString *)function onAttribute:(MR_nonnull NSString *)attributeName withPredicate:(MR_nullable NSPredicate *)predicate inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable id) MR_aggregateOperation:(MR_nonnull NSString *)function onAttribute:(MR_nonnull NSString *)attributeName withPredicate:(MR_nullable NSPredicate *)predicate;

/**
 *  Supports aggregating values using a key-value collection operator that can be grouped by an attribute.
 *  See https://developer.apple.com/library/ios/documentation/cocoa/conceptual/KeyValueCoding/Articles/CollectionOperators.html for a list of valid collection operators.
 *
 *  @since 2.3.0
 *
 *  @param collectionOperator   Collection operator
 *  @param attributeName        Entity attribute to apply the collection operator to
 *  @param predicate            Predicate to filter results
 *  @param groupingKeyPath      Key path to group results by
 *  @param context              Context to perform the request in
 *
 *  @return Results of the collection operator, filtered by the provided predicate and grouped by the provided key path
 */
+ (MR_nullable NSArray *) MR_aggregateOperation:(MR_nonnull NSString *)collectionOperator onAttribute:(MR_nonnull NSString *)attributeName withPredicate:(MR_nullable NSPredicate *)predicate groupBy:(MR_nullable NSString*)groupingKeyPath inContext:(MR_nonnull NSManagedObjectContext *)context;

/**
 *  Supports aggregating values using a key-value collection operator that can be grouped by an attribute.
 *  See https://developer.apple.com/library/ios/documentation/cocoa/conceptual/KeyValueCoding/Articles/CollectionOperators.html for a list of valid collection operators.
 *
 *  This method is run against the default MagicalRecordStack's context.
 *
 *  @since 2.3.0
 *
 *  @param collectionOperator   Collection operator
 *  @param attributeName        Entity attribute to apply the collection operator to
 *  @param predicate            Predicate to filter results
 *  @param groupingKeyPath      Key path to group results by
 *
 *  @return Results of the collection operator, filtered by the provided predicate and grouped by the provided key path
 */
+ (MR_nullable NSArray *) MR_aggregateOperation:(MR_nonnull NSString *)collectionOperator onAttribute:(MR_nonnull NSString *)attributeName withPredicate:(MR_nullable NSPredicate *)predicate groupBy:(MR_nullable NSString*)groupingKeyPath;

- (MR_nullable instancetype) MR_objectWithMinValueFor:(MR_nonnull NSString *)property;
- (MR_nullable instancetype) MR_objectWithMinValueFor:(MR_nonnull NSString *)property inContext:(MR_nonnull NSManagedObjectContext *)context;

@end
