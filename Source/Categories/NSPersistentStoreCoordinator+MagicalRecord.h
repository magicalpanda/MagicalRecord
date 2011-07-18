//
//  NSPersistentStoreCoordinator+MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "MagicalRecordHelpers.h"
#import "NSPersistentStore+MagicalRecord.h"


@interface NSPersistentStoreCoordinator (MagicalRecord)

+ (NSPersistentStoreCoordinator *) defaultStoreCoordinator;
+ (void) setDefaultStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

+ (NSPersistentStoreCoordinator *) coordinatorWithInMemoryStore;

+ (NSPersistentStoreCoordinator *)newPersistentStoreCoordinator;

+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreNamed:(NSString *)storeFileName;
+ (NSPersistentStoreCoordinator *) coordinatorWithAutoMigratingSqliteStoreNamed:(NSString *) storeFileName;
+ (NSPersistentStoreCoordinator *) coordinatorWithPersitentStore:(NSPersistentStore *)persistentStore;

- (NSPersistentStore *) addInMemoryStore;

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