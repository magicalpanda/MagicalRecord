//
//  InMemoryMagicalRecordStack.m
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordStack+Private.h"
#import "InMemoryMagicalRecordStack.h"
#import "NSPersistentStoreCoordinator+MagicalInMemoryStoreAdditions.h"

@implementation InMemoryMagicalRecordStack

- (NSPersistentStoreCoordinator *) createCoordinator;
{
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
    [coordinator MR_addInMemoryStore];

    return coordinator;
}

@end
