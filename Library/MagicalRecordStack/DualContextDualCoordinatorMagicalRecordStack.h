//
//  DualContextDualCoordinatorMagicalRecordStack.h
//  MagicalRecord
//
//  Created by Saul Mora on 10/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "SQLiteMagicalRecordStack.h"

@interface DualContextDualCoordinatorMagicalRecordStack : SQLiteMagicalRecordStack

@property (nonatomic, strong, readonly) NSManagedObjectContext *backgroundContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *backgroundCoordinator;

@end
