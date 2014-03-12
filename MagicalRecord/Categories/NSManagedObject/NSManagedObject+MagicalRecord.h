//
//
//  Created by Saul Mora on 11/15/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MagicalRecord.h"

#define kMagicalRecordDefaultBatchSize 20

@interface NSManagedObject (MagicalRecord)

+ (NSUInteger) MR_defaultBatchSize;
+ (void) MR_setDefaultBatchSize:(NSUInteger)newBatchSize;

+ (NSArray *) MR_executeFetchRequest:(NSFetchRequest *)request;
+ (NSArray *) MR_executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;
+ (instancetype) MR_executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request;
+ (instancetype) MR_executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (void) MR_performFetch:(NSFetchedResultsController *)controller;

#endif

+ (NSEntityDescription *) MR_entityDescription;
+ (NSEntityDescription *) MR_entityDescriptionInContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_propertiesNamed:(NSArray *)properties;

+ (instancetype) MR_createEntity;
+ (instancetype) MR_createInContext:(NSManagedObjectContext *)context;
- (BOOL) MR_deleteEntity;
- (BOOL) MR_deleteInContext:(NSManagedObjectContext *)context;

+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate;
+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;

+ (BOOL) MR_truncateAll;
+ (BOOL) MR_truncateAllInContext:(NSManagedObjectContext *)context;

+ (NSArray *) MR_ascendingSortDescriptors:(NSArray *)attributesToSortBy;
+ (NSArray *) MR_descendingSortDescriptors:(NSArray *)attributesToSortBy;

- (instancetype) MR_inContext:(NSManagedObjectContext *)otherContext;
- (instancetype) MR_inThreadContext;

@end

@protocol MagicalRecord_MOGenerator <NSObject>

@optional
- (instancetype) entityInManagedObjectContext:(NSManagedObjectContext *)object;
- (instancetype) insertInManagedObjectContext:(NSManagedObjectContext *)object;

@end
