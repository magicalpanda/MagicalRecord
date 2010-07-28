//
//  NSManagedObjectContext+ActiveRecord.h
//  Conference
//
//  Created by Saul Mora on 11/23/09.
//  Copyright 2009 Magical Panda Software, LLC. All rights reserved.
//

#import "ActiveRecordHelpers.h"

@interface NSManagedObjectContext (ActiveRecord)

- (void) observeContext:(NSManagedObjectContext *)otherContext;
- (void) stopObservingContext:(NSManagedObjectContext *)otherContext;
- (void) observeContextOnMainThread:(NSManagedObjectContext *)otherContext;

- (BOOL) save;
- (BOOL) saveOnMainThread;
- (BOOL) saveOnBackgroundThread;

+ (NSManagedObjectContext *) defaultContext;
+ (void) setDefaultContext:(NSManagedObjectContext *)moc;

+ (NSManagedObjectContext *) context;
+ (NSManagedObjectContext *) contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

@end
