//
//  NSManagedObject+MagicalFinders.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import <CoreData/CoreData.h>

@interface NSObject (MagicalFindersExtentions)

- (NSString *) fetchedResultsControllerCacheName;

@end


@interface NSManagedObject (MagicalFinders)

+ (NSArray *) MR_findAll;
+ (NSArray *) MR_findAllInContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchTerm;
+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

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
+ (id) MR_findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue orderedBy:(NSString *)orderedBy ascending:(BOOL)ascending;
+ (id) MR_findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue orderedBy:(NSString *)orderedBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (id) MR_findFirstOrderedByAttribute:(NSString *)attribute ascending:(BOOL)ascending;
+ (id) MR_findFirstOrderedByAttribute:(NSString *)attribute ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

+ (id) MR_findLargestValueForAttribute:(NSString *)attribute;
+ (id) MR_findLargestValueForAttribute:(NSString *)attribute inContext:(NSManagedObjectContext *)context;
+ (id) MR_findLargestValueForAttribute:(NSString *)attribute withPredicate:(NSPredicate *)predicate;
+ (id) MR_findLargestValueForAttribute:(NSString *)attribute withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (id) MR_findSmallestValueForAttribute:(NSString *)attribute;
+ (id) MR_findSmallestValueForAttribute:(NSString *)attribute inContext:(NSManagedObjectContext *)context;

+ (id) MR_selectAttribute:(NSString *)attribute ascending:(BOOL)ascending;
+ (id) MR_selectAttribute:(NSString *)attribute ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (id) MR_selectAttribute:(NSString *)attribute ascending:(BOOL)ascending withPredicate:(NSPredicate *)predicate;
+ (id) MR_selectAttribute:(NSString *)attribute ascending:(BOOL)ascending withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;

+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

@end
