//
//  MagicalRecord+Actions.h
//
//  Created by Saul Mora on 2/24/11.
//  Copyright 2011 Magical Panda Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalSaves.h"

@interface MagicalRecord (Actions)

/* For all background saving operations. These calls will be sent to a different thread/queue.
 */
+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;
+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;

/* For saving on the current thread as the caller, only with a seperate context. Useful when you're managing your own threads/queues and need a serial call to create or change data
 */
+ (void) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;

/*
 If you want to reuse the context on the current thread, use these methods.
 */
+ (void) saveUsingCurrentThreadContextWithBlock:(void (^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0;
+ (void) saveUsingCurrentThreadContextWithBlockAndWait:(void (^)(NSManagedObjectContext *localContext))block MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0;


/* DEPRECATION NOTICE:
 * The following methods are deprecated, but remain in place for backwards compatibility until the next major version (3.x)
 */

/* For all background saving operations. These calls will be sent to a different thread/queue.
 */
+ (void) saveInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0;
+ (void) saveInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(void(^)(void))completion MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0;

/*
 If you want to reuse the context on the current thread, use this method.
 */
+ (void) saveInBackgroundUsingCurrentContextWithBlock:(void (^)(NSManagedObjectContext *localContext))block completion:(void (^)(void))completion errorHandler:(void (^)(NSError *error))errorHandler MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0;

@end
