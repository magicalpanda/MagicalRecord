//
//  NSPersistentStoreCoordinator+MagicalAutoMigrations.m
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "NSPersistentStoreCoordinator+MagicalAutoMigrations.h"
#import "NSDictionary+MagicalRecordAdditions.h"
#import "NSPersistentStoreCoordinator+MagicalRecord.h"
#import "MagicalRecordStack.h"

@implementation NSPersistentStoreCoordinator (MagicalAutoMigrations)

- (NSPersistentStore *) MR_addAutoMigratingSqliteStoreNamed:(NSString *)storeFileName;
{
    NSDictionary *options = [NSDictionary MR_autoMigrationOptions];
    return [self MR_addAutoMigratingSqliteStoreNamed:storeFileName withOptions:options];
}

- (NSPersistentStore *) MR_addAutoMigratingSqliteStoreNamed:(NSString *)storeFileName withOptions:(NSDictionary *)options;
{
    return [self MR_addSqliteStoreNamed:storeFileName withOptions:options];
}

- (NSPersistentStore *) MR_addAutoMigratingSqliteStoreAtURL:(NSURL *)url;
{
    NSDictionary *options = [NSDictionary MR_autoMigrationOptions];
    return [self MR_addAutoMigratingSqliteStoreAtURL:url withOptions:options];
}

- (NSPersistentStore *) MR_addAutoMigratingSqliteStoreAtURL:(NSURL *)url withOptions:(NSDictionary *)options;
{
    return [self MR_addSqliteStoreAtURL:url withOptions:options];
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithAutoMigratingSqliteStoreNamed:(NSString *)storeFileName;
{
    NSManagedObjectModel *model = [[MagicalRecordStack defaultStack] model];
    NSPersistentStoreCoordinator *coordinator = [[self alloc] initWithManagedObjectModel:model];

    [coordinator MR_addAutoMigratingSqliteStoreNamed:storeFileName];

    //HACK: lame solution to fix automigration error "Migration failed after first pass"
    if ([[coordinator persistentStores] count] == 0)
    {
        [coordinator performSelector:@selector(MR_addAutoMigratingSqliteStoreNamed:) withObject:storeFileName afterDelay:0.5];
    }

    return coordinator;
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithAutoMigratingSqliteStoreAtURL:(NSURL *)url;
{
    NSManagedObjectModel *model = [[MagicalRecordStack defaultStack] model];
    NSPersistentStoreCoordinator *coordinator = [[self alloc] initWithManagedObjectModel:model];

    [coordinator MR_addAutoMigratingSqliteStoreAtURL:url];

    //HACK: lame solution to fix automigration error "Migration failed after first pass"
    if ([[coordinator persistentStores] count] == 0)
    {
        [coordinator performSelector:@selector(MR_addAutoMigratingSqliteStoreAtURL:) withObject:url afterDelay:0.5];
    }

    return coordinator;
}

@end
