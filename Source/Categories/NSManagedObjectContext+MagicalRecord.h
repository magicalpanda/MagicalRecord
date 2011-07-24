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
//- (void) setNotifiesMainContextOnSave:(BOOL)enabled;

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

/*
#ifdef MR_SHORTHAND

#define observeContext              MR_observeContext
#define stopObservingContext        MR_stopObservingContext
#define observeContextOnMainThread  MR_observeContextOnMainThread

#define save                        MR_save

#define saveWithErrorHandler        MR_saveWithErrorHandler

#define saveOnMainThread            MR_saveOnMainThread
#define saveOnBackgroundThread      MR_saveOnBackgroundThread

#define setNotifiesMainContextOnSave    MR_setNotifiesMainContextOnSave
#define notifiesMainContextonSave       MR_notifiesMainContextonSave

//#define context]                    MR_context]
#define contextForCurrentThread     MR_contextForCurrentThread

#define contextThatNotifiesDefaultContextOnMainThread       MR_contextThatNotifiesDefaultContextOnMainThread
#define contextWithStoreCoordinator                         MR_contextWithStoreCoodinator

#endif

*/
