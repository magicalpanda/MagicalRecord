//
//  MagicalRecord.m
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <libkern/OSAtomic.h>
#import "CoreData+MagicalRecord.h"

static volatile int32_t saveOperationsCount;
static BOOL isWaitingToCleanUp;

@interface MagicalRecord (Internal)

+ (void) cleanUpStack;
+ (void) cleanUpErrorHanding;

@end

@interface NSManagedObjectContext (MagicalRecordInternal)

+ (void) MR_cleanUp;

@end

@implementation MagicalRecord

+ (void) didBeginSaveOperation
{
	OSAtomicIncrement32Barrier(&saveOperationsCount);
}

+ (void) didEndSaveOperation
{
	NSUInteger operationsInProgress = OSAtomicDecrement32Barrier(&saveOperationsCount);
	if (operationsInProgress == 0 && isWaitingToCleanUp) {
		[self cleanUp];
	}
}

+ (NSUInteger) countOfSaveOperationsInProgress
{
	return OSAtomicAdd32Barrier(0, &saveOperationsCount);
}

+ (void) cleanUpWhenFinishedSaving
{
	NSUInteger operationsInProgress = [self countOfSaveOperationsInProgress];
	if (operationsInProgress == 0) {
		[self cleanUp];
	} else {
		isWaitingToCleanUp = YES;
	}
}

+ (void) cancelCleanUpWhenFinishedSaving
{
	isWaitingToCleanUp = NO;
}

+ (BOOL) isWaitingToCleanUp
{
	return isWaitingToCleanUp;
}

+ (void) cleanUp
{
	isWaitingToCleanUp = NO;
    [self cleanUpErrorHanding];
    [self cleanUpStack];
}

+ (void) cleanUpStack;
{
	[NSManagedObjectContext MR_cleanUp];
	[NSManagedObjectModel MR_setDefaultManagedObjectModel:nil];
	[NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:nil];
	[NSPersistentStore MR_setDefaultPersistentStore:nil];
}

+ (NSString *) currentStack
{
    NSMutableString *status = [NSMutableString stringWithString:@"Current Default Core Data Stack: ---- \n"];

    [status appendFormat:@"Model:           %@\n", [[NSManagedObjectModel MR_defaultManagedObjectModel] entityVersionHashesByName]];
    [status appendFormat:@"Coordinator:     %@\n", [NSPersistentStoreCoordinator MR_defaultStoreCoordinator]];
    [status appendFormat:@"Store:           %@\n", [NSPersistentStore MR_defaultPersistentStore]];
    [status appendFormat:@"Default Context: %@\n", [[NSManagedObjectContext MR_defaultContext] MR_description]];
    [status appendFormat:@"Context Chain:   \n%@\n", [[NSManagedObjectContext MR_defaultContext] MR_parentChain]];

    return status;
}

+ (void) setDefaultModelNamed:(NSString *)modelName;
{
    NSManagedObjectModel *model = [NSManagedObjectModel MR_managedObjectModelNamed:modelName];
    [NSManagedObjectModel MR_setDefaultManagedObjectModel:model];
}

+ (void) setDefaultModelFromClass:(Class)klass;
{
    NSBundle *bundle = [NSBundle bundleForClass:klass];
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:bundle]];
    [NSManagedObjectModel MR_setDefaultManagedObjectModel:model];
}

+ (NSString *) defaultStoreName;
{
    NSString *defaultName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(id)kCFBundleNameKey];
    if (defaultName == nil)
    {
        defaultName = kMagicalRecordDefaultStoreFileName;
    }
    if (![defaultName hasSuffix:@"sqlite"]) 
    {
        defaultName = [defaultName stringByAppendingPathExtension:@"sqlite"];
    }

    return defaultName;
}


#pragma mark - initialize

+ (void) initialize;
{
    if (self == [MagicalRecord class]) 
    {
#ifdef MR_SHORTHAND
        [self swizzleShorthandMethods];
#endif
        [self setShouldAutoCreateManagedObjectModel:YES];
        [self setShouldAutoCreateDefaultPersistentStoreCoordinator:NO];
#ifdef DEBUG
        [self setShouldDeleteStoreOnModelMismatch:YES];
#else
        [self setShouldDeleteStoreOnModelMismatch:NO];
#endif
    }
}

@end


