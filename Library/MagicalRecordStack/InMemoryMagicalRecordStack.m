//
//  InMemoryMagicalRecordStack.m
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordStack+Private.h"
#import "InMemoryMagicalRecordStack.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSPersistentStoreCoordinator+MagicalInMemoryStoreAdditions.h"

@implementation InMemoryMagicalRecordStack

- (NSManagedObjectContext *)newPrivateContext
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_privateQueueContext];
    context.parentContext = self.context;

    return context;
}

- (NSPersistentStoreCoordinator *)createCoordinatorWithOptions:(NSDictionary *)options
{
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];

    [coordinator MR_addInMemoryStoreWithOptions:options];

    return coordinator;
}

@end
