//
//  MagicalRecordStack.m
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordStack.h"
#import "MagicalRecord.h"

#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSPersistentStore+MagicalRecord.h"
#import "NSManagedObjectModel+MagicalRecord.h"

static MagicalRecordStack *defaultStack;

@interface MagicalRecordStack ()

@end


@implementation MagicalRecordStack

- (NSString *) description;
{
    NSMutableString *status = [NSMutableString string];

    [status appendFormat:@"Model:           %@\n", [[self model] entityVersionHashesByName]];
    [status appendFormat:@"Coordinator:     %@\n", [self coordinator]];
    [status appendFormat:@"Store:           %@\n", [self store]];
    [status appendFormat:@"Default Context: %@\n", [[self context] MR_description]];

    return status;
}

+ (instancetype) defaultStack;
{
    NSAssert(defaultStack, @"No Default Stack Found. Did you forget to setup MagicalRecord?");
    return defaultStack;
}

+ (void) setDefaultStack:(MagicalRecordStack *)stack;
{
    defaultStack = stack;
}

- (NSManagedObjectContext *) context;
{
    if (_context == nil)
    {
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_context setPersistentStoreCoordinator:[self coordinator]];
    }
    return _context;
}

- (NSManagedObjectModel *) model;
{
    if (_model == nil)
    {
        _model = [NSManagedObjectModel MR_mergedObjectModelFromMainBundle];
    }
    return _model;
}

- (NSPersistentStoreCoordinator *)coordinator;
{
    if (_coordinator == nil)
    {
        _coordinator = [self createCoordinator];
    }
    return nil;
}

- (NSPersistentStoreCoordinator *) createCoordinator;
{
    return nil;
}

@end
