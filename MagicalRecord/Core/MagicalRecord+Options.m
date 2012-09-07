//
//  MagicalRecord+Options.m
//  Magical Record
//
//  Created by Saul Mora on 3/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord+Options.h"
#import "MagicalRecordPersistenceStrategy.h"
#import "MagicalRecordNestedContextsPersistenceStrategy.h"
#import "MagicalRecordParallelStoresPersistenceStrategy.h"

static BOOL shouldAutoCreateManagedObjectModel_;
static BOOL shouldAutoCreateDefaultPersistentStoreCoordinator_;
static BOOL shouldDeleteStoreOnModelMismatch_;

@implementation MagicalRecord (Options)

#pragma mark - Options

+ (BOOL) shouldAutoCreateManagedObjectModel;
{
    return shouldAutoCreateManagedObjectModel_;
}

+ (void) setShouldAutoCreateManagedObjectModel:(BOOL)shouldAutoCreate;
{
    shouldAutoCreateManagedObjectModel_ = shouldAutoCreate;
}

+ (BOOL) shouldAutoCreateDefaultPersistentStoreCoordinator;
{
    return shouldAutoCreateDefaultPersistentStoreCoordinator_;
}

+ (void) setShouldAutoCreateDefaultPersistentStoreCoordinator:(BOOL)shouldAutoCreate;
{
    shouldAutoCreateDefaultPersistentStoreCoordinator_ = shouldAutoCreate;
}

+ (BOOL) shouldDeleteStoreOnModelMismatch;
{
    return shouldDeleteStoreOnModelMismatch_;
}

+ (void) setShouldDeleteStoreOnModelMismatch:(BOOL)shouldDeleteStoreOnModelMismatch
{
    shouldDeleteStoreOnModelMismatch_ = shouldDeleteStoreOnModelMismatch;
}

+ (BOOL)isRunningiOS6
{
    return NSClassFromString(@"NSUUID") != nil;
}

+ (id<MagicalRecordPersistenceStrategy>)persistenceStrategy
{
    static id<MagicalRecordPersistenceStrategy>strategy;

    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if ([MagicalRecord isRunningiOS6]) {
            strategy= (id<MagicalRecordPersistenceStrategy>)[[MagicalRecordNestedContextsPersistenceStrategy alloc] init];
        } else {
            strategy = (id<MagicalRecordPersistenceStrategy>)[[MagicalRecordParallelStoresPersistenceStrategy alloc] init];
        }
    });

    return strategy;
}
@end
