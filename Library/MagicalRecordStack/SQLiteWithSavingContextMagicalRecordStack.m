//
//  ThreadedSQLiteMagicalRecordStack.m
//  MagicalRecord
//
//  Created by Saul Mora on 9/15/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordStack+Private.h"
#import "SQLiteWithSavingContextMagicalRecordStack.h"
#import "NSManagedObjectContext+MagicalObserving.h"
#import "NSManagedObjectContext+MagicalRecord.h"

@interface SQLiteWithSavingContextMagicalRecordStack ()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *savingContext;

@end


@implementation SQLiteWithSavingContextMagicalRecordStack

@synthesize context = _context;

- (void)dealloc;
{
    [self.savingContext MR_stopObservingContext:self.context];
}

- (NSManagedObjectContext *) context;
{
    if (_savingContext == nil)
    {
        _savingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_savingContext setPersistentStoreCoordinator:[self coordinator]];
    }

    if (_context == nil)
    {
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_context setPersistentStoreCoordinator:[self coordinator]];

        [_context MR_observeContextOnMainThread:_savingContext];
    }

    return _context;
}

- (NSManagedObjectContext *) newConfinementContext;
{
    NSManagedObjectContext *context = [super newConfinementContext];
    [context setParentContext:[self savingContext]];
    return context;
}

@end
