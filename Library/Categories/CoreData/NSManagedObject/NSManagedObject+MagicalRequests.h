//
//  NSManagedObject+MagicalRequests.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (MagicalRequests)

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
 Initializes a fetch request that queries a context for all entities of the current type.

 @return Fetch request

 @since Available in v2.0 and later.
 */
+ (NSFetchRequest *) MR_requestAll;
+ (NSFetchRequest *) MR_requestAllWithPredicate:(NSPredicate *)searchTerm;
+ (NSFetchRequest *) MR_requestAllWhere:(NSString *)property isEqualTo:(id)value;
+ (NSFetchRequest *) MR_requestFirstWithPredicate:(NSPredicate *)searchTerm;
+ (NSFetchRequest *) MR_requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;

@end
