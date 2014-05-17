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

- (NSString *)description;
{
    NSMutableString *description = [[super description] mutableCopy];

    [description appendFormat:@"Background Coordinator:     %@\n", self.backgroundCoordinator];
    
    return [NSString stringWithString:description];
}

- (void)reset;
{
    self.backgroundCoordinator = nil;
    [super reset];
}

- (NSManagedObjectContext *) newConfinementContext;
{
    //TODO: need to setup backgroundContext -> context merges via NSNC, and unsubscribe automatically
    NSManagedObjectContext *backgroundContext = [NSManagedObjectContext MR_confinementContext];
    [backgroundContext setPersistentStoreCoordinator:self.backgroundCoordinator];
    return backgroundContext;
}

- (NSPersistentStoreCoordinator *)backgroundCoordinator;
{
    if (_backgroundCoordinator == nil)
    {
        _backgroundCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
        [_backgroundCoordinator MR_addSqliteStoreAtURL:[self storeURL] withOptions:[self defaultStoreOptions]];
    }
    return _backgroundCoordinator;
}


@end
