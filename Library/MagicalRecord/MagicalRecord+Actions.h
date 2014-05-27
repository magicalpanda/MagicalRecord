//
//  MagicalRecord+Actions.h
//  MagicalRecord
//
//  Created by Saul Mora on 9/15/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"
#import "NSManagedObjectContext+MagicalSaves.h"

/**
 Provides convenient, block-based save methods for the MagicalRecord class that helps avoid dealing directly with managed object context instances.

 @since Available in v2.0 and later.
 */
@interface MagicalRecord (Actions)

/**
 @name Block-based Saves
 */

/**
 @param block Make changes to your NSManagedObject instances in this block using the provided `localContext`. The block will be executed on a background queue, and once complete the context will be saved.
 
 @since Available in v2.1 and later.
 */
+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;

/**
 @param block Make changes to your NSManagedObject instances in this block using the provided `localContext`. The block will be executed on a background queue, and once complete the context will be saved.
 @param completion The completion block will be called once the save operation is complete. This includes saving any nested contexts.
 
 @since Available in v2.1 and later.
 */
+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;

/**
 @param block Make changes to your NSManagedObject instances in this block using the provided `localContext`. The block will be executed on a background queue, and once complete the context will be saved.
 @param identifier A string to identify the context.
 @param completion The completion block will be called once the save operation is complete. This includes saving any nested contexts.
 
 @since Available in v2.1 and later.
 */
+ (void) saveWithBlock:(void (^)(NSManagedObjectContext *))block identifier:(NSString *)identifier completion:(MRSaveCompletionHandler)completion;

/**
 @discussion The identifier is printed out when logging is enabled, and the context is being saved.

 @param identifier A string to identify the context.
 @param block Make changes to your NSManagedObject instances in this block using the provided `localContext`. The block will be executed on a background queue, and once complete the context will be saved.
 
 @since Available in v2.1 and later.
 */
+ (void) saveWithIdentifier:(NSString *)identifier block:(void(^)(NSManagedObjectContext *))block;

/**
 Synchronously saves the default managed object context (if there is one) and any parent contexts.

 @param block Make changes to your NSManagedObject instances in this block using the provided `localContext`. The block may be executed on a background queue, and once complete the context will be saved.

 @return Whether the save was successful
 
 @since Available in v2.1 and later.
 */
+ (BOOL) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;

/**
 Synchronously saves the default managed object context (if there is one) and any parent contexts.

 @param block Make changes to your NSManagedObject instances in this block using the provided `localContext`. The block may be executed on a background queue, and once complete the context will be saved.
 @param error Pass in an NSError by reference to receive any errors encountered during the save.

 @return Whether the save was successful
 
 @since Available in v2.1 and later.
 */
+ (BOOL) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block error:(NSError **)error;

@end
