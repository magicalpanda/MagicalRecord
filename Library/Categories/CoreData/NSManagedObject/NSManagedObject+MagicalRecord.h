//
//
//  Created by Saul Mora on 11/15/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MagicalRecord.h"
#import "MagicalRecordDeprecated.h"

@interface NSManagedObject (MOGeneratorProvidedMethods)

+ (NSString *)nameOfEntity;

@end

@interface NSManagedObject (MagicalRecord)

/**
 *  If you want to customize the entity name that is returned, you can override either `+ (NSString *) MR_internalEntityName` or `+ (NSString *) nameOfEntity` in your `NSManagedObject` subclasses. `+ (NSString *) nameOfEntity` is declared in the default mogenerator templates.
 *
 *  @return Name of the managed object's entity, or if that is unavailable the name of the managed object's class as a string
 */
+ (NSString *) MR_nameOfEntity;

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

/**
 *  If the object has a temporary object identifier, this method requests a permanent object identifier from the object's current context.
 */
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

+ (NSString *) MR_internalEntityName MRDeprecated("Please use +MR_nameOfEntity");
+ (NSString *) MR_entityName MRDeprecated("Please use +MR_internalEntityName");
+ (instancetype) MR_createInContext:(NSManagedObjectContext *)context MRDeprecated("Please use +MR_createEntityInContext:");
- (BOOL) MR_deleteInContext:(NSManagedObjectContext *)context MRDeprecated("Please use +MR_deleteEntityInContext:");

- (instancetype) MR_inContextIfTempObject:(NSManagedObjectContext *)otherContext MRDeprecated("Please use +MR_inContextIfTemporaryObject:");

@end

void MRTransferObjectToContextError(NSManagedObject *object);
