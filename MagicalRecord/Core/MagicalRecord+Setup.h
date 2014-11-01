//
//  MagicalRecord+Setup.h
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"

/**
 use it to access to DefaultContexts and as queue for NSFetchedResultsController
 
 if CoreDataMainThread != mainThread,
 
 NSFetchedResultsController mast be created and inited on thread of it context!!!
*/

#define CoreDataMainThread [MagicalRecord MR_mainThread]

@interface MagicalRecord (Setup)

/**
 Setup this before setup core data stack, use for it:
 
        [MagicalRecord MR_setMainThread:CoreDataMainQueue];
 generate assert if called after stack setup. 
 defuel value = MainQueue
*/

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
