//
//  DualContextDualCoordinatorMagicalRecordStack.m
//  MagicalRecord
//
//  Created by Saul Mora on 10/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "DualContextDualCoordinatorMagicalRecordStack.h"
#import "NSPersistentStoreCoordinator+MagicalRecord.h"
#import "NSDictionary+MagicalRecordAdditions.h"
#import "NSManagedObjectContext+MagicalObserving.h"
#import "NSManagedObjectContext+MagicalRecord.h"


@interface DualContextDualCoordinatorMagicalRecordStack ()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *backgroundContext;
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *backgroundCoordinator;

@end


@implementation DualContextDualCoordinatorMagicalRecordStack

- (NSString *)description;
{
    NSMutableString *description = [[super description] mutableCopy];

    [description appendFormat:@"Background Context:         %@\n", [self.backgroundContext MR_description]];
    [description appendFormat:@"Background Coordinator:     %@\n", self.backgroundCoordinator];
    
    return [NSString stringWithString:description];
}

- (void)reset;
{
    [[self context] MR_stopObservingContext:self.backgroundContext];
    self.backgroundContext = nil;
    self.backgroundCoordinator = nil;
    [super reset];
}

- (NSManagedObjectContext *)newConfinementContext;
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_confinementContext];
    [context setPersistentStoreCoordinator:self.backgroundCoordinator];
    return context;
}

- (NSManagedObjectContext *)backgroundContext;
{
    if (_backgroundContext == nil)
    {
        _backgroundContext = [NSManagedObjectContext MR_privateQueueContextWithStoreCoordinator:self.backgroundCoordinator];
        NSManagedObjectContext *mainContext = [self context];
        [mainContext MR_observeContext:self.backgroundContext];
        [mainContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
    }
    return _backgroundContext;
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
