//
//  NSManagedObject+MagicalRequests.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

/**
 Category methods to make creating fetch requests easier.

 @since Available in v1.8 and later.
 */
@interface NSManagedObject (MagicalRequests)

/**
 @name Global Options
 */

/**
 The current default batch size.
 
 Defaults to 20.

 @return Current batch size

 @since Available in v2.3 and later.
 */
+ (NSUInteger) MR_defaultBatchSize;

/**
 Sets the number of items to fetch by default.

 @param newBatchSize Number of items to fetch by default.

 @since Available in v2.3 and later.
 */
+ (void) MR_setDefaultBatchSize:(NSUInteger)newBatchSize;

/**
 @name Fetch Request Creation
 */

/**
 Initializes a fetch request that queries a context for all entities of the current type.

 @return Fetch request

 @since Available in v1.8 and later.
 */
+ (NSFetchRequest *) MR_requestAll;

/**
 Initializes a fetch request that queries a context for all entities of the current type that match the supplied predicate.

 @param predicate Predicate to evaluate objects against

 @return Fetch request

 @since Available in v1.8 and later.
 */
+ (NSFetchRequest *) MR_requestAllWithPredicate:(NSPredicate *)predicate;

/**
 Initializes a fetch request that queries a context for all entities of the current type where the supplied property has the supplied value.

 @param attributeName Attribute or property name to match the supplied value against.
 @param value         Value to match against.

 @return Fetch request

 @since Available in v1.8 and later.
 */
+ (NSFetchRequest *) MR_requestAllWhere:(NSString *)attributeName isEqualTo:(id)value;

/**
 Initializes a fetch request that queries a context for the first entity of the current type that matches the supplied predicate.

 @param predicate Predicate to evaluate objects against

 @return Fetch request

 @since Available in v1.8 and later.
 */
+ (NSFetchRequest *) MR_requestFirstWithPredicate:(NSPredicate *)predicate;

/**
 Initializes a fetch request that queries a context for the first entity of the current type where the supplied property has the supplied value.

 @param attributeName Attribute or property name to match the supplied value against.
 @param value         Value to match against.

 @return Fetch request

 @since Available in v1.8 and later.
 */
+ (NSFetchRequest *) MR_requestFirstByAttribute:(NSString *)attributeName withValue:(id)value;

/**
 Initializes a fetch request that queries a context for all entities of the current type, sorted by the supplied sort term in the supplied order.

 @param sortTerm  Attribute name to sort by.
 @param ascending `YES` if the attribute should be sorted ascending, `NO` for descending.

 @return Fetch request

 @since Available in v1.8 and later.
 */
+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;

/**
 Initializes a fetch request that queries a context for all entities of the current type, sorted by the supplied sort term in the supplied order that match the supplied predicate.

 @param sortTerm  Attribute name to sort by.
 @param ascending `YES` if the attribute should be sorted ascending, `NO` for descending.
 @param predicate Predicate to evaluate objects against

 @return Fetch request

 @since Available in v1.8 and later.
 */
+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)predicate;

@end
