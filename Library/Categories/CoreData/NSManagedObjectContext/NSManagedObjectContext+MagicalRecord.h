//
//  NSManagedObjectContext+MagicalRecord.h
//
//  Created by Saul Mora on 11/23/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <CoreData/CoreData.h>

extern NSString * const MagicalRecordDidMergeChangesFromiCloudNotification;

@interface NSManagedObjectContext (MagicalRecord)

- (void) MR_obtainPermanentIDsForObjects:(NSArray *)objects;

+ (NSManagedObjectContext *) MR_context NS_RETURNS_RETAINED;
+ (NSManagedObjectContext *) MR_mainQueueContext;
+ (NSManagedObjectContext *) MR_privateQueueContext;

+ (NSManagedObjectContext *) MR_confinementContext;
+ (NSManagedObjectContext *) MR_confinementContextWithParent:(NSManagedObjectContext *)parentContext;

+ (NSManagedObjectContext *) MR_privateQueueContextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator NS_RETURNS_RETAINED;

- (NSString *) MR_description;
- (NSString *) MR_parentChain;

- (void) MR_setWorkingName:(NSString *)workingName;
- (NSString *) MR_workingName;

@end
