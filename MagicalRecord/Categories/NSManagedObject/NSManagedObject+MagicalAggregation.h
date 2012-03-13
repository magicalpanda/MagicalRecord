//
//  NSManagedObject+MagicalAggregation.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (MagicalAggregation)

+ (NSNumber *) MR_numberOfEntities;
+ (NSNumber *) MR_numberOfEntitiesWithContext:(NSManagedObjectContext *)context;
+ (NSNumber *) MR_numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm;
+ (NSNumber *) MR_numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

+ (NSUInteger) MR_countOfEntities;
+ (NSUInteger) MR_countOfEntitiesWithContext:(NSManagedObjectContext *)context;
+ (NSUInteger) MR_countOfEntitiesWithPredicate:(NSPredicate *)searchFilter;
+ (NSUInteger) MR_countOfEntitiesWithPredicate:(NSPredicate *)searchFilter inContext:(NSManagedObjectContext *)context;

+ (BOOL) MR_hasAtLeastOneEntity;
+ (BOOL) MR_hasAtLeastOneEntityInContext:(NSManagedObjectContext *)context;

+ (NSNumber *)MR_aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (NSNumber *)MR_aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate;

- (id) MR_objectWithMinValueFor:(NSString *)property;
- (id) MR_objectWithMinValueFor:(NSString *)property inContext:(NSManagedObjectContext *)context;

@end
