//
//  MagicalRecordNestedContextsPersistenceStrategy.m
//  Magical Record
//
//  Created by Stephen J Vanterpool on 8/31/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordNestedContextsPersistenceStrategy.h"
#import "NSManagedObjectContext+MagicalRecordInternal.h"

@implementation MagicalRecordNestedContextsPersistenceStrategy
- (void)setUpContextsWithCoordinator:(NSPersistentStoreCoordinator *)coordinator {
    MRLog(@"Wohoo! Running iOS 6, using nested contexts!");
    NSManagedObjectContext *rootContext = [NSManagedObjectContext MR_contextWithStoreCoordinator:coordinator];
    [NSManagedObjectContext MR_setRootSavingContext:rootContext];
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_newMainQueueContext];
    [defaultContext setParentContext:rootContext];
    [NSManagedObjectContext MR_setDefaultContext:defaultContext];
    [NSManagedObjectContext MR_makeContext:rootContext mergeChangesToContext:defaultContext];
}

- (NSManagedObjectContext *)contextToUseForBackgroundSaves
{
    NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_rootSavingContext];
    return [NSManagedObjectContext MR_contextWithParent:mainContext];
}

@end
