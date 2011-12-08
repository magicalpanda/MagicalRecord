//
//  NSManagedObjectContext+MagicalRecord.h
//
//  Created by Saul Mora on 11/23/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "MagicalRecordHelpers.h"

extern NSString * const kMagicalRecordDidMergeChangesFromiCloudNotification;

@interface NSManagedObjectContext (MagicalRecord)

- (void) MR_observeContext:(NSManagedObjectContext *)otherContext;
- (void) MR_stopObservingContext:(NSManagedObjectContext *)otherContext;
- (void) MR_observeContextOnMainThread:(NSManagedObjectContext *)otherContext;

- (void) MR_observeiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator;
- (void) MR_stopObservingiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator;

- (BOOL) MR_save;

#ifdef NS_BLOCKS_AVAILABLE
- (BOOL) MR_saveWithErrorHandler:(void (^)(NSError *))errorCallback;
#endif

- (BOOL) MR_saveOnMainThread;
- (BOOL) MR_saveOnBackgroundThread;

+ (void) MR_resetDefaultContext;
+ (NSManagedObjectContext *)MR_defaultContext;
+ (void) MR_setDefaultContext:(NSManagedObjectContext *)moc;
+ (void) MR_resetContextForCurrentThread;

+ (NSManagedObjectContext *) MR_context;
+ (NSManagedObjectContext *) MR_contextForCurrentThread;

+ (NSManagedObjectContext *) MR_contextThatNotifiesDefaultContextOnMainThread;
+ (NSManagedObjectContext *) MR_contextThatNotifiesDefaultContextOnMainThreadWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;
+ (NSManagedObjectContext *) MR_contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

@property (nonatomic, assign, setter=MR_setNotifiesMainContextOnSave:) BOOL MR_notifiesMainContextOnSave;

@end


