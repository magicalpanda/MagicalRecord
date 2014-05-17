//
//  SQLiteMagicalRecordStack.m
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordStack+Private.h"
#import "SQLiteMagicalRecordStack.h"
#import "NSPersistentStoreCoordinator+MagicalRecord.h"
#import "MagicalRecordLogging.h"

@interface SQLiteMagicalRecordStack ()

@property (nonatomic, copy, readwrite) NSURL *storeURL;

@end


@implementation SQLiteMagicalRecordStack

+ (instancetype) stackWithStoreNamed:(NSString *)name;
{
    return [[self alloc] initWithStoreNamed:name];
}

+ (instancetype) stackWithStoreAtURL:(NSURL *)url;
{
    return [[self alloc] initWithStoreAtURL:url];
}

+ (instancetype) stackWithStoreAtPath:(NSString *)path;
{
    return [[self alloc] initWithStoreAtPath:path];
}

+ (instancetype) stackWithStoreNamed:(NSString *)name model:(NSManagedObjectModel *)model;
{
    return [[self alloc] initWithStoreNamed:name model:model];
}

+ (instancetype) stackWithStoreAtURL:(NSURL *)url model:(NSManagedObjectModel *)model;
{
    return [[self alloc] initWithStoreAtURL:url model:model];
}

+ (instancetype) stackWithStoreAtPath:(NSString *)path model:(NSManagedObjectModel *)model;
{
    return [[self alloc] initWithStoreAtPath:path model:model];
}

- (instancetype) init;
{
    return [self initWithStoreNamed:[MagicalRecord defaultStoreName]];
}

- (instancetype) initWithStoreNamed:(NSString *)name;
{
    NSURL *storeURL = [NSPersistentStore MR_fileURLForStoreName:name];
    return [self initWithStoreAtURL:storeURL];
}

- (instancetype) initWithStoreAtPath:(NSString *)path;
{
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    return [self initWithStoreAtURL:storeURL];
}

- (instancetype) initWithStoreAtURL:(NSURL *)url;
{
    return [self initWithStoreAtURL:url model:nil];
}

- (instancetype) initWithStoreAtPath:(NSString *)path model:(NSManagedObjectModel *)model;
{
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    return [self initWithStoreAtURL:storeURL model:model];
}

- (instancetype) initWithStoreNamed:(NSString *)name model:(NSManagedObjectModel *)model;
{
    NSURL *storeURL = [NSPersistentStore MR_fileURLForStoreName:name];
    return [self initWithStoreAtURL:storeURL model:model];
}

- (instancetype) initWithStoreAtURL:(NSURL *)url model:(NSManagedObjectModel *)model;
{
    NSParameterAssert(url);

    self = [super init];
    if (self)
    {
        _storeURL = url;
        self.model = model;
    }
    return self;
}

- (NSDictionary *) defaultStoreOptions;
{
    NSDictionary *options = @{ MagicalRecordShouldDeletePersistentStoreOnModelMismatchKey:
                                   @(self.shouldDeletePersistentStoreOnModelMismatch) };
    return options;
}

- (NSPersistentStoreCoordinator *)createCoordinator
{
    return [self createCoordinatorWithOptions:[self defaultStoreOptions]];
}

- (NSManagedObjectContext *) newConfinementContext;
{
    NSManagedObjectContext *context = [super newConfinementContext];
    [context setParentContext:[self context]];
    return context;
}

- (NSPersistentStoreCoordinator *)createCoordinatorWithOptions:(NSDictionary *)options;
{
    MRLogVerbose(@"Loading Store at URL: %@", self.storeURL);
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];

    NSMutableDictionary *storeOptions = [[self defaultStoreOptions] mutableCopy];
    [storeOptions addEntriesFromDictionary:self.storeOptions];
    
    [coordinator MR_addSqliteStoreAtURL:self.storeURL withOptions:storeOptions];

    return coordinator;
}


@end
