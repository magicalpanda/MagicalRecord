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
+ (NSManagedObjectContext *) MR_privateQueueContext;
+ (NSManagedObjectContext *) MR_confinementContext;
+ (NSManagedObjectContext *) MR_mainQueueContext;

+ (NSManagedObjectContext *) MR_contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator NS_RETURNS_RETAINED;

+ (void) MR_resetDefaultContext;
+ (NSManagedObjectContext *) MR_rootSavingContext;
+ (NSManagedObjectContext *) MR_defaultContext;

- (NSString *) MR_description;
- (NSString *) MR_parentChain;

- (BOOL)MR_isDescendantOfContext:(NSManagedObjectContext *)otherContext;
- (BOOL)MR_isAscendentOfContext:(NSManagedObjectContext *)otherContext;

@property (nonatomic, copy, setter = MR_setWorkingName:) NSString *MR_workingName;

@end
