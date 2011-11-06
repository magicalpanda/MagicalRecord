//
//
//  Created by Saul Mora on 11/15/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MagicalRecordHelpers.h"

#define kMagicalRecordDefaultBatchSize 20

#ifdef MR_SHORTHAND
	#define MR_ascendingSortDescriptors ascendingSortDescriptors
	#define MR_countOfEntities countOfEntities
	#define MR_countOfEntitiesWithContext countOfEntitiesWithContext
	#define MR_countOfEntitiesWithPredicate countOfEntitiesWithPredicate
	#define MR_createEntity createEntity
	#define MR_createFetchRequest createFetchRequest
	#define MR_createFetchRequestInContext createFetchRequestInContext
	#define MR_createInContext createInContext
	#define MR_defaultBatchSize defaultBatchSize
	#define MR_deleteAllMatchingPredicate deleteAllMatchingPredicate
	#define MR_deleteEntity deleteEntity
	#define MR_deleteInContext deleteInContext
	#define MR_descendingSortDescriptors descendingSortDescriptors
	#define MR_entityDescription entityDescription
	#define MR_entityDescriptionInContext entityDescriptionInContext
	#define MR_executeFetchRequest executeFetchRequest
	#define MR_executeFetchRequestAndReturnFirstObject executeFetchRequestAndReturnFirstObject
	#define MR_fetchAllSortedBy fetchAllSortedBy
	#define MR_fetchRequest fetchRequest
	#define MR_fetchRequestAllGroupedBy fetchRequestAllGroupedBy
	#define MR_findAll findAll
	#define MR_findAllInContext findAllInContext
	#define MR_findAllSortedBy findAllSortedBy
	#define MR_findAllWithPredicate findAllWithPredicate
	#define MR_findByAttribute findByAttribute
	#define MR_findFirst findFirst
	#define MR_findFirstByAttribute findFirstByAttribute
	#define MR_findFirstInContext findFirstInContext
	#define MR_findFirstWithPredicate findFirstWithPredicate
	#define MR_hasAtLeastOneEntity hasAtLeastOneEntity
	#define MR_hasAtLeastOneEntityInContext hasAtLeastOneEntityInContext
	#define MR_inContext inContext
	#define MR_inThreadContext inThreadContext
	#define MR_numberOfEntities numberOfEntities
	#define MR_numberOfEntitiesWithContext numberOfEntitiesWithContext
	#define MR_numberOfEntitiesWithPredicate numberOfEntitiesWithPredicate
	#define MR_objectWithMinValueFor objectWithMinValueFor
	#define MR_performFetch performFetch
	#define MR_propertiesNamed propertiesNamed
	#define MR_requestAll requestAll
	#define MR_requestAllInContext requestAllInContext
	#define MR_requestAllSortedBy requestAllSortedBy
	#define MR_requestAllSortedBy requestAllSortedBy
	#define MR_requestAllWhere requestAllWhere
	#define MR_requestAllWithPredicate requestAllWithPredicate
	#define MR_requestFirstByAttribute requestFirstByAttribute
	#define MR_requestFirstWithPredicate requestFirstWithPredicate
	#define MR_setDefaultBatchSize setDefaultBatchSize
	#define MR_truncateAll truncateAll
	#define MR_truncateAllInContext truncateAllInContext
#endif

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
+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

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

- (id) MR_inContext:(NSManagedObjectContext *)otherContext;
- (id) MR_inThreadContext;

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED

+ (void) MR_performFetch:(NSFetchedResultsController *)controller;

+ (NSFetchedResultsController *) MR_fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath;
+ (NSFetchedResultsController *) MR_fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *) MR_fetchRequest:(NSFetchRequest *)request groupedBy:(NSString *)group;
+ (NSFetchedResultsController *) MR_fetchRequest:(NSFetchRequest *)request groupedBy:(NSString *)group inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *) MR_fetchRequestAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSFetchedResultsController *) MR_fetchRequestAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

#endif

@end
