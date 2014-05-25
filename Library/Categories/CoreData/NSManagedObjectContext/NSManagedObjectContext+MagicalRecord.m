//
//  NSManagedObjectContext+MagicalRecord.m
//
//  Created by Saul Mora on 11/23/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "MagicalRecord.h"
#import "MagicalRecordStack.h"
#import "MagicalRecordLogging.h"
#import <objc/runtime.h>

NSString * MR_concurrencyStringFromType(NSManagedObjectContextConcurrencyType type);
NSString * MR_concurrencyStringFromType(NSManagedObjectContextConcurrencyType type)
{
    if (type == NSPrivateQueueConcurrencyType) { return @"Private Queue"; }
    if (type == NSMainQueueConcurrencyType) { return @"Main Queue"; }
    if (type == NSConfinementConcurrencyType) {return @"Confinement"; }

    return @"Unknown Concurrency";
}

static id iCloudSetupNotificationObserver = nil;

static NSString * const kMagicalRecordNSManagedObjectContextWorkingName = @"kNSManagedObjectContextWorkingName";

@implementation NSManagedObjectContext (MagicalRecord)

- (NSString *) MR_description;
{
    NSString *onMainThread = [NSThread isMainThread] ? @"*** MAIN THREAD ***" : @"*** BACKGROUND THREAD ***";

    return [NSString stringWithFormat:@"%@ on %@", [self MR_workingName], onMainThread];
}

- (NSString *) MR_debugDescription;
{
    return [NSString stringWithFormat:@"<%@ (%p)> %@ (%@ Concurrency)", NSStringFromClass([self class]), self, [self MR_description], MR_concurrencyStringFromType([self concurrencyType])];
}

- (NSString *) MR_parentChain;
{
    NSMutableString *familyTree = [@"\n" mutableCopy];
    NSManagedObjectContext *currentContext = self;
    do
    {
        [familyTree appendFormat:@"- %@ (%p) %@\n", [currentContext MR_workingName], currentContext, (currentContext == self ? @"(*)" : @"")];
    }
    while ((currentContext = [currentContext parentContext]));

    return [NSString stringWithString:familyTree];
}

- (void) MR_obtainPermanentIDsForObjects:(NSArray *)objects;
{
    NSError *error = nil;
    BOOL success = [self obtainPermanentIDsForObjects:objects error:&error];
    if (!success)
    {
        [[error MR_coreDataDescription] MR_logToConsole];
    }
}

+ (NSManagedObjectContext *) MR_context;
{
    return [self MR_privateQueueContext];
}

+ (NSManagedObjectContext *) MR_confinementContext;
{
    NSManagedObjectContext *context = [[self alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
    [context MR_setWorkingName:@"Confinement"];
    return context;
}

+ (NSManagedObjectContext *) MR_confinementContextWithParent:(NSManagedObjectContext *)parentContext;
{
    NSManagedObjectContext *context = [self MR_confinementContext];
    [context setParentContext:parentContext];
    return context;
}

+ (NSManagedObjectContext *) MR_mainQueueContext;
{
    NSManagedObjectContext *context = [[self alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [context MR_setWorkingName:@"Main Queue"];
    return context;
}

+ (NSManagedObjectContext *) MR_privateQueueContext;
{
    NSManagedObjectContext *context = [[self alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context MR_setWorkingName:@"Private Queue"];
    return context;
}

+ (NSManagedObjectContext *) MR_privateQueueContextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
	NSManagedObjectContext *context = nil;
    if (coordinator != nil)
	{
        context = [self MR_privateQueueContext];
        
        [context performBlockAndWait:^{
            [context setPersistentStoreCoordinator:coordinator];
        }];
        
        MRLogInfo(@"-> Created Context %@", [context MR_workingName]);
    }
    return context;
}

- (void) MR_setWorkingName:(NSString *)workingName;
{
    [[self userInfo] setObject:workingName forKey:kMagicalRecordNSManagedObjectContextWorkingName];
}

- (NSString *) MR_workingName;
{
    NSString *workingName = [[self userInfo] objectForKey:kMagicalRecordNSManagedObjectContextWorkingName];
    if ([workingName length] == 0)
    {
        workingName = @"UNNAMED";
    }
    return workingName;
}


@end
