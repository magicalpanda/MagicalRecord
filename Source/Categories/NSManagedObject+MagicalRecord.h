//
//
//  Created by Saul Mora on 11/15/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MagicalRecordHelpers.h"

#define kMagicalRecordDefaultBatchSize 20

@interface NSManagedObject (MagicalRecord)

+ (NSUInteger) defaultBatchSize;
+ (void) setDefaultBatchSize:(NSUInteger)newBatchSize;

+ (NSArray *) executeFetchRequest:(NSFetchRequest *)request;
+ (NSArray *) executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;
+ (id) executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request;
+ (id) executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;


+ (NSFetchRequest *)createFetchRequest;
+ (NSFetchRequest *)createFetchRequestInContext:(NSManagedObjectContext *)context;
+ (NSEntityDescription *)entityDescription;
+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context;
+ (NSArray *)propertiesNamed:(NSArray *)properties;

+ (id) createEntity;
+ (id) createInContext:(NSManagedObjectContext *)context;
- (BOOL) deleteEntity;
- (BOOL) deleteInContext:(NSManagedObjectContext *)context;

+ (BOOL) truncateAll;
+ (BOOL) truncateAllInContext:(NSManagedObjectContext *)context;

+ (NSArray *) ascendingSortDescriptors:(NSArray *)attributesToSortBy;
+ (NSArray *) descendingSortDescriptors:(NSArray *)attributesToSortBy;

+ (NSNumber *) numberOfEntities;
+ (NSNumber *) numberOfEntitiesWithContext:(NSManagedObjectContext *)context;
+ (NSNumber *) numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm;
+ (NSNumber *) numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

+ (NSUInteger) countOfEntities;
+ (NSUInteger) countOfEntitiesWithContext:(NSManagedObjectContext *)context;
+ (NSUInteger) countOfEntitiesWithPredicate:(NSPredicate *)searchFilter;
+ (NSUInteger) countOfEntitiesWithPredicate:(NSPredicate *)searchFilter inContext:(NSManagedObjectContext *)context;

+ (BOOL) hasAtLeastOneEntity;
+ (BOOL) hasAtLeastOneEntityInContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *) requestAll;
+ (NSFetchRequest *) requestAllInContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) requestAllWithPredicate:(NSPredicate *)searchTerm;
+ (NSFetchRequest *) requestAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) requestAllWhere:(NSString *)property isEqualTo:(id)value;
+ (NSFetchRequest *) requestAllWhere:(NSString *)property isEqualTo:(id)value inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) requestFirstWithPredicate:(NSPredicate *)searchTerm;
+ (NSFetchRequest *) requestFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (NSFetchRequest *) requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

+ (NSArray *)findAll;
+ (NSArray *)findAllInContext:(NSManagedObjectContext *)context;
+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

+ (NSArray *)findAllWithPredicate:(NSPredicate *)searchTerm;
+ (NSArray *)findAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

- (id)objectWithMinValueFor:(NSString *)property;
- (id)objectWithMinValueFor:(NSString *)property inContext:(NSManagedObjectContext *)context;

+ (id)findFirst;
+ (id)findFirstInContext:(NSManagedObjectContext *)context;
+ (id)findFirstWithPredicate:(NSPredicate *)searchTerm;
+ (id)findFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (id)findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending;
+ (id)findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (id)findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes;
+ (id)findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes inContext:(NSManagedObjectContext *)context;
+ (id)findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending andRetrieveAttributes:(id)attributes, ...;
+ (id)findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context andRetrieveAttributes:(id)attributes, ...;

+ (id)findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (id)findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
+ (NSArray *)findByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (NSArray *)findByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
+ (NSArray *)findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSArray *)findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;


- (id) inContext:(NSManagedObjectContext *)otherContext;
- (id) inThreadContext;

#if (TARGET_OS_IPHONE)

+ (void) performFetch:(NSFetchedResultsController *)controller;

+ (NSFetchedResultsController *) fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath;
+ (NSFetchedResultsController *) fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *) fetchRequest:(NSFetchRequest *)request groupedBy:(NSString *)group;
+ (NSFetchedResultsController *) fetchRequest:(NSFetchRequest *)request groupedBy:(NSString *)group inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *) fetchRequestAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSFetchedResultsController *) fetchRequestAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

#endif


@end

/*
 #ifdef MR_SHORTHAND
 
 #define defaultBatchSize        MR_defaultBatchSize
 #define setDefaultBatchSize     MR_setDefaultBatchSize
 
 #define createFetchRequest      MR_createFetchRequest
 #define executeFetchRequest     MR_executeFetchRequest
 
 #define requestAll              MR_requestAll
 #define trucateAll              MR_truncateAll
 
 #define numberOfEntities        MR_numberOfEntities
 #define hasAtLeastOneEntity     MR_hasAtLeastOneEntity
 
 #define findAll                 MR_findAll
 #define findByAttribute         MR_findByAttribute
 
 #define findFirst               MR_findFirst
 #define findFirstByAttribute    MR_findFirstByAttribute
 
 #define fetchAllSortedBy        MR_fetchAllSortedBy
 #define fetchRequest            MR_fetchRequest
 
 #define inContext               MR_inContext
 #define inThreadContext         MR_inThreadContext
 
 #endif
 */
