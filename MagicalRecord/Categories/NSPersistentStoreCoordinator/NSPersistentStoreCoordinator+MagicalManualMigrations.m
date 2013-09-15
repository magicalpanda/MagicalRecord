//
//  NSPersistentStoreCoordinator+MagicalManualMigrations.m
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "NSPersistentStoreCoordinator+MagicalManualMigrations.h"
#import "NSDictionary+MagicalRecordAdditions.h"
#import "NSPersistentStoreCoordinator+MagicalRecord.h"
#import "MagicalRecordStack.h"


@implementation NSPersistentStoreCoordinator (MagicalManualMigrations)

- (NSPersistentStore *) MR_addManuallyMigratingSqliteStoreNamed:(NSString *)storeFileName;
{
    NSDictionary *options = [NSDictionary MR_manualMigrationOptions];
    return [self MR_addSqliteStoreNamed:storeFileName withOptions:options];
}

- (NSPersistentStore *) MR_addManuallyMigratingSqliteStoreAtURL:(NSURL *)url;
{
    NSDictionary *options = [NSDictionary MR_manualMigrationOptions];
    return [self MR_addSqliteStoreAtURL:url withOptions:options];
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithManuallyMigratingSqliteStoreNamed:(NSString *)storeFileName;
{
    NSManagedObjectModel *model = [[MagicalRecordStack defaultStack] model];
    NSPersistentStoreCoordinator *coordinator = [[self alloc] initWithManagedObjectModel:model];

    [coordinator MR_addManuallyMigratingSqliteStoreNamed:storeFileName];

    return coordinator;
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithManuallyMigratingSqliteStoreAtURL:(NSURL *)url;
{
    NSManagedObjectModel *model = [[MagicalRecordStack defaultStack] model];
    NSPersistentStoreCoordinator *coordinator = [[self alloc] initWithManagedObjectModel:model];

    [coordinator MR_addManuallyMigratingSqliteStoreAtURL:url];

    return coordinator;
}
@end
