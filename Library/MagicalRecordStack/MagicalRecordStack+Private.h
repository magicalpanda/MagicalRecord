//
//  MagicalRecordStack_Private.h
//  MagicalRecord
//
//  Created by Saul Mora on 9/15/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordStack.h"

@interface MagicalRecordStack ()

- (NSPersistentStoreCoordinator *) createCoordinator;
- (NSPersistentStoreCoordinator *) createCoordinatorWithOptions:(NSDictionary *)options;

- (NSManagedObjectContext *) createConfinementContext;
- (void) loadStack;

@end
