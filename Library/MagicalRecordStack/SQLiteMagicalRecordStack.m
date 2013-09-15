//
//  SQLiteMagicalRecordStack.m
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "SQLiteMagicalRecordStack.h"
#import "NSPersistentStoreCoordinator+MagicalRecord.h"


@interface SQLiteMagicalRecordStack ()

@property (nonatomic, copy, readwrite) NSURL *storeURL;

@end


@implementation SQLiteMagicalRecordStack

- (instancetype) init;
{
    return [self initWithStoreNamed:[MagicalRecord defaultStoreName]];
}

- (instancetype) initWithStoreNamed:(NSString *)name;
{
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:name];
    return [self initWithStoreAtURL:storeURL];
}

- (instancetype) initWithStoreAtPath:(NSString *)path;
{
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    return [self initWithStoreAtURL:storeURL];
}

- (instancetype) initWithStoreAtURL:(NSURL *)url;
{
    self = [super init];
    if (self)
    {
        MRLog(@"Init with store at URL: %@", url);
        _storeURL = url;
    }
    return self;
}

- (NSPersistentStoreCoordinator *) createCoordinator;
{
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
    [coordinator MR_addSqliteStoreAtURL:self.storeURL withOptions:nil];
    return coordinator;
}


@end
