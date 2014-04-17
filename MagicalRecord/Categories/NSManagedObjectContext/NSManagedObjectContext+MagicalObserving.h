//
//  NSManagedObjectContext+MagicalObserving.h
//  Magical Record
//
//  Created by Saul Mora on 3/9/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

extern NSString * const kMagicalRecordDidMergeChangesFromiCloudNotification;

@interface NSManagedObjectContext (MagicalObserving)

- (void) MR_observeContext:(NSManagedObjectContext *)otherContext;
- (void) MR_stopObservingContext:(NSManagedObjectContext *)otherContext;

- (void) MR_observeContextOnMainThread:(NSManagedObjectContext *)otherContext;

- (void) MR_observeiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator;
- (void) MR_stopObservingiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator;

@end
