//
//  NSManagedObject+MagicalFetching.h
//  MagicalRecord
//
//  Created by Saul Mora on 9/15/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

/**
 Category methods on NSManagedObject to make working with NSFetchedResultsControllers easier.

 @since Available in v3.0 and later.
 */
NS_ASSUME_NONNULL_BEGIN
@interface NSManagedObject (MagicalFetching)

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *)MR_fetchController:(NSFetchRequest *)request delegate:(id<NSFetchedResultsControllerDelegate> __nullable)delegate useFileCache:(BOOL)useFileCache groupedBy:(NSString *__nullable)groupKeyPath inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)MR_fetchAllSortedBy:(NSString *)sortTerm
                                          ascending:(BOOL)ascending
                                      withPredicate:(NSPredicate *__nullable)searchTerm
                                            groupBy:(NSString *__nullable)groupingKeyPath
                                           delegate:(id<NSFetchedResultsControllerDelegate> __nullable)delegate;
+ (NSFetchedResultsController *)MR_fetchAllSortedBy:(NSString *)sortTerm
                                          ascending:(BOOL)ascending
                                      withPredicate:(NSPredicate *__nullable)searchTerm
                                            groupBy:(NSString *__nullable)groupingKeyPath
                                           delegate:(id<NSFetchedResultsControllerDelegate> __nullable)delegate
                                          inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)MR_fetchAllGroupedBy:(NSString *__nullable)group withPredicate:(NSPredicate *__nullable)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSFetchedResultsController *)MR_fetchAllGroupedBy:(NSString *__nullable)group withPredicate:(NSPredicate *__nullable)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)MR_fetchAllGroupedBy:(NSString *__nullable)group withPredicate:(NSPredicate *__nullable)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id<NSFetchedResultsControllerDelegate> __nullable)delegate;
+ (NSFetchedResultsController *)MR_fetchAllGroupedBy:(NSString *__nullable)group withPredicate:(NSPredicate *__nullable)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id<NSFetchedResultsControllerDelegate> __nullable)delegate inContext:(NSManagedObjectContext *)context;

#endif

@end
NS_ASSUME_NONNULL_END
