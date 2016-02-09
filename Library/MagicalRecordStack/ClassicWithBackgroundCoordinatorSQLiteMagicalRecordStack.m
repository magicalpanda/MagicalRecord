//
//  DualContextDualCoordinatorMagicalRecordStack.m
//  MagicalRecord
//
//  Created by Saul Mora on 10/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "ClassicWithBackgroundCoordinatorSQLiteMagicalRecordStack.h"
#import "NSPersistentStoreCoordinator+MagicalRecord.h"
#import "NSDictionary+MagicalRecordAdditions.h"
#import "NSManagedObjectContext+MagicalObserving.h"
#import "NSManagedObjectContext+MagicalRecord.h"

#import "MagicalRecordLogging.h"

@interface ClassicWithBackgroundCoordinatorSQLiteMagicalRecordStack ()

@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *backgroundCoordinator;

@end

@implementation ClassicWithBackgroundCoordinatorSQLiteMagicalRecordStack

- (NSString *)description
{
    NSMutableString *description = [[super description] mutableCopy];

    [description appendFormat:@"Background Coordinator:     %@\n", self.backgroundCoordinator];

    return [NSString stringWithString:description];
}

- (NSManagedObjectContext *)newPrivateQueueContext
{
    //TODO: need to setup backgroundContext -> context merges via NSNC, and unsubscribe automatically
    NSManagedObjectContext *context = [super newPrivateQueueContext];
    context.persistentStoreCoordinator = self.backgroundCoordinator;
    return context;
}

- (NSPersistentStoreCoordinator *)backgroundCoordinator
{
    if (_backgroundCoordinator == nil)
    {
        _backgroundCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
        [_backgroundCoordinator MR_addSqliteStoreAtURL:[self storeURL] withOptions:[self defaultStoreOptions]];
    }
    return _backgroundCoordinator;
}

@end
