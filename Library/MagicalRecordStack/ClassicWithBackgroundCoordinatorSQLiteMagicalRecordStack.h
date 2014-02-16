//
//  DualContextDualCoordinatorMagicalRecordStack.h
//  MagicalRecord
//
//  Created by Saul Mora on 10/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "ClassicSQLiteMagicalRecordStack.h"

@interface ClassicWithBackgroundCoordinatorSQLiteMagicalRecordStack : ClassicSQLiteMagicalRecordStack

@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *backgroundCoordinator;

@end
