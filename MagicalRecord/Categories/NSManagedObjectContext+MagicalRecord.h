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

+ (NSManagedObjectContext *) MR_context;
+ (NSManagedObjectContext *) MR_contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

+ (void) MR_resetDefaultContext;
+ (NSManagedObjectContext *) MR_defaultContext;
+ (void) MR_setDefaultContext:(NSManagedObjectContext *)moc;

@end
