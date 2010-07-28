//
//  NSPersistentStoreCoordinator+ActiveRecord.h
//  DocBook
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Willow Tree Mobile, Inc. All rights reserved.
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

- (NSPersistentStore *) addInMemoryStore;

@end
