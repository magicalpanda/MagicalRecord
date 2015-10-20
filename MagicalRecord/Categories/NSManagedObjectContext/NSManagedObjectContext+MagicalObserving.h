//
//  NSManagedObjectContext+MagicalObserving.h
//  Magical Record
//
//  Created by Saul Mora on 3/9/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>

OBJC_EXPORT NSString * __MR_nonnull const kMagicalRecordDidMergeChangesFromiCloudNotification;

/**
 Category methods to aid in observing changes in other contexts.

 @since Available in v2.0 and later.
 */
@interface NSManagedObjectContext (MagicalObserving)

/**
 Merge changes from another context into self.

 @param otherContext Managed object context to observe.

 @since Available in v2.0 and later.
 */
- (void) MR_observeContext:(MR_nonnull NSManagedObjectContext *)otherContext;

/**
 Stops merging changes from the supplied context into self.

 @param otherContext Managed object context to stop observing.

 @since Available in v2.0 and later.
 */
- (void) MR_stopObservingContext:(MR_nonnull NSManagedObjectContext *)otherContext;

/**
 Merges changes from another context into self on the main thread.

 @param otherContext Managed object context to observe.

 @since Available in v2.0 and later.
 */
- (void) MR_observeContextOnMainThread:(MR_nonnull NSManagedObjectContext *)otherContext;

/**
 Merges changes from the supplied persistent store coordinator into self in response to changes from iCloud.

 @param coordinator Persistent store coordinator

 @see -MR_stopObservingiCloudChangesInCoordinator:

 @since Available in v2.0 and later.
 */
- (void) MR_observeiCloudChangesInCoordinator:(MR_nonnull NSPersistentStoreCoordinator *)coordinator;

/**
 Stops observation and merging of changes from the supplied persistent store coordinator in response to changes from iCloud.

 @param coordinator Persistent store coordinator

 @see -MR_observeiCloudChangesInCoordinator:

 @since Available in v2.0 and later.
 */
- (void) MR_stopObservingiCloudChangesInCoordinator:(MR_nonnull NSPersistentStoreCoordinator *)coordinator;

@end
