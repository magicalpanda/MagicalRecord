//
//  MagicalRecord+Actions.h
//  MagicalRecord
//
//  Created by Saul Mora on 9/15/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"
#import "NSManagedObjectContext+MagicalSaves.h"

@interface MagicalRecord (Actions)

/*!
 *  @method saveWithBlock:
 *
 *  @param block Make changes to CoreData objects in this block using the passed in localContext. The block will be performed on a background queue, and once complete, the context will be saved.
 */
+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;

/*!
 *  @method saveWithBlock:completion:
 *
 *  @param block Make changes to CoreData objects in this block using the passed in localContext. The block will be performed on a background queue, and once complete, the context will be saved.
 *  @param completion The completion block will be called once the save operation is complete. This includes saving any nested contexts. The completion block is called on the main queue
 */
+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;

/*!
 *  @method saveWithBlock:identifier:completion
 *
 *  @param block Make changes to CoreData objects in this block using the passed in localContext. The block will be performed on a background queue, and once complete, the context will be saved.

 *  @param identifier A string to identify the context
 *  @param completion The completion block will be called once the save operation is complete. This includes saving any nested contexts. The completion block is called on the main queue
 */
+ (void) saveWithBlock:(void (^)(NSManagedObjectContext *))block identifier:(NSString *)identifier completion:(MRSaveCompletionHandler)completion;

/*!
 *  @method saveWithIdentifier:block:
 *
 *  @param identifier A string to identify the context
 *  @param block Make changes to CoreData objects in this block using the passed in localContext. The block will be performed on a background queue, and once complete, the context will be saved.
 *
 *  @discussion The identifier is printed out when logging is enabled, and the context is being saved.
 */
+ (void) saveWithIdentifier:(NSString *)identifier block:(void(^)(NSManagedObjectContext *))block;

/*!
 *  @method saveWithBlockAndWait:
 *
 *  @discussion For saving on the current thread as the caller, only with a seperate context. Useful when you're managing your own threads/queues and need a serial call to create or change data
 *
 *  @param block Make changes to CoreData objects in this block using the passed in localContext. The block will be performed on a background queue, and once complete, the context will be saved.
 *
 */
+ (void) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;

@end
