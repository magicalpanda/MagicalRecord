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

@implementation AutoMigratingMagicalRecordStack

- (NSPersistentStoreCoordinator *) createCoordinatorWithOptions:(NSDictionary *)options
{
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];

    [coordinator MR_addAutoMigratingSqliteStoreAtURL:self.storeURL];

    return coordinator;
}

@end
