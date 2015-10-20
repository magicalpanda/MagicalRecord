//
//  NSManagedObject+MagicalRequests.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>

@interface NSManagedObject (MagicalRequests)

+ (MR_nonnull NSFetchRequest *) MR_createFetchRequest;
+ (MR_nonnull NSFetchRequest *) MR_createFetchRequestInContext:(MR_nonnull NSManagedObjectContext *)context;

+ (MR_nonnull NSFetchRequest *) MR_requestAll;
+ (MR_nonnull NSFetchRequest *) MR_requestAllInContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nonnull NSFetchRequest *) MR_requestAllWithPredicate:(MR_nullable NSPredicate *)searchTerm;
+ (MR_nonnull NSFetchRequest *) MR_requestAllWithPredicate:(MR_nullable NSPredicate *)searchTerm inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nonnull NSFetchRequest *) MR_requestAllWhere:(MR_nonnull NSString *)property isEqualTo:(MR_nonnull id)value;
+ (MR_nonnull NSFetchRequest *) MR_requestAllWhere:(MR_nonnull NSString *)property isEqualTo:(MR_nonnull id)value inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nonnull NSFetchRequest *) MR_requestFirstWithPredicate:(MR_nullable NSPredicate *)searchTerm;
+ (MR_nonnull NSFetchRequest *) MR_requestFirstWithPredicate:(MR_nullable NSPredicate *)searchTerm inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nonnull NSFetchRequest *) MR_requestFirstByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nullable id)searchValue;
+ (MR_nonnull NSFetchRequest *) MR_requestFirstByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nullable id)searchValue inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nonnull NSFetchRequest *) MR_requestAllSortedBy:(MR_nonnull NSString *)sortTerm ascending:(BOOL)ascending;
+ (MR_nonnull NSFetchRequest *) MR_requestAllSortedBy:(MR_nonnull NSString *)sortTerm ascending:(BOOL)ascending inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nonnull NSFetchRequest *) MR_requestAllSortedBy:(MR_nonnull NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(MR_nullable NSPredicate *)searchTerm;
+ (MR_nonnull NSFetchRequest *) MR_requestAllSortedBy:(MR_nonnull NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(MR_nullable NSPredicate *)searchTerm inContext:(MR_nonnull NSManagedObjectContext *)context;

@end
