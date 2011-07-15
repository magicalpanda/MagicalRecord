//
//  NSManagedObjectContext+MagicalRecord.h
//
//  Created by Saul Mora on 11/23/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "MagicalRecordHelpers.h"

@interface NSManagedObjectContext (MagicalRecord)

- (void) observeContext:(NSManagedObjectContext *)otherContext;
- (void) stopObservingContext:(NSManagedObjectContext *)otherContext;
- (void) observeContextOnMainThread:(NSManagedObjectContext *)otherContext;

- (BOOL) save;

#ifdef NS_BLOCKS_AVAILABLE
- (BOOL) saveWithErrorHandler:(void(^)(NSError *))errorCallback;
#endif

- (BOOL) saveOnMainThread;
- (BOOL) saveOnBackgroundThread;
- (void) setNotifiesMainContextOnSave:(BOOL)enabled;

+ (void) resetDefaultContext;
+ (NSManagedObjectContext *) defaultContext;
+ (void) setDefaultContext:(NSManagedObjectContext *)moc;
+ (void) resetContextForCurrentThread;

+ (NSManagedObjectContext *) context;
+ (NSManagedObjectContext *) contextForCurrentThread;

+ (NSManagedObjectContext *) contextThatNotifiesDefaultContextOnMainThread;
+ (NSManagedObjectContext *) contextThatNotifiesDefaultContextOnMainThreadWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;
+ (NSManagedObjectContext *) contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

@property (nonatomic, assign) BOOL notifiesMainContextOnSave;

@end
