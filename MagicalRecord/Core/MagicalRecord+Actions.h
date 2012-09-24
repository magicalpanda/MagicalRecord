//
//  MagicalRecord+Actions.h
//
//  Created by Saul Mora on 2/24/11.
//  Copyright 2011 Magical Panda Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSManagedObjectContext+MagicalRecord.h"

@interface MagicalRecord (Actions)

/* For saving on the current thread as the caller, only with a seperate context. Useful when you're managing your own threads/queues and need a serial call to create or change data
 */
+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;

/* For all background saving operations. These calls will be sent to a different thread/queue.
 */
+ (void) saveInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block;
+ (void) saveInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(void(^)(void))callback;

/*
 If you want to reuse the context on the current thread, use this method.
 */
+ (void) saveInBackgroundUsingCurrentContextWithBlock:(void (^)(NSManagedObjectContext *))block completion:(void (^)(void))completion errorHandler:(void (^)(NSError *))errorHandler;

@end
