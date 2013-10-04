//
//  NSManagedObject+MagicalRequests.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (MagicalRequests)

+ (NSUInteger) MR_defaultBatchSize;
+ (void) MR_setDefaultBatchSize:(NSUInteger)newBatchSize;

+ (NSFetchRequest *) MR_requestAll;
+ (NSFetchRequest *) MR_requestAllWithPredicate:(NSPredicate *)searchTerm;
+ (NSFetchRequest *) MR_requestAllWhere:(NSString *)property isEqualTo:(id)value;
+ (NSFetchRequest *) MR_requestFirstWithPredicate:(NSPredicate *)searchTerm;
+ (NSFetchRequest *) MR_requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;

@end
