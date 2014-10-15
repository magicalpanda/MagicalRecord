//
//  MagicalRecord+Setup.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"

#define CoreDataMainThread [MagicalRecord MR_mainThread]

@interface MagicalRecord (Setup)

+ (void)MR_setMainThread:(NSOperationQueue*)queue;//default thread = MainQueue
+ (NSOperationQueue*)MR_mainThread;

+ (void) setupCoreDataStack;
+ (void) setupCoreDataStackWithInMemoryStore;
+ (void) setupAutoMigratingCoreDataStack;

+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName;
+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(NSString *)storeName;

+ (void) setupCoreDataStackWithStoreAtURL:(NSURL *)storeURL;
+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreAtURL:(NSURL *)storeURL;


@end
