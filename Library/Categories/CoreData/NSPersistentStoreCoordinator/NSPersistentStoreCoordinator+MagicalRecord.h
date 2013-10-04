//
//  NSPersistentStoreCoordinator+MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "MagicalRecord.h"
#import "NSPersistentStore+MagicalRecord.h"

extern NSString * const MagicalRecordShouldDeletePersistentStoreOnModelMismatchKey;

@interface NSPersistentStoreCoordinator (MagicalRecord)

+ (NSPersistentStoreCoordinator *) MR_newPersistentStoreCoordinator NS_RETURNS_RETAINED;

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreNamed:(NSString *)storeFileName;

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithPersistentStore:(NSPersistentStore *)persistentStore;
+ (NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreAtURL:(NSURL *)url;

- (NSPersistentStore *) MR_addSqliteStoreAtURL:(NSURL *)url withOptions:(NSDictionary *__autoreleasing)options;
- (NSPersistentStore *) MR_addSqliteStoreNamed:(id)storeFileName withOptions:(__autoreleasing NSDictionary *)options;

@end
