//
//  MagicalRecord+Setup.m
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord+Setup.h"
#import "NSManagedObject+MagicalRecord.h"
#import "NSPersistentStoreCoordinator+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "SQLiteMagicalRecordStack.h"
#import "AutoMigratingMagicalRecordStack.h"
#import "ManuallyMigratingMagicalRecordStack.h"
#import "InMemoryMagicalRecordStack.h"
#import "iCloudMagicalRecordStack.h"
#import "MagicalRecordLogging.h"


@implementation MagicalRecord (Setup)

+ (MagicalRecordStack *) setupCoreDataStack
{
    MagicalRecordStack *stack = [[SQLiteMagicalRecordStack alloc] init];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *)setupCoreDataStackWithStoreAtURL:(NSURL *)url;
{
    MagicalRecordStack *stack = [[SQLiteMagicalRecordStack alloc] initWithStoreAtURL:url];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *)setupCoreDataStackWithStoreNamed:(NSString *)storeName;
{
    MagicalRecordStack *stack = [[SQLiteMagicalRecordStack alloc] initWithStoreNamed:storeName];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupAutoMigratingCoreDataStack;
{
    MagicalRecordStack *stack = [[AutoMigratingMagicalRecordStack alloc] init];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupAutoMigratingCoreDataStackWithSqliteStoreNamed:(NSString *)storeName;
{
    MagicalRecordStack *stack = [[AutoMigratingMagicalRecordStack alloc] initWithStoreNamed:storeName];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupAutoMigratingCoreDataStackWithSqliteStoreAtURL:(NSURL *)url;
{
    MagicalRecordStack *stack = [[AutoMigratingMagicalRecordStack alloc] initWithStoreAtURL:url];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupManuallyMigratingCoreDataStack;
{
    MagicalRecordStack *stack = [[ManuallyMigratingMagicalRecordStack alloc] init];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupManuallyMigratingCoreDataStackWithSqliteStoreNamed:(NSString *)storeName;
{
    MagicalRecordStack *stack = [[ManuallyMigratingMagicalRecordStack alloc] initWithStoreNamed:storeName];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupManuallyMigratingCoreDataStackWithSqliteStoreAtURL:(NSURL *)url;
{
    MagicalRecordStack *stack = [[ManuallyMigratingMagicalRecordStack alloc] initWithStoreAtURL:url];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupCoreDataStackWithInMemoryStore;
{
    MagicalRecordStack *stack = [[InMemoryMagicalRecordStack alloc] init];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupCoreDataStackWithiCloudContainer:(NSString *)icloudBucket localStoreNamed:(NSString *)localStore;
{
    MagicalRecordStack *stack = [[iCloudMagicalRecordStack alloc] initWithContainerID:icloudBucket localStoreName:localStore];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent;
{
    MagicalRecordStack *stack = [[iCloudMagicalRecordStack alloc] initWithContainerID:containerID
                                                                       contentNameKey:contentNameKey
                                                              cloudStorePathComponent:pathSubcomponent
                                                                       localStoreName:localStoreName];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent completion:(void(^)(void))completion;
{
    iCloudMagicalRecordStack *stack = [[iCloudMagicalRecordStack alloc] initWithContainerID:containerID contentNameKey:contentNameKey cloudStorePathComponent:pathSubcomponent localStoreName:localStoreName];
    stack.setupCompletionBlock = completion;

    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

@end
