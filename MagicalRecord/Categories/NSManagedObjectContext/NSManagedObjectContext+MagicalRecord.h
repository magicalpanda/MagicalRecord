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
 Initializes MagicalRecord's Root and default contexts using the provided persistent store coordinator.

 @discussion If you want MagicalRecord to use your existing contexts set them using MR_setRootSavingContext and MR_setDefaultContext.
 
 @param coordinator Persistent Store Coordinator
 */
+ (void) MR_initializeDefaultContextWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;

#pragma mark - Default Contexts
/**
 Root context responsible for sending changes to the main persistent store coordinator that will be saved to disk.

 @discussion Use this context for making and saving changes. All saves will be merged into the context returned by `MR_defaultContext` as well.

 @return Private context used for saving changes to disk on a background thread
 */
+ (NSManagedObjectContext *) MR_rootSavingContext;

/**
 Set the Root context responsible for sending changes to the main persistent store coordinator that will be saved to disk.
 
 @discussion There is usually no need to set manually the Root context as one will be created on MR_initializeDefaultContextWithCoordinator.
 
 @see MR_rootSavingContext.
 
 @param context Context to be set as the Root context.
 */
+ (void) MR_setRootSavingContext:(NSManagedObjectContext *)context;

/**
 @discussion Please do not use this context for saving changes, as it will block the main thread when doing so.

 @return Main queue context that can be observed for changes
 */
+ (NSManagedObjectContext *) MR_defaultContext;

/**
 Set the default context.
 
 @discussion There is usually no need to set manually the default context as one will be created on MR_initializeDefaultContextWithCoordinator.
 
 @see MR_defaultContext.
 
 @param context Context to be set as the deafult context.
 */
+ (void) MR_setDefaultContext:(NSManagedObjectContext *)context;

#pragma mark - Context Creation

/**
 Creates and returns a new managed object context of type `NSPrivateQueueConcurrencyType`, with it's parent context set to the root saving context.
 @return Private context with the parent set to the root saving context
 */
+ (NSManagedObjectContext *) MR_context;

/**
 Creates and returns a new managed object context of type `NSPrivateQueueConcurrencyType`, with it's parent context set to the root saving context.

 @param parentContext Context to set as the parent of the newly initialized context

 @return Private context with the parent set to the provided context
 */
+ (NSManagedObjectContext *) MR_contextWithParent:(NSManagedObjectContext *)parentContext;

/**
 Creates and returns a new managed object context of type `NSPrivateQueueConcurrencyType`, with it's persistent store coordinator set to the provided coordinator.
 
 @param coordinator A persistent store coordinator

 @return Private context with it's persistent store coordinator set to the provided coordinator
 */
+ (NSManagedObjectContext *) MR_contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

/**
 Initializes a context of type `NSMainQueueConcurrencyType`.

 @return A context initialized using the `NSPrivateQueueConcurrencyType` concurrency type.
 */
+ (NSManagedObjectContext *) MR_newMainQueueContext NS_RETURNS_RETAINED;

/**
 Initializes a context of type `NSPrivateQueueConcurrencyType`.

 @return A context initialized using the `NSPrivateQueueConcurrencyType` concurrency type.
 */
+ (NSManagedObjectContext *) MR_newPrivateQueueContext NS_RETURNS_RETAINED;

#pragma mark - Debugging

/**
 Sets a working name for the context, which will be used in debug logs.

 @param workingName Name for the context
 */
- (void) MR_setWorkingName:(NSString *)workingName;

/**
 @return Working name for the context
 */
- (NSString *) MR_workingName;

/**
 @return Description of this context
 */
- (NSString *) MR_description;

/**
 @return Description of the parent contexts of this context
 */
- (NSString *) MR_parentChain;


#pragma mark - Helpers

/**
 Reset the default context.
 */
+ (void) MR_resetDefaultContext;

/**
 Delete the provided objects from the context

 @param objects An object conforming to `NSFastEnumeration`, containing NSManagedObject instances
 */
- (void) MR_deleteObjects:(id <NSFastEnumeration>)objects;

@end

#pragma mark - Deprecated Methods — DO NOT USE
@interface NSManagedObjectContext (MagicalRecordDeprecated)

+ (NSManagedObjectContext *) MR_contextWithoutParent MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_newPrivateQueueContext");
+ (NSManagedObjectContext *) MR_newContext MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_context");
+ (NSManagedObjectContext *) MR_newContextWithParent:(NSManagedObjectContext *)parentContext MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_contextWithParent:");
+ (NSManagedObjectContext *) MR_newContextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_contextWithStoreCoordinator:");


@end
