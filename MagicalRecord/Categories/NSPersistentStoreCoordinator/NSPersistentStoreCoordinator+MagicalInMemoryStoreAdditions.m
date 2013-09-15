//
//  NSPersistentStoreCoordinator+MagicalInMemoryStoreAdditions.m
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "NSPersistentStoreCoordinator+MagicalInMemoryStoreAdditions.h"
#import "NSDictionary+MagicalRecordAdditions.h"
#import "NSPersistentStoreCoordinator+MagicalRecord.h"
#import "MagicalRecordStack.h"
#import "NSError+MagicalRecordErrorHandling.h"

@implementation NSPersistentStoreCoordinator (MagicalInMemoryStoreAdditions)

- (NSPersistentStore *) MR_addInMemoryStore
{
    NSError *error = nil;
    NSPersistentStore *store = [self addPersistentStoreWithType:NSInMemoryStoreType
                                                  configuration:nil
                                                            URL:nil
                                                        options:nil
                                                          error:&error];
    if (!store)
    {
        [[error MR_coreDataDescription] MR_logToConsole];
    }
    return store;
}

#pragma mark - Public Class Methods

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithInMemoryStore
{
	NSManagedObjectModel *model = [[MagicalRecordStack defaultStack] model];
	NSPersistentStoreCoordinator *coordinator = [[self alloc] initWithManagedObjectModel:model];

    [coordinator MR_addInMemoryStore];

    return coordinator;
}

@end
