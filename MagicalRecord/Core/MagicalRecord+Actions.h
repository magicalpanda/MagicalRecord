//
//  MagicalRecord+Actions.h
//
//  Created by Saul Mora on 2/24/11.
//  Copyright 2011 Magical Panda Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecordInternal.h>
#import <MagicalRecord/MagicalRecordDeprecationMacros.h>
#import <MagicalRecord/NSManagedObjectContext+MagicalSaves.h>
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>

@interface MagicalRecord (Actions)

/* For all background saving operations. These calls will be sent to a different thread/queue.
 */
+ (void) saveWithBlock:(void (^ __MR_nonnull)(NSManagedObjectContext * __MR_nonnull localContext))block;
+ (void) saveWithBlock:(void (^ __MR_nonnull)(NSManagedObjectContext * __MR_nonnull localContext))block completion:(MR_nullable MRSaveCompletionHandler)completion;

/* For saving on the current thread as the caller, only with a separate context. Useful when you're managing your own threads/queues and need a serial call to create or change data
 */
+ (void) saveWithBlockAndWait:(void (^ __MR_nonnull)(NSManagedObjectContext * __MR_nonnull localContext))block;

@end

@interface MagicalRecord (ActionsDeprecated)

+ (void) saveUsingCurrentThreadContextWithBlock:(void (^ __MR_nonnull)(NSManagedObjectContext * __MR_nonnull localContext))block completion:(MR_nullable MRSaveCompletionHandler)completion MR_DEPRECATED_WILL_BE_REMOVED_IN("3.0");
+ (void) saveUsingCurrentThreadContextWithBlockAndWait:(void (^ __MR_nonnull)(NSManagedObjectContext * __MR_nonnull localContext))block MR_DEPRECATED_WILL_BE_REMOVED_IN("3.0");
+ (void) saveInBackgroundWithBlock:(void (^ __MR_nonnull)(NSManagedObjectContext * __MR_nonnull localContext))block MR_DEPRECATED_WILL_BE_REMOVED_IN("3.0");
+ (void) saveInBackgroundWithBlock:(void (^ __MR_nonnull)(NSManagedObjectContext * __MR_nonnull localContext))block completion:(void (^ __MR_nullable)(void))completion MR_DEPRECATED_WILL_BE_REMOVED_IN("3.0");
+ (void) saveInBackgroundUsingCurrentContextWithBlock:(void (^ __MR_nonnull)(NSManagedObjectContext * __MR_nonnull localContext))block completion:(void (^ __MR_nullable)(void))completion errorHandler:(void (^ __MR_nullable)(NSError * __MR_nullable error))errorHandler MR_DEPRECATED_WILL_BE_REMOVED_IN("3.0");

@end
