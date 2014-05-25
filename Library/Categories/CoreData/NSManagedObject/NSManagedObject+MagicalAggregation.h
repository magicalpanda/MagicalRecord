//
//  NSManagedObject+MagicalAggregation.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

/**
 Category methods that make aggregating and counting managed objects easier.

 @since Available in v2.0 and later.
 */
@interface NSManagedObject (MagicalAggregation)

+ (NSNumber *) MR_numberOfEntities;
+ (NSNumber *) MR_numberOfEntitiesWithContext:(NSManagedObjectContext *)context;
+ (NSNumber *) MR_numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm;
+ (NSNumber *) MR_numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

/**
 Count of entities for the current class in the default stack's context.

 @return Count of entities

 @since Available in v2.0 and later.
 */
+ (NSUInteger) MR_countOfEntities;

/**
 Count of entities for the current class in the supplied context.

 @param context Managed object context

 @return Count of entities

 @since Available in v2.0 and later.
 */
+ (NSUInteger) MR_countOfEntitiesWithContext:(NSManagedObjectContext *)context;

/**
 Count of entities for the current class matching the supplied predicate in the default stack's context.

 @param predicate Predicate to evaluate objects against

 @return Count of entities

 @since Available in v2.0 and later.
 */
+ (NSUInteger) MR_countOfEntitiesWithPredicate:(NSPredicate *)predicate;

/**
 Count of entities for the current class matching the supplied predicate in the supplied context.

 @param predicate Predicate to evaluate objects against
 @param context   Managed object context

 @return Count of entities

 @since Available in v2.0 and later.
 */
+ (NSUInteger) MR_countOfEntitiesWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;

/**
 Check that there is at least one entity matching the current class in the default stack's context.

 @return `YES` if there is at least on entity, otherwise `NO`.

 @since Available in v2.0 and later.
 */
+ (BOOL) MR_hasAtLeastOneEntity;

/**
 Check that there is at least one entity matching the current class in the supplied context.

 @param context Managed object context

 @return `YES` if there is at least on entity, otherwise `NO`.

 @since Available in v2.0 and later.
 */
+ (BOOL) MR_hasAtLeastOneEntityInContext:(NSManagedObjectContext *)context;

- (id) MR_minValueFor:(NSString *)property;
- (id) MR_maxValueFor:(NSString *)property;

+ (id) MR_aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (id) MR_aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate;

/**
 Supports aggregating values using a key-value collection operator that can be grouped by an attribute.
 See https://developer.apple.com/library/ios/documentation/cocoa/conceptual/KeyValueCoding/Articles/CollectionOperators.html for a list of valid collection operators.

 @param collectionOperator   Collection operator
 @param attributeName        Entity attribute to apply the collection operator to
 @param predicate            Predicate to filter results
 @param groupingKeyPath      Key path to group results by
 @param context              Context to perform the request in

 @return Results of the collection operator, filtered by the provided predicate and grouped by the provided key path
 
 @since Available in v2.3 and later.
 */
+ (NSArray *) MR_aggregateOperation:(NSString *)collectionOperator onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate groupBy:(NSString*)groupingKeyPath inContext:(NSManagedObjectContext *)context;

/**
 Supports aggregating values using a key-value collection operator that can be grouped by an attribute.

 See https://developer.apple.com/library/ios/documentation/cocoa/conceptual/KeyValueCoding/Articles/CollectionOperators.html for a list of valid collection operators. 

 This method is run against the default MagicalRecordStack's context.

 @param collectionOperator   Collection operator
 @param attributeName        Entity attribute to apply the collection operator to
 @param predicate            Predicate to filter results
 @param groupingKeyPath      Key path to group results by

 @return Results of the collection operator, filtered by the provided predicate and grouped by the provided key path
 
 @since Available in v2.3 and later.
 */
+ (NSArray *) MR_aggregateOperation:(NSString *)collectionOperator onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate groupBy:(NSString*)groupingKeyPath;

- (id) MR_objectWithMinValueFor:(NSString *)property;
- (id) MR_objectWithMinValueFor:(NSString *)property inContext:(NSManagedObjectContext *)context;

@end
