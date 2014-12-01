//
//  MagicalRecord+ChainSave.h
//  Magical Record
//
//  Created by Lee on 8/27/14.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CoreData+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalSaves.h"

@interface NSManagedObjectContext(MagicalRecord_ChainSave)
/* Just like [MagicalRecord saveWithBlock…], this saving method start with the receiver context and creates a child context. Upon saving, the child context saves to parent and chain up the save operation to main context, and finally to saving context. This is to ensure that all changes made in background will pass through to main context and then to persistent store.
 */
- (void) MR_saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;

/* Just like [MagicalRecord saveWithBlock…], this saving method start with the receiver context and creates a child context. Upon saving, the child context saves to parent and chain up the save operation to main context, and finally to saving context. This is to ensure that all changes made in background will pass through to main context and then to persistent store.
 */
- (void) MR_saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;

/* Just like [MagicalRecord saveWithBlock…], this saving method start with the receiver context and creates a child context. Upon saving, the child context saves to parent and chain up the save operation to main context, and finally to saving context. This is to ensure that all changes made in background will pass through to main context and then to persistent store.
 */
- (void) MR_saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;

@end
