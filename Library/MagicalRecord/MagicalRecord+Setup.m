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
#import "DualContextDualCoordinatorMagicalRecordStack.h"
#import "InMemoryMagicalRecordStack.h"
#import "iCloudMagicalRecordStack.h"
#import "MagicalRecordLogging.h"


@implementation MagicalRecord (Setup)

+ (MagicalRecordStack *) setupSQLiteStack
{
    MagicalRecordStack *stack = [[SQLiteMagicalRecordStack alloc] init];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *)setupSQLiteStackWithStoreAtURL:(NSURL *)url;
{
    MagicalRecordStack *stack = [[SQLiteMagicalRecordStack alloc] initWithStoreAtURL:url];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *)setupSQLiteStackWithStoreNamed:(NSString *)storeName;
{
    MagicalRecordStack *stack = [[SQLiteMagicalRecordStack alloc] initWithStoreNamed:storeName];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupAutoMigratingStack;
{
    MagicalRecordStack *stack = [[AutoMigratingMagicalRecordStack alloc] init];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupAutoMigratingStackWithSQLiteStoreNamed:(NSString *)storeName;
{
    MagicalRecordStack *stack = [[AutoMigratingMagicalRecordStack alloc] initWithStoreNamed:storeName];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupAutoMigratingStackWithSQLiteStoreAtURL:(NSURL *)url;
{
    MagicalRecordStack *stack = [[AutoMigratingMagicalRecordStack alloc] initWithStoreAtURL:url];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupManuallyMigratingStack;
{
    MagicalRecordStack *stack = [[ManuallyMigratingMagicalRecordStack alloc] init];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupManuallyMigratingStackWithSQLiteStoreNamed:(NSString *)storeName;
{
    MagicalRecordStack *stack = [[ManuallyMigratingMagicalRecordStack alloc] initWithStoreNamed:storeName];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupManuallyMigratingStackWithSQLiteStoreAtURL:(NSURL *)url;
{
    MagicalRecordStack *stack = [[ManuallyMigratingMagicalRecordStack alloc] initWithStoreAtURL:url];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupDualContextDualCoordinatorStack;
{
    MagicalRecordStack *stack = [[DualContextDualCoordinatorMagicalRecordStack alloc] init];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupDualContextDualCoordinatorStackWithSQLiteStoreNamed:(NSString *)storeName;
{
    MagicalRecordStack *stack = [[DualContextDualCoordinatorMagicalRecordStack alloc] initWithStoreNamed:storeName];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupDualContextDualCoordinatorStackWithSQLiteStoreAtURL:(NSURL *)storeURL;
{
    MagicalRecordStack *stack = [[DualContextDualCoordinatorMagicalRecordStack alloc] initWithStoreAtURL:storeURL];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupStackWithInMemoryStore;
{
    MagicalRecordStack *stack = [[InMemoryMagicalRecordStack alloc] init];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupStackWithiCloudContainer:(NSString *)icloudBucket localStoreNamed:(NSString *)localStore;
{
    MagicalRecordStack *stack = [[iCloudMagicalRecordStack alloc] initWithContainerID:icloudBucket localStoreName:localStore];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent;
{
    MagicalRecordStack *stack = [[iCloudMagicalRecordStack alloc] initWithContainerID:containerID
                                                                       contentNameKey:contentNameKey
                                                              cloudStorePathComponent:pathSubcomponent
                                                                       localStoreName:localStoreName];
    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

+ (MagicalRecordStack *) setupStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent completion:(void(^)(void))completion;
{
    iCloudMagicalRecordStack *stack = [[iCloudMagicalRecordStack alloc] initWithContainerID:containerID contentNameKey:contentNameKey cloudStorePathComponent:pathSubcomponent localStoreName:localStoreName];
    stack.setupCompletionBlock = completion;

    [MagicalRecordStack setDefaultStack:stack];
    return stack;
}

@end
