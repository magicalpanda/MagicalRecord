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

+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;
+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;
+ (void) saveWithBlock:(void (^)(NSManagedObjectContext *))block identifier:(NSString *)contextWorkingName completion:(MRSaveCompletionHandler)completion;

+ (void) saveWithIdentifier:(NSString *)identifier block:(void(^)(NSManagedObjectContext *))block;

/* For saving on the current thread as the caller, only with a seperate context. Useful when you're managing your own threads/queues and need a serial call to create or change data
 */
+ (void) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;

@end
