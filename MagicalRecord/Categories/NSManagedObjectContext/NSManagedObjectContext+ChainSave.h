//
//  MagicalRecord+ChainSave.h
//  transformableTest
//
//  Created by Lee on 8/27/14.
//  Copyright (c) 2014 Lei. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CoreData+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalSaves.h"

@interface NSManagedObjectContext(MagicalRecord_ChainSave)
/* Start background saving context. These calls will be sent to a different thread/queue.
 When the save finishes, it will save in chain to the context's parent context
 Save up to Default Context(main) and to Saving Context
 */
- (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;
- (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;

/* For saving on the current thread as the caller, only with a seperate context. Useful when you're managing your own threads/queues and need a serial call to create or change data
 */
- (void) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;

@end
