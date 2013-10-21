//
//  MagicalRecordStack.m
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordStack.h"

#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSPersistentStore+MagicalRecord.h"
#import "NSManagedObjectModel+MagicalRecord.h"
#import "MagicalRecordLogging.h"

static MagicalRecordStack *defaultStack;


@implementation MagicalRecordStack

- (void)dealloc;
{
    [self reset];
}

- (NSString *) description;
{
    NSMutableString *status = [NSMutableString stringWithString:@"\n"];

    [status appendFormat:@"Stack:           %@ (%p)\n", NSStringFromClass([self class]), self];
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
    [stack loadStack];
    MRLogVerbose(@"Default Core Data Stack Initialized: %@", stack);
}

+ (instancetype) stack;
{
    return [[self alloc] init];
}

- (void) loadStack;
{
    NSManagedObjectContext *context = [self context];
    NSString *stackType = NSStringFromClass([self class]);
    NSAssert(context, @"No NSManagedObjectContext for stack [%@]", stackType);
    NSAssert([self model], @"No NSManagedObjectModel loaded for stack [%@]", stackType);
    NSAssert([self store], @"No NSPersistentStore initialized for stack [%@]", stackType);
    NSAssert([self coordinator], @"No NSPersistentStoreCoodinator initialized for stack [%@]", stackType);
}

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
        [_context MR_setWorkingName:[NSString stringWithFormat:@"Main Queue Context (%@)", [self stackName]]];
        [_context setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
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

- (NSManagedObjectContext *) createConfinementContext;
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_confinementContext];
    NSString *workingName = [[context MR_workingName] stringByAppendingFormat:@" (%@)", [self stackName]];
    [context MR_setWorkingName:workingName];
    return context;
}

- (NSManagedObjectContext *) newConfinementContext;
{
    NSManagedObjectContext *context = [self createConfinementContext];
    [context setParentContext:[self context]];

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
        _store = [[_coordinator persistentStores] lastObject];
    }
    return _coordinator;
}

- (NSPersistentStoreCoordinator *) createCoordinator;
{
    MRLogError(@"%@ must be overridden in %@", NSStringFromSelector(_cmd), NSStringFromClass([self class]));
    return nil;
}

@end
