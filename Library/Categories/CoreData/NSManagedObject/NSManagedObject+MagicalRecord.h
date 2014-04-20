//
//
//  Created by Saul Mora on 11/15/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MagicalRecord.h"
#import "MagicalRecordMOGeneratorProtocol.h"
#import "MagicalRecordDeprecated.h"

@protocol MagicalRecordManagedObjectProtocol <NSObject>

@optional
- (void) MR_awakeFromCreation;

@end

/**
 Categories that simplify working with the NSManagedObject class.

 @since 1.0.0
 */
@interface NSManagedObject (MagicalRecord) <MagicalRecordMOGeneratorProtocol, MagicalRecordManagedObjectProtocol>

///--------------------------
/// @name Entity Information
///--------------------------

/**
 If you want to customize the entity name that is returned, you can override either `+ (NSString *) MR_entityName` or `+ (NSString *) entityName` in your `NSManagedObject` subclasses. `+ (NSString *) entityName` is declared in the default mogenerator templates.

 @return Name of the managed object's entity, or if that is unavailable the name of the managed object's class as a string

 @since 2.0.0
 */
+ (NSString *) MR_entityName;

+ (NSEntityDescription *) MR_entityDescription;
+ (NSEntityDescription *) MR_entityDescriptionInContext:(NSManagedObjectContext *)context;

+ (NSArray *) MR_propertiesNamed:(NSArray *)properties;

///----------------------
/// @name Fetch Requests
///----------------------

+ (NSArray *) MR_executeFetchRequest:(NSFetchRequest *)request;
+ (NSArray *) MR_executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;
+ (id) MR_executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request;
+ (id) MR_executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;

///-------------------------
/// @name Creating Entities
///-------------------------

+ (instancetype) MR_createEntity;
+ (instancetype) MR_createEntityInContext:(NSManagedObjectContext *)context;

/**
 Create a new entity using the provided entity description.

 @discussion Useful for creating entities that are not attached to a managed object context — just pass a valid entity description and a nil context.

 @param entityDescription 
    Entity description or nil. A valid context must be provided if this parameter is nil.
 @param context 
    Managed Object Context or nil. A valid entity description must be provided if this parameter is nil.

 @return a new instance of the current NSManagedObject subclass
 */
+ (instancetype) MR_createEntityWithDescription:(NSEntityDescription *)entityDescription inContext:(NSManagedObjectContext *)context;

///-------------------------
/// @name Deleting Entities
///-------------------------

/**
 Checks the `isDeleted` and `managedObjectContext` methods to determine if the managed object has been deleted.

 @return YES if the object has been deleted, otherwise NO

 @since 2.3.0
 */
- (BOOL) MR_isEntityDeleted;

- (BOOL) MR_deleteEntity;
- (BOOL) MR_deleteEntityInContext:(NSManagedObjectContext *)context;

+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate;
+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;

+ (BOOL) MR_truncateAll;
+ (BOOL) MR_truncateAllInContext:(NSManagedObjectContext *)context;

///------------------------
/// @name Sorting Entities
///------------------------

+ (NSArray *) MR_ascendingSortDescriptors:(NSArray *)attributesToSortBy;
+ (NSArray *) MR_descendingSortDescriptors:(NSArray *)attributesToSortBy;
+ (NSArray *) MR_sortAscending:(BOOL)ascending attributes:(NSArray *)attributesToSortBy;

///-------------------------------
/// @name Working Across Contexts
///-------------------------------

/**
 If the object has a temporary object identifier, this method requests a permanent object identifier from the object's current context.

 @since 2.1.0
 */
- (void) MR_obtainPermanentObjectID;

/**
 Updates the persistent properties of a managed object to use the latest values from the persistent store.

 @since 2.1.0
 */
- (void) MR_refresh;

/**
 Retrieves an instance of the current managed object from another context.

 If the current managed object's context matches `otherContext`, self will be returned immediately.

 If the current managed object has a temporary ID, an exception with name "NSObjectInaccessibleException" will be thrown.

 @param otherContext Valid managed object context
 @return Managed object from the supplied context
 @since 2.1.0
 */
- (instancetype) MR_inContext:(NSManagedObjectContext *)otherContext;

/**
 If the current managed object has a temporary ID, returns self immediately otherwise calls `- MR_inContext:` on self with the supplied managed object context.

 @param otherContext Valid managed object context
 @return Managed object from the supplied context
 */
- (instancetype) MR_inContextIfTemporaryObject:(NSManagedObjectContext *)otherContext;

///------------------
/// @name Validation
///------------------

- (BOOL) MR_isValidForInsert;
- (BOOL) MR_isValidForUpdate;

@end

@interface NSManagedObject (MagicalRecordDeprecated)

+ (instancetype) MR_createInContext:(NSManagedObjectContext *)context MRDeprecated("Please use +MR_createEntityInContext:");
- (BOOL) MR_deleteInContext:(NSManagedObjectContext *)context MRDeprecated("Please use +MR_deleteEntityInContext:");

- (instancetype) MR_inContextIfTempObject:(NSManagedObjectContext *)otherContext MRDeprecated("Please use +MR_inContextIfTemporaryObject:");

@end
