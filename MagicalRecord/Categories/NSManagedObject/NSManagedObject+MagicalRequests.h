//
//  NSManagedObject+MagicalRequests.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MagicalRecordDeprecated.h"

@interface NSManagedObject (MagicalRequests)

+ (NSFetchRequest *) MR_createFetchRequest MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSFetchRequest *) MR_createFetchRequestInContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *) MR_requestAll MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSFetchRequest *) MR_requestAllInContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) MR_requestAllWithPredicate:(NSPredicate *)searchTerm MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSFetchRequest *) MR_requestAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) MR_requestAllWhere:(NSString *)property isEqualTo:(id)value MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSFetchRequest *) MR_requestAllWhere:(NSString *)property isEqualTo:(id)value inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) MR_requestFirstWithPredicate:(NSPredicate *)searchTerm MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSFetchRequest *) MR_requestFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) MR_requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSFetchRequest *) MR_requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;


@end
