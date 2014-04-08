//
//  NSManagedObjectContext+MagicalObserving.h
//  Magical Record
//
//  Created by Saul Mora on 3/9/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (MagicalObserving)

- (void) MR_observeContext:(NSManagedObjectContext *)otherContext;
- (void) MR_stopObservingContext:(NSManagedObjectContext *)otherContext;
- (void) MR_observeContextOnMainThread:(NSManagedObjectContext *)otherContext;

/**
 *   Observes the 'NSManagedObjectContextDidSaveNotification' notification of the given context and perform a save action on the current managed context object. If the current object it's MR's rootContext, it will persist the changes to the persistant store.
 *
 *  @param otherContext Alternate context that the current context should observe
 */
- (void) MR_observeContextAndSaveChangesToSelf:(NSManagedObjectContext *)otherContext;

- (void) MR_observeiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator;
- (void) MR_stopObservingiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator;

@end
