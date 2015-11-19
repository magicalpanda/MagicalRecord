//
//  AutoMigratingMagicalRecordStack.m
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordStack+Private.h"
#import "AutoMigratingMagicalRecordStack.h"
#import "NSPersistentStoreCoordinator+MagicalAutoMigrations.h"
#import "NSDictionary+MagicalRecordAdditions.h"

@implementation AutoMigratingMagicalRecordStack

- (NSPersistentStoreCoordinator *)createCoordinatorWithOptions:(NSDictionary *)options
{
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
    NSMutableDictionary *storeOptions = [options mutableCopy];
    [storeOptions addEntriesFromDictionary:self.storeOptions];

    [coordinator MR_addAutoMigratingSqliteStoreAtURL:self.storeURL withOptions:storeOptions];

    return coordinator;
}

- (NSDictionary *)defaultStoreOptions
{
    NSMutableDictionary *options = [super defaultStoreOptions].mutableCopy;
    [options addEntriesFromDictionary:[NSDictionary MR_autoMigrationOptions]];
    return options;
}

@end
