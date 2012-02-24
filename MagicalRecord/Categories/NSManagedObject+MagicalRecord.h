//
//
//  Created by Saul Mora on 11/15/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MagicalRecordHelpers.h"

#define kMagicalRecordDefaultBatchSize 20

@interface NSManagedObject (MagicalRecord)

+ (NSUInteger) MR_defaultBatchSize;
+ (void) MR_setDefaultBatchSize:(NSUInteger)newBatchSize;

+ (NSArray *) MR_executeFetchRequest:(NSFetchRequest *)request;
+ (NSArray *) MR_executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;
+ (id) MR_executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request;
+ (id) MR_executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;


+ (NSFetchRequest *) MR_createFetchRequest;
+ (NSFetchRequest *) MR_createFetchRequestInContext:(NSManagedObjectContext *)context;
+ (NSEntityDescription *) MR_entityDescription;
+ (NSEntityDescription *) MR_entityDescriptionInContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_propertiesNamed:(NSArray *)properties;

+ (id) MR_createEntity;
+ (id) MR_createInContext:(NSManagedObjectContext *)context;
- (BOOL) MR_deleteEntity;
- (BOOL) MR_deleteInContext:(NSManagedObjectContext *)context;

+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate;
+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;

+ (BOOL) MR_truncateAll;
+ (BOOL) MR_truncateAllInContext:(NSManagedObjectContext *)context;

+ (NSArray *) MR_ascendingSortDescriptors:(NSArray *)attributesToSortBy;
+ (NSArray *) MR_descendingSortDescriptors:(NSArray *)attributesToSortBy;

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

+ (NSFetchRequest *) MR_requestAll;
+ (NSFetchRequest *) MR_requestAllInContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) MR_requestAllWithPredicate:(NSPredicate *)searchTerm;
+ (NSFetchRequest *) MR_requestAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) MR_requestAllWhere:(NSString *)property isEqualTo:(id)value;
+ (NSFetchRequest *) MR_requestAllWhere:(NSString *)property isEqualTo:(id)value inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) MR_requestFirstWithPredicate:(NSPredicate *)searchTerm;
+ (NSFetchRequest *) MR_requestFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) MR_requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (NSFetchRequest *) MR_requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

+ (NSArray *) MR_findAll;
+ (NSArray *) MR_findAllInContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchTerm;
+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

- (id) MR_objectWithMinValueFor:(NSString *)property;
- (id) MR_objectWithMinValueFor:(NSString *)property inContext:(NSManagedObjectContext *)context;

+ (id) MR_findFirst;
+ (id) MR_findFirstInContext:(NSManagedObjectContext *)context;
+ (id) MR_findFirstWithPredicate:(NSPredicate *)searchTerm;
+ (id) MR_findFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (id) MR_findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending;
+ (id) MR_findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (id) MR_findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes;
+ (id) MR_findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes inContext:(NSManagedObjectContext *)context;
+ (id) MR_findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending andRetrieveAttributes:(id)attributes, ...;
+ (id) MR_findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context andRetrieveAttributes:(id)attributes, ...;

+ (id) MR_findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (id) MR_findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

+ (NSNumber *)MR_aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (NSNumber *)MR_aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate;

- (id) MR_inContext:(NSManagedObjectContext *)otherContext;
- (id) MR_inThreadContext;


#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (void) MR_performFetch:(NSFetchedResultsController *)controller;

+ (NSFetchedResultsController *) MR_fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate;
+ (NSFetchedResultsController *) MR_fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *) MR_fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSFetchedResultsController *) MR_fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *) MR_fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id<NSFetchedResultsControllerDelegate>)delegate;
+ (NSFetchedResultsController *) MR_fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context;

#endif

@end

