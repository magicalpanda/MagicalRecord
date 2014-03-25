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

+ (instancetype) MR_createEntity;
+ (instancetype) MR_createEntityInContext:(NSManagedObjectContext *)context;

/**
 *  Create a new entity using the provided entity description.
 *
 *  @discussion Useful for creating entities that are not attached to a managed 
 *              object context — just pass a valid entity description and a nil
 *              context.
 *
 *  @param entityDescription Entity description or nil. A valid context must be 
 *                           provided if this parameter is nil.
 *  @param context           Managed Object Context or nil. A valid entity 
 *                           description must be provided if this parameter is nil.
 *
 *  @return a new instance of the current NSManagedObject subclass
 */
+ (instancetype) MR_createEntityWithDescription:(NSEntityDescription *)entityDescription inContext:(NSManagedObjectContext *)context;

/**
 *  Checks the `isDeleted` and `managedObjectContext` methods to determine if
 *    the managed object has been deleted
 *
 *  @return YES if the object has been deleted, otherwise NO
 */
- (BOOL) MR_isEntityDeleted;

- (BOOL) MR_deleteEntity;
- (BOOL) MR_deleteEntityInContext:(NSManagedObjectContext *)context;

+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate;
+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;

+ (BOOL) MR_truncateAll;
+ (BOOL) MR_truncateAllInContext:(NSManagedObjectContext *)context;

+ (NSArray *) MR_ascendingSortDescriptors:(NSArray *)attributesToSortBy;
+ (NSArray *) MR_descendingSortDescriptors:(NSArray *)attributesToSortBy;

- (void) MR_obtainPermanentObjectID;
- (void) MR_refresh;

- (instancetype) MR_inContext:(NSManagedObjectContext *)otherContext;
- (instancetype) MR_inContextIfTemporaryObject:(NSManagedObjectContext *)otherContext;

- (BOOL) MR_isValidForInsert;
- (BOOL) MR_isValidForUpdate;

@end

@interface NSManagedObject (MagicalRecordOptional)

- (void) MR_awakeFromCreation;

@end

@interface NSManagedObject (MagicalRecordDeprecated)

+ (instancetype) MR_createInContext:(NSManagedObjectContext *)context __attribute__((deprecated("Please use +MR_createEntityInContext:")));
- (BOOL) MR_deleteInContext:(NSManagedObjectContext *)context __attribute__((deprecated("Please use +MR_deleteEntityInContext:")));

- (instancetype) MR_inContextIfTempObject:(NSManagedObjectContext *)otherContext __attribute__((deprecated("Please use +MR_inContextIfTemporaryObject:")));

@end

void MRTransferObjectToContextError(NSManagedObject *object);
