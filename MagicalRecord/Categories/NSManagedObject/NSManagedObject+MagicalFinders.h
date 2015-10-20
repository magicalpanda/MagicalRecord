//
//  NSManagedObject+MagicalFinders.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>

@interface NSManagedObject (MagicalFinders)

+ (MR_nullable MR_NSArrayOfNSManagedObjects) MR_findAll;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) MR_findAllInContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) MR_findAllSortedBy:(MR_nonnull NSString *)sortTerm ascending:(BOOL)ascending;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) MR_findAllSortedBy:(MR_nonnull NSString *)sortTerm ascending:(BOOL)ascending inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) MR_findAllSortedBy:(MR_nonnull NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(MR_nullable NSPredicate *)searchTerm;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) MR_findAllSortedBy:(MR_nonnull NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(MR_nullable NSPredicate *)searchTerm inContext:(MR_nonnull NSManagedObjectContext *)context;

+ (MR_nullable MR_NSArrayOfNSManagedObjects) MR_findAllWithPredicate:(MR_nullable NSPredicate *)searchTerm;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) MR_findAllWithPredicate:(MR_nullable NSPredicate *)searchTerm inContext:(MR_nonnull NSManagedObjectContext *)context;

+ (MR_nullable instancetype) MR_findFirst;
+ (MR_nullable instancetype) MR_findFirstInContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable instancetype) MR_findFirstWithPredicate:(MR_nullable NSPredicate *)searchTerm;
+ (MR_nullable instancetype) MR_findFirstWithPredicate:(MR_nullable NSPredicate *)searchTerm inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable instancetype) MR_findFirstWithPredicate:(MR_nullable NSPredicate *)searchterm sortedBy:(MR_nullable NSString *)property ascending:(BOOL)ascending;
+ (MR_nullable instancetype) MR_findFirstWithPredicate:(MR_nullable NSPredicate *)searchterm sortedBy:(MR_nullable NSString *)property ascending:(BOOL)ascending inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable instancetype) MR_findFirstWithPredicate:(MR_nullable NSPredicate *)searchTerm andRetrieveAttributes:(MR_nullable NSArray *)attributes;
+ (MR_nullable instancetype) MR_findFirstWithPredicate:(MR_nullable NSPredicate *)searchTerm andRetrieveAttributes:(MR_nullable NSArray *)attributes inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable instancetype) MR_findFirstWithPredicate:(MR_nullable NSPredicate *)searchTerm sortedBy:(MR_nullable NSString *)sortBy ascending:(BOOL)ascending andRetrieveAttributes:(MR_nullable id)attributes, ...;
+ (MR_nullable instancetype) MR_findFirstWithPredicate:(MR_nullable NSPredicate *)searchTerm sortedBy:(MR_nullable NSString *)sortBy ascending:(BOOL)ascending inContext:(MR_nonnull NSManagedObjectContext *)context andRetrieveAttributes:(MR_nullable id)attributes, ...;
+ (MR_nullable instancetype) MR_findFirstByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nonnull id)searchValue;
+ (MR_nullable instancetype) MR_findFirstByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nonnull id)searchValue inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable instancetype) MR_findFirstOrderedByAttribute:(MR_nonnull NSString *)attribute ascending:(BOOL)ascending;
+ (MR_nullable instancetype) MR_findFirstOrderedByAttribute:(MR_nonnull NSString *)attribute ascending:(BOOL)ascending inContext:(MR_nonnull NSManagedObjectContext *)context;

+ (MR_nonnull instancetype) MR_findFirstOrCreateByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nonnull id)searchValue;
+ (MR_nonnull instancetype) MR_findFirstOrCreateByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nonnull id)searchValue inContext:(MR_nonnull NSManagedObjectContext *)context;

+ (MR_nullable MR_NSArrayOfNSManagedObjects) MR_findByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nonnull id)searchValue;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) MR_findByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nonnull id)searchValue inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) MR_findByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nonnull id)searchValue andOrderBy:(MR_nullable NSString *)sortTerm ascending:(BOOL)ascending;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) MR_findByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nonnull id)searchValue andOrderBy:(MR_nullable NSString *)sortTerm ascending:(BOOL)ascending inContext:(MR_nonnull NSManagedObjectContext *)context;

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (MR_nonnull NSFetchedResultsController *) MR_fetchController:(MR_nonnull NSFetchRequest *)request delegate:(MR_nullable id<NSFetchedResultsControllerDelegate>)delegate useFileCache:(BOOL)useFileCache groupedBy:(MR_nullable NSString *)groupKeyPath inContext:(MR_nonnull NSManagedObjectContext *)context;

+ (MR_nonnull NSFetchedResultsController *) MR_fetchAllWithDelegate:(MR_nullable id<NSFetchedResultsControllerDelegate>)delegate;
+ (MR_nonnull NSFetchedResultsController *) MR_fetchAllWithDelegate:(MR_nullable id<NSFetchedResultsControllerDelegate>)delegate inContext:(MR_nonnull NSManagedObjectContext *)context;

+ (MR_nonnull NSFetchedResultsController *) MR_fetchAllSortedBy:(MR_nullable NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(MR_nullable NSPredicate *)searchTerm groupBy:(MR_nullable NSString *)groupingKeyPath delegate:(MR_nullable id<NSFetchedResultsControllerDelegate>)delegate;
+ (MR_nonnull NSFetchedResultsController *) MR_fetchAllSortedBy:(MR_nullable NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(MR_nullable NSPredicate *)searchTerm groupBy:(MR_nullable NSString *)groupingKeyPath delegate:(MR_nullable id<NSFetchedResultsControllerDelegate>)delegate inContext:(MR_nonnull NSManagedObjectContext *)context;

+ (MR_nonnull NSFetchedResultsController *) MR_fetchAllGroupedBy:(MR_nullable NSString *)group withPredicate:(MR_nullable NSPredicate *)searchTerm sortedBy:(MR_nullable NSString *)sortTerm ascending:(BOOL)ascending;
+ (MR_nonnull NSFetchedResultsController *) MR_fetchAllGroupedBy:(MR_nullable NSString *)group withPredicate:(MR_nullable NSPredicate *)searchTerm sortedBy:(MR_nullable NSString *)sortTerm ascending:(BOOL)ascending inContext:(MR_nonnull NSManagedObjectContext *)context;

+ (MR_nonnull NSFetchedResultsController *) MR_fetchAllGroupedBy:(MR_nullable NSString *)group withPredicate:(MR_nullable NSPredicate *)searchTerm sortedBy:(MR_nullable NSString *)sortTerm ascending:(BOOL)ascending delegate:(MR_nullable id<NSFetchedResultsControllerDelegate>)delegate;
+ (MR_nonnull NSFetchedResultsController *) MR_fetchAllGroupedBy:(MR_nullable NSString *)group withPredicate:(MR_nullable NSPredicate *)searchTerm sortedBy:(MR_nullable NSString *)sortTerm ascending:(BOOL)ascending delegate:(MR_nullable id<NSFetchedResultsControllerDelegate>)delegate inContext:(MR_nonnull NSManagedObjectContext *)context;

#endif

@end
