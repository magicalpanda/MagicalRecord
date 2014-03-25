//
//  NSPersistentStoreCoordinator+MagicalAutoMigrations.h
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSPersistentStoreCoordinator (MagicalAutoMigrations)

- (NSPersistentStore *) MR_addAutoMigratingSqliteStoreNamed:(NSString *)storeFileName;
- (NSPersistentStore *) MR_addAutoMigratingSqliteStoreNamed:(NSString *)storeFileName withOptions:(NSDictionary *)options;

- (NSPersistentStore *) MR_addAutoMigratingSqliteStoreAtURL:(NSURL *)url;
- (NSPersistentStore *) MR_addAutoMigratingSqliteStoreAtURL:(NSURL *)url withOptions:(NSDictionary *)options;

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithAutoMigratingSqliteStoreNamed:(NSString *)storeFileName;
+ (NSPersistentStoreCoordinator *) MR_coordinatorWithAutoMigratingSqliteStoreAtURL:(NSURL *)url;

@end
