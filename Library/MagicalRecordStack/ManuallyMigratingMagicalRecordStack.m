//
//  ManuallyMigratingMagicalRecordStack.m
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordStack+Private.h"
#import "ManuallyMigratingMagicalRecordStack.h"
#import "NSPersistentStoreCoordinator+MagicalManualMigrations.h"

@implementation ManuallyMigratingMagicalRecordStack

- (NSPersistentStoreCoordinator *) createCoordinator;
{
    NSPersistentStoreCoordinator
    *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
    [coordinator MR_addManuallyMigratingSqliteStoreAtURL:self.storeURL];

    return coordinator;
}

@end
