//
//
//  Created by Saul Mora on 11/15/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MagicalRecord.h"
#import "MagicalRecordDeprecated.h"

#define kMagicalRecordDefaultBatchSize 20

@interface NSManagedObject (MagicalRecord)

/**
 *  If the NSManagedObject subclass calling this method has implemented the `entityName` method, then the return value of that will be used.
 *  If `entityName` is not implemented, then the name of the class is returned.
 *
 *  @return String based name for the entity
 */
+ (NSString *) MR_entityName;

+ (NSUInteger) MR_defaultBatchSize;
+ (void) MR_setDefaultBatchSize:(NSUInteger)newBatchSize;

+ (NSArray *) MR_executeFetchRequest:(NSFetchRequest *)request MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSArray *) MR_executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;
+ (instancetype) MR_executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (instancetype) MR_executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (void) MR_performFetch:(NSFetchedResultsController *)controller;

#endif

+ (NSEntityDescription *) MR_entityDescription MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (NSEntityDescription *) MR_entityDescriptionInContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_propertiesNamed:(NSArray *)properties MR_INTERNALLY_USING_DEPRECATED_METHODS;

+ (instancetype) MR_createEntity MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (instancetype) MR_createEntityInContext:(NSManagedObjectContext *)context;

- (BOOL) MR_deleteEntity MR_INTERNALLY_USING_DEPRECATED_METHODS;
- (BOOL) MR_deleteEntityInContext:(NSManagedObjectContext *)context;

+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;

+ (BOOL) MR_truncateAll MR_INTERNALLY_USING_DEPRECATED_METHODS;
+ (BOOL) MR_truncateAllInContext:(NSManagedObjectContext *)context;

+ (NSArray *) MR_ascendingSortDescriptors:(NSArray *)attributesToSortBy;
+ (NSArray *) MR_descendingSortDescriptors:(NSArray *)attributesToSortBy;

- (instancetype) MR_inContext:(NSManagedObjectContext *)otherContext;
- (instancetype) MR_inThreadContext MR_INTERNALLY_USING_DEPRECATED_METHODS;

@end

@protocol MagicalRecord_MOGenerator <NSObject>

@optional
+ (NSString *)entityName;
- (instancetype) entityInManagedObjectContext:(NSManagedObjectContext *)object;
- (instancetype) insertInManagedObjectContext:(NSManagedObjectContext *)object;

@end

#pragma mark - Deprecated Methods — DO NOT USE
@interface NSManagedObject (MagicalRecordDeprecated)

+ (instancetype) MR_createInContext:(NSManagedObjectContext *)context __attribute__((deprecated("Please use +MR_createEntityInContext: instead.")));
- (BOOL) MR_deleteInContext:(NSManagedObjectContext *)context __attribute__((deprecated("Please use -MR_deleteEntityInContext: instead.")));

@end
