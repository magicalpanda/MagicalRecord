//
//  NSPersistentStoreCoordinator+MagicalManualMigrations.h
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSPersistentStoreCoordinator (MagicalManualMigrations)

- (NSPersistentStore *) MR_addManuallyMigratingSqliteStoreAtURL:(NSURL *)url;
- (NSPersistentStore *) MR_addManuallyMigratingSqliteStoreNamed:(NSString *)storeFileName;

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithManuallyMigratingSqliteStoreNamed:(NSString *)storeFileName;
+ (NSPersistentStoreCoordinator *) MR_coordinatorWithManuallyMigratingSqliteStoreAtURL:(NSURL *)url;

@end
