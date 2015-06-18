//
//  NSManagedObjectContext+MagicalRecord.h
//
//  Created by Saul Mora on 11/23/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecordDeprecationMacros.h>
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>

@interface NSManagedObjectContext (MagicalRecord)

#pragma mark - Setup

/**
 Initializes MagicalRecord's default contexts using the provided persistent store coordinator.

 @param coordinator Persistent Store Coordinator
 */
+ (void) MR_initializeDefaultContextWithCoordinator:(MR_nonnull NSPersistentStoreCoordinator *)coordinator;

#pragma mark - Default Contexts
/**
 Root context responsible for sending changes to the main persistent store coordinator that will be saved to disk.

 @discussion Use this context for making and saving changes. All saves will be merged into the context returned by `MR_defaultContext` as well.

 @return Private context used for saving changes to disk on a background thread
 */
+ (MR_nonnull NSManagedObjectContext *) MR_rootSavingContext;

/**
 @discussion Please do not use this context for saving changes, as it will block the main thread when doing so.

 @return Main queue context that can be observed for changes
 */
+ (MR_nonnull NSManagedObjectContext *) MR_defaultContext;

#pragma mark - Context Creation

/**
 Creates and returns a new managed object context of type `NSPrivateQueueConcurrencyType`, with it's parent context set to the root saving context.
 @return Private context with the parent set to the root saving context
 */
+ (MR_nonnull NSManagedObjectContext *) MR_context;

/**
 Creates and returns a new managed object context of type `NSPrivateQueueConcurrencyType`, with it's parent context set to the root saving context.

 @param parentContext Context to set as the parent of the newly initialized context

 @return Private context with the parent set to the provided context
 */
+ (MR_nonnull NSManagedObjectContext *) MR_contextWithParent:(MR_nonnull NSManagedObjectContext *)parentContext;

/**
 Creates and returns a new managed object context of type `NSPrivateQueueConcurrencyType`, with it's persistent store coordinator set to the provided coordinator.
 
 @param coordinator A persistent store coordinator

 @return Private context with it's persistent store coordinator set to the provided coordinator
 */
+ (MR_nonnull NSManagedObjectContext *) MR_contextWithStoreCoordinator:(MR_nonnull NSPersistentStoreCoordinator *)coordinator;

/**
 Initializes a context of type `NSMainQueueConcurrencyType`.

 @return A context initialized using the `NSPrivateQueueConcurrencyType` concurrency type.
 */
+ (MR_nonnull NSManagedObjectContext *) MR_newMainQueueContext NS_RETURNS_RETAINED;

/**
 Initializes a context of type `NSPrivateQueueConcurrencyType`.

 @return A context initialized using the `NSPrivateQueueConcurrencyType` concurrency type.
 */
+ (MR_nonnull NSManagedObjectContext *) MR_newPrivateQueueContext NS_RETURNS_RETAINED;

#pragma mark - Debugging

/**
 Sets a working name for the context, which will be used in debug logs.

 @param workingName Name for the context
 */
- (void) MR_setWorkingName:(MR_nonnull NSString *)workingName;

/**
 @return Working name for the context
 */
- (MR_nonnull NSString *) MR_workingName;

/**
 @return Description of this context
 */
- (MR_nonnull NSString *) MR_description;

/**
 @return Description of the parent contexts of this context
 */
- (MR_nonnull NSString *) MR_parentChain;


#pragma mark - Helpers

/**
 Reset the default context.
 */
+ (void) MR_resetDefaultContext;

/**
 Delete the provided objects from the context

 @param objects An object conforming to `NSFastEnumeration`, containing NSManagedObject instances
 */
- (void) MR_deleteObjects:(MR_nonnull id <NSFastEnumeration>)objects;

@end

#pragma mark - Deprecated Methods — DO NOT USE
@interface NSManagedObjectContext (MagicalRecordDeprecated)

+ (MR_nonnull NSManagedObjectContext *) MR_contextWithoutParent MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_newPrivateQueueContext");
+ (MR_nonnull NSManagedObjectContext *) MR_newContext MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_context");
+ (MR_nonnull NSManagedObjectContext *) MR_newContextWithParent:(MR_nonnull NSManagedObjectContext *)parentContext MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_contextWithParent:");
+ (MR_nonnull NSManagedObjectContext *) MR_newContextWithStoreCoordinator:(MR_nonnull NSPersistentStoreCoordinator *)coordinator MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_contextWithStoreCoordinator:");


@end
