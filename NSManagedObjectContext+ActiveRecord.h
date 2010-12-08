//
//  NSManagedObjectContext+ActiveRecord.h
//
//  Created by Saul Mora on 11/23/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "ActiveRecordHelpers.h"

@interface NSManagedObjectContext (ActiveRecord)

- (void) observeContext:(NSManagedObjectContext *)otherContext;
- (void) stopObservingContext:(NSManagedObjectContext *)otherContext;
- (void) observeContextOnMainThread:(NSManagedObjectContext *)otherContext;

- (BOOL) save;
- (BOOL) saveOnMainThread;
- (BOOL) saveOnBackgroundThread;
- (void) setNotifiesMainContextOnSave:(BOOL)enabled;

+ (void) resetDefaultContext;
+ (NSManagedObjectContext *) defaultContext;
+ (void) setDefaultContext:(NSManagedObjectContext *)moc;
+ (NSManagedObjectContext *) contextForCurrentThread;

+ (NSManagedObjectContext *) context;
+ (NSManagedObjectContext *) contextThatNotifiesDefaultContextOnMainThread;
+ (NSManagedObjectContext *) contextThatNotifiesDefaultContextOnMainThreadWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;
+ (NSManagedObjectContext *) contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

@property (nonatomic, assign) BOOL notifiesMainContextOnSave;

@end
