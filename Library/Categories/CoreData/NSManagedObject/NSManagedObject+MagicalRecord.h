//
//
//  Created by Saul Mora on 11/15/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MagicalRecord.h"

@interface NSManagedObject (MagicalRecord)


+ (NSString *) MR_entityName;

+ (NSArray *) MR_executeFetchRequest:(NSFetchRequest *)request;
+ (NSArray *) MR_executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;
+ (id) MR_executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request;
+ (id) MR_executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;

+ (NSEntityDescription *) MR_entityDescription;
+ (NSEntityDescription *) MR_entityDescriptionInContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_propertiesNamed:(NSArray *)properties;

+ (id) MR_createEntity;
+ (id) MR_createInContext:(NSManagedObjectContext *)context;
- (BOOL) MR_deleteEntity;
- (BOOL) MR_deleteInContext:(NSManagedObjectContext *)context;

+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate;
+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;

+ (BOOL) MR_truncateAll;
+ (BOOL) MR_truncateAllInContext:(NSManagedObjectContext *)context;

+ (NSArray *) MR_ascendingSortDescriptors:(NSArray *)attributesToSortBy;
+ (NSArray *) MR_descendingSortDescriptors:(NSArray *)attributesToSortBy;

- (void) MR_obtainPermanentObjectID;
- (void) MR_refresh;
- (id) MR_inContext:(NSManagedObjectContext *)otherContext;

@end

void MRTransferObjectToContextError(NSManagedObject *object);
