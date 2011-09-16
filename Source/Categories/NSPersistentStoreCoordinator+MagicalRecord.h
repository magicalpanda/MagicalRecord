//
//  NSPersistentStoreCoordinator+MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "MagicalRecordHelpers.h"
#import "NSPersistentStore+MagicalRecord.h"


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


#ifdef MR_SHORTHAND

#define defautlStoreCoordinator         MR_defaultStoreCoordinator
#define setDefaultStoreCoordinator      MR_setDefaultStoreCoordinator

#define coordinatorWithInMemoryStore        MR_coordinatorWithInMemoryStore
#define newPersistentStoreCoordinator       MR_newPersistentStoreCoordinator

#define coordinatorWithSqliteStoreNamed                     MR_coordinatorWithSqliteStoreNamed
#define coordinatorWithAutoMigratingSqliteStoreNamed        MR_coordinatorWithAutoMigratingSqliteStoreNamed
#define coordinatorWithPersitentStore                       MR_coordinatorWithPersitentStore

#define addInMemoryStore                MR_addInMemoryStore

#endif