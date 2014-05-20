//
//  NSManagedObject+MagicalFinders.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MagicalRecordDeprecated.h"

@interface NSManagedObject (MagicalFinders)

+ (NSArray *) MR_findAll MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSArray *) MR_findAllInContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchTerm MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

+ (instancetype) MR_findFirst MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (instancetype) MR_findFirstInContext:(NSManagedObjectContext *)context;
+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchTerm MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes inContext:(NSManagedObjectContext *)context;
+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending andRetrieveAttributes:(id)attributes, ... MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context andRetrieveAttributes:(id)attributes, ...;
+ (instancetype) MR_findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (instancetype) MR_findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
+ (instancetype) MR_findFirstOrderedByAttribute:(NSString *)attribute ascending:(BOOL)ascending MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (instancetype) MR_findFirstOrderedByAttribute:(NSString *)attribute ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

+ (instancetype) MR_findFirstOrCreateByAttribute:(NSString *)attribute withValue:(id)searchValue MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (instancetype) MR_findFirstOrCreateByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;

+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) MR_fetchController:(NSFetchRequest *)request delegate:(id<NSFetchedResultsControllerDelegate>)delegate useFileCache:(BOOL)useFileCache groupedBy:(NSString *)groupKeyPath inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *) MR_fetchAllWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSFetchedResultsController *) MR_fetchAllWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *) MR_fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSFetchedResultsController *) MR_fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *) MR_fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSFetchedResultsController *) MR_fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *) MR_fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id<NSFetchedResultsControllerDelegate>)delegate MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSFetchedResultsController *) MR_fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context;

#endif

@end
