//
//  NSPersistentStoreCoordinator+MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "MagicalRecordHelpers.h"
#import "NSPersistentStore+MagicalRecord.h"

#ifdef MR_SHORTHAND
	#define addInMemoryStore MR_addInMemoryStore
	#define coordinatorWithAutoMigratingSqliteStoreNamed MR_coordinatorWithAutoMigratingSqliteStoreNamed
	#define coordinatorWithInMemoryStore MR_coordinatorWithInMemoryStore
	#define coordinatorWithPersitentStore MR_coordinatorWithPersitentStore
	#define coordinatorWithSqliteStoreNamed MR_coordinatorWithSqliteStoreNamed
	#define defautlStoreCoordinator MR_defaultStoreCoordinator
	#define newPersistentStoreCoordinator MR_newPersistentStoreCoordinator
	#define setDefaultStoreCoordinator MR_setDefaultStoreCoordinator
#endif

@interface NSPersistentStoreCoordinator (MagicalRecord)

+ (NSPersistentStoreCoordinator *) MR_defaultStoreCoordinator;
+ (void) MR_setDefaultStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithInMemoryStore;

+ (NSPersistentStoreCoordinator *) MR_newPersistentStoreCoordinator NS_RETURNS_RETAINED;

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreNamed:(NSString *)storeFileName;
+ (NSPersistentStoreCoordinator *) MR_coordinatorWithAutoMigratingSqliteStoreNamed:(NSString *) storeFileName;
+ (NSPersistentStoreCoordinator *) MR_coordinatorWithPersitentStore:(NSPersistentStore *)persistentStore;

- (NSPersistentStore *) MR_addInMemoryStore;

@end
