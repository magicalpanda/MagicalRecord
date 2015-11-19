//
//  Copyright © 2013 Magical Panda Software LLC. All rights reserved.

#import "MagicalRecordStack.h"

@interface MagicalRecordStack ()

- (nonnull NSPersistentStoreCoordinator *)createCoordinator;
- (nonnull NSPersistentStoreCoordinator *)createCoordinatorWithOptions:(nullable NSDictionary *)options;

- (nonnull NSManagedObjectContext *)createConfinementContext;
- (void)loadStack;

@end
