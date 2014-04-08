//
//  MagicalRecord+Options.h
//  Magical Record
//
//  Created by Saul Mora on 3/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"

typedef NS_ENUM(NSInteger, MagicalRecordLogLevel)
{
    MagicalRecordLogLevelOff        = 0,
    MagicalRecordLogLevelFatal      = 1 << 0,
    MagicalRecordLogLevelError      = 1 << 1,
    MagicalRecordLogLevelWarn       = 1 << 2,
    MagicalRecordLogLevelInfo       = 1 << 3,
    MagicalRecordLogLevelVerbose    = 1 << 4,
};

@interface MagicalRecord (Options)

//global options
// enable/disable logging
// add logging provider
// autocreate new PSC per Store
// autoassign new instances to default store

+ (BOOL) shouldAutoCreateManagedObjectModel;
+ (void) setShouldAutoCreateManagedObjectModel:(BOOL)shouldAutoCreate;
+ (BOOL) shouldAutoCreateDefaultPersistentStoreCoordinator;
+ (void) setShouldAutoCreateDefaultPersistentStoreCoordinator:(BOOL)shouldAutoCreate;

/**
 *  If this is true and MagicalRecord encounters a store with a version that does not match that of the model, the store will be removed from the disk.
 *  This is extremely useful during development where frequent model changes can potentially require a delete and reinstall of the app.
 *
 *  @return current value of shouldDeleteStoreOnModelMismatch
 */
+ (BOOL) shouldDeleteStoreOnModelMismatch;

/**
 *  Setting this to true will make MagicalRecord delete any stores that it encounters which do not match the version of their model.
 *  This is extremely useful during development where frequent model changes can potentially require a delete and reinstall of the app.
 *
 *  @param shouldDeleteStoreOnModelMismatch BOOL value that flags whether mismatched stores should be deleted
 */
+ (void) setShouldDeleteStoreOnModelMismatch:(BOOL)shouldDeleteStoreOnModelMismatch;

/**
 *  Returns the current logging level.
 *
 *  @return the current logging level
 */
+ (MagicalRecordLogLevel) logLevel;

/**
 *  Sets the desired logging level.
 *
 *  @param level MagicalRecordLogLevel value
 */
+ (void) setLogLevel:(MagicalRecordLogLevel)level;

@end
