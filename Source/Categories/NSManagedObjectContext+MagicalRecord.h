//
//  NSManagedObjectContext+MagicalRecord.h
//
//  Created by Saul Mora on 11/23/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "MagicalRecordHelpers.h"

#ifdef MR_SHORTHAND
	#define MR_context context
	#define MR_contextForCurrentThread contextForCurrentThread
	#define MR_contextThatNotifiesDefaultContextOnMainThread contextThatNotifiesDefaultContextOnMainThread
	#define MR_contextThatNotifiesDefaultContextOnMainThreadWithCoordinator contextThatNotifiesDefaultContextOnMainThreadWithCoordinator
	#define MR_contextWithStoreCoordinator contextWithStoreCoordinator
	#define MR_defaultContext defaultContext
	#define MR_notifiesMainContextOnSave notifiesMainContextOnSave
	#define MR_observeContext observeContext
	#define MR_observeContextOnMainThread observeContextOnMainThread
	#define MR_resetContextForCurrentThread resetContextForCurrentThread
	#define MR_resetDefaultContext resetDefaultContext
	#define MR_save save
	#define MR_saveOnBackgroundThread saveOnBackgroundThread
	#define MR_saveOnMainThread saveOnMainThread
	#define MR_saveWithErrorHandler saveWithErrorHandler
	#define MR_setDefaultContext setDefaultContext
	#define MR_setNotifiesMainContextOnSave setNotifiesMainContextOnSave
	#define MR_stopObservingContext stopObservingContext
#endif

@interface NSManagedObjectContext (MagicalRecord)

- (void) MR_observeContext:(NSManagedObjectContext *)otherContext;
- (void) MR_stopObservingContext:(NSManagedObjectContext *)otherContext;
- (void) MR_observeContextOnMainThread:(NSManagedObjectContext *)otherContext;

- (BOOL) MR_save;

#ifdef NS_BLOCKS_AVAILABLE
- (BOOL) MR_saveWithErrorHandler:(void(^)(NSError *))errorCallback;
#endif

- (BOOL) MR_saveOnMainThread;
- (BOOL) MR_saveOnBackgroundThread;

+ (void) MR_resetDefaultContext;
+ (NSManagedObjectContext *) MR_defaultContext;
+ (void) MR_setDefaultContext:(NSManagedObjectContext *)moc;
+ (void) MR_resetContextForCurrentThread;

+ (NSManagedObjectContext *) MR_context;
+ (NSManagedObjectContext *) MR_contextForCurrentThread;

+ (NSManagedObjectContext *) MR_contextThatNotifiesDefaultContextOnMainThread;
+ (NSManagedObjectContext *) MR_contextThatNotifiesDefaultContextOnMainThreadWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;
+ (NSManagedObjectContext *) MR_contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

@property (nonatomic, assign, setter = MR_setNotifiesMainContextOnSave:) BOOL MR_notifiesMainContextOnSave;

@end
