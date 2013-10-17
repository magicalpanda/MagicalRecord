//
//  MagicalRecord+Actions.h
//
//  Created by Saul Mora on 2/24/11.
//  Copyright 2011 Magical Panda Software. All rights reserved.
//

#import "MagicalRecordStack.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalSaves.h"

@interface MagicalRecordStack (Actions)

/* For all background saving operations. These calls will be sent to a different thread/queue.
 */
- (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;
- (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;
- (void) saveWithBlock:(void (^)(NSManagedObjectContext *))block identifier:(NSString *)contextWorkingName completion:(MRSaveCompletionHandler)completion;

- (void) saveWithIdentifier:(NSString *)identifier block:(void(^)(NSManagedObjectContext *))block;

/* For saving on the current thread as the caller, only with a seperate context. Useful when you're managing your own threads/queues and need a serial call to create or change data
 */
- (void) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;

@end
