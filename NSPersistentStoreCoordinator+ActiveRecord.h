//
//  NSPersistentStoreCoordinator+ActiveRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "ActiveRecordHelpers.h"
#import "NSPersistentStore+ActiveRecord.h"


@interface NSPersistentStoreCoordinator (ActiveRecord)

+ (NSPersistentStoreCoordinator *) defaultStoreCoordinator;
+ (void) setDefaultStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

+ (NSPersistentStoreCoordinator *) coordinatorWithInMemoryStore;

+ (NSPersistentStoreCoordinator *)newPersistentStoreCoordinator;

+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreNamed:(NSString *)storeFileName;
+ (NSPersistentStoreCoordinator *) coordinatorWithAutoMigratingSqliteStoreNamed:(NSString *) storeFileName;
+ (NSPersistentStoreCoordinator *) coordinatorWithPersitentStore:(NSPersistentStore *)persistentStore;
+ (NSPersistentStoreCoordinator *) coordinatorWithiCloudSqliteStoreNamed:(NSString *) storeFileName;


- (NSURL*)applicationDocumentsDirectoryURL;
- (void)mergeiCloudChanges:(NSNotification*)note forContext:(NSManagedObjectContext*)moc;
- (void)mergeChangesFrom_iCloud:(NSNotification *)notification;

- (NSPersistentStore *) addInMemoryStore;

@end
