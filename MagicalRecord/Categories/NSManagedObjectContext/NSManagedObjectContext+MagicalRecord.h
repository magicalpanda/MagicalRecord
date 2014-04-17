//
//  NSManagedObjectContext+MagicalRecord.h
//
//  Created by Saul Mora on 11/23/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "MagicalRecord.h"
#import "MagicalRecordDeprecated.h"

@interface NSManagedObjectContext (MagicalRecord)

#pragma mark - Setup

/**
 *  Initializes MagicalRecord's default contexts using the provided persistent store coordinator.
 *
 *  @param coordinator Persistent Store Coordinator
 */
+ (void) MR_initializeDefaultContextWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;

#pragma mark - Default Contexts
/**
 *  @discussion Use this context for making and saving changes. All saves will be merged into the context returned by `MR_defaultContext` as well.
 *
 *  @return Private context used for saving changes to disk on a background thread
 */
+ (NSManagedObjectContext *) MR_rootSavingContext;

/**
 *  @discussion Please do not use this context for saving changes, as it will block the main thread when doing so.
 *
 *  @return Main queue context that can be observed for changes
 */
+ (NSManagedObjectContext *) MR_defaultContext;

#pragma mark - Context Creation

/**
 *  Creates and returns a new managed object context of type `NSPrivateQueueConcurrencyType`, with it's parent context set to the root saving context.
 *
 *  @return Private context with the parent set to the root saving context
 */
+ (NSManagedObjectContext *) MR_newContext NS_RETURNS_RETAINED;

/**
 *  Creates and returns a new managed object context of type `NSPrivateQueueConcurrencyType`, with it's parent context set to the root saving context.
 *
 *  @param parentContext Context to set as the parent of the newly created private context
 *
 *  @return Private context with the parent set to the provided context
 */
+ (NSManagedObjectContext *) MR_newContextWithParent:(NSManagedObjectContext *)parentContext NS_RETURNS_RETAINED;

/**
 *  Creates and returns a new managed object context of type `NSPrivateQueueConcurrencyType`, with it's persistent store coordinator set to the provided coordinator.
 *
 *  @param coordinator Persistent Store Coordinator
 *
 *  @return Private context with it's persistent store coordinator set to the provided coordinator
 */
+ (NSManagedObjectContext *) MR_newContextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator NS_RETURNS_RETAINED;

/**
 *  Creates and returns a new managed object context of type `NSMainQueueConcurrencyType`.
 *
 *  @return Main queue context
 */
+ (NSManagedObjectContext *) MR_newMainQueueContext NS_RETURNS_RETAINED;

/**
 *  Creates and returns a new managed object context of type `NSPrivateQueueConcurrencyType`.
 *
 *  @return Private context
 */
+ (NSManagedObjectContext *) MR_newPrivateQueueContext NS_RETURNS_RETAINED;

#pragma mark - Debugging

/**
 *  Sets a working name for the context, which will be used in debug logs.
 *
 *  @param workingName Name for the context
 */
- (void) MR_setWorkingName:(NSString *)workingName;

/**
 *  @return Working name for the context
 */
- (NSString *) MR_workingName;

/**
 *  @return Description of this context
 */
- (NSString *) MR_description;

/**
 *  @return Description of the parent contexts of this context
 */
- (NSString *) MR_parentChain;


#pragma mark - Helpers

/**
 *  Reset the default context.
 */
+ (void) MR_resetDefaultContext;

/**
 *  Delete the provided objects from the context
 *
 *  @param managedObjects an object conforming to NSFastEnumeration, containing NSManagedObjects
 */
- (void) MR_deleteObjects:(id <NSFastEnumeration>)managedObjects;

@end

#pragma mark - Deprecated Methods — DO NOT USE
@interface NSManagedObjectContext (MagicalRecordDeprecated)

+ (NSManagedObjectContext *) MR_context MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0_USE("Please use +MR_newContext instead");
+ (NSManagedObjectContext *) MR_contextWithoutParent MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0_USE("Please use +MR_newPrivateQueueContext instead");
+ (NSManagedObjectContext *) MR_contextWithParent:(NSManagedObjectContext *)parentContext MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0_USE("Please use +MR_newContextWithParent: instead");
+ (NSManagedObjectContext *) MR_contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0_USE("Please use +MR_newContextWithStoreCoordinator: instead");

@end
