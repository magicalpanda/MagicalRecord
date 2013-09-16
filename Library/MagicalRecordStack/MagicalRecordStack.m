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
    [status appendFormat:@"Context:         %@\n", [[self context] MR_description]];

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

+ (instancetype) stack;
{
    return [[self alloc] init];
}

//- (id) init;
//{
//    NSAssert(NO, @"%@ is an Abstract Class. Use one of the subclasses", NSStringFromClass([self class]));
//    return nil;
//}

- (void) setModelFromClass:(Class)klass;
{
    NSBundle *bundle = [NSBundle bundleForClass:klass];
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:bundle]];
    [self setModel:model];
}

- (void) setModelNamed:(NSString *)modelName;
{
    NSManagedObjectModel *model = [NSManagedObjectModel MR_managedObjectModelNamed:modelName];
    [self setModel:model];
}

- (void) reset;
{
    self.context = nil;
    self.model = nil;
    self.coordinator = nil;
    self.store = nil;
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

- (NSString *) stackName;
{
    if (_stackName == nil)
    {
        _stackName = [NSString stringWithFormat:@"%@ [%p]", NSStringFromClass([self class]), self];
    }
    return _stackName;
}

- (NSManagedObjectContext *) newConfinementContext;
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_confinementContext];
    NSString *workingName = [[context MR_workingName] stringByAppendingFormat:@" (%@)", [self stackName]];
    [context setParentContext:[self context]];
    [context MR_setWorkingName:workingName];
    return context;
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
        _store = [[_coordinator persistentStores] objectAtIndex:0];
    }
    return _coordinator;
}

- (NSPersistentStoreCoordinator *) createCoordinator;
{
    MRLog(@"%@ must be overridden in %@", NSStringFromSelector(_cmd), NSStringFromClass([self class]));
    return nil;
}

@end
