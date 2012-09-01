//
// Created by svanter on 8/31/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MagicalRecordParallelStoresPersistenceStrategy.h"
#import "NSManagedObjectContext+MagicalRecordInternal.h"


@implementation MagicalRecordParallelStoresPersistenceStrategy

- (void)setUpContextsWithCoordinator:(NSPersistentStoreCoordinator *)coordinator {
    MRLog(@"On iOS 5, nested contexts are trouble. Using parallel PSC's!");
    // We can't do nested contexts, so let's create a seperate psc and merge from there to main thread context

    NSPersistentStore *store = [[coordinator persistentStores] lastObject];
    NSPersistentStoreCoordinator *backgroundCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:coordinator.managedObjectModel];
    [backgroundCoordinator addPersistentStoreWithType:store.type
                                        configuration:nil
                                                  URL:store.URL
                                              options:store.options
                                                error:nil];
    
    NSManagedObjectContext *rootContext = [NSManagedObjectContext MR_contextWithStoreCoordinator:backgroundCoordinator];
    rootContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    [NSManagedObjectContext MR_setRootSavingContext:rootContext];

    // Now set up the UIQueue
    NSManagedObjectContext *defaultContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    defaultContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    // Use the coordinator passed in
    [defaultContext setPersistentStoreCoordinator:coordinator];
    [NSManagedObjectContext MR_setDefaultContext:defaultContext];

    [NSManagedObjectContext MR_makeContext:rootContext mergeChangesToContext:defaultContext];
    [NSManagedObjectContext MR_makeContext:defaultContext mergeChangesToContext:rootContext];
}

- (NSManagedObjectContext *)contextToUseForBackgroundSaves
{
    NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_rootSavingContext];
    return [NSManagedObjectContext MR_contextWithParent:mainContext];
}

@end
