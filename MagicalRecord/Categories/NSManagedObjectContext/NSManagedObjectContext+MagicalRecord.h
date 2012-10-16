//
//  NSManagedObjectContext+MagicalRecord.h
//
//  Created by Saul Mora on 11/23/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "MagicalRecord.h"

extern NSString * const kMagicalRecordDidMergeChangesFromiCloudNotification;

@interface NSManagedObjectContext (MagicalRecord)

+ (void) MR_initializeDefaultContextWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;

+ (NSManagedObjectContext *) MR_context NS_RETURNS_RETAINED;
+ (NSManagedObjectContext *) MR_contextWithParent:(NSManagedObjectContext *)parentContext NS_RETURNS_RETAINED;
+ (NSManagedObjectContext *) MR_newMainQueueContext NS_RETURNS_RETAINED;
+ (NSManagedObjectContext *) MR_contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator NS_RETURNS_RETAINED;

+ (void) MR_resetDefaultContext;
+ (NSManagedObjectContext *) MR_rootSavingContext;
+ (NSManagedObjectContext *) MR_defaultContext;

- (NSString *) MR_description;

- (void) MR_setContextWorkingName:(NSString *)workingName;
- (NSString *) MR_contextWorkingName;

@end
