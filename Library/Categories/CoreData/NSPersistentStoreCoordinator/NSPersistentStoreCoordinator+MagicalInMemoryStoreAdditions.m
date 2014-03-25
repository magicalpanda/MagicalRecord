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

#pragma mark - Public Class Methods

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithInMemoryStore
{
	NSManagedObjectModel *defaultStackModel = [[MagicalRecordStack defaultStack] model];

    return [self MR_coordinatorWithInMemoryStoreWithModel:defaultStackModel];
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithInMemoryStoreWithModel:(NSManagedObjectModel *)model
{
    return [self MR_coordinatorWithInMemoryStoreWithModel:model withOptions:nil];
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithInMemoryStoreWithModel:(NSManagedObjectModel *)model withOptions:(NSDictionary *)options
{
	NSPersistentStoreCoordinator *coordinator = [[self alloc] initWithManagedObjectModel:model];

    [coordinator MR_addInMemoryStoreWithOptions:options];

    return coordinator;
}

#pragma mark - Public Instance Methods

- (NSPersistentStore *) MR_addInMemoryStore
{
    return [self MR_addInMemoryStoreWithOptions:nil];
}

- (NSPersistentStore *) MR_addInMemoryStoreWithOptions:(NSDictionary *)options
{
    NSError *error;
    NSPersistentStore *store = [self addPersistentStoreWithType:NSInMemoryStoreType
                                                  configuration:nil
                                                            URL:nil
                                                        options:options
                                                          error:&error];
    if (!store)
    {
        [[error MR_coreDataDescription] MR_logToConsole];
    }

    return store;
}

@end
