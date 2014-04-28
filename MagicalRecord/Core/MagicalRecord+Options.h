//
//  MagicalRecord+Options.h
//  Magical Record
//
//  Created by Saul Mora on 3/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"

/**
 Defines "levels" of logging that will be used as values in a bitmask that filters log messages.

 @since Available in v2.3 and later.
 */
typedef NS_ENUM (NSInteger, MagicalRecordLogLevel)
{
    /** Disable all logging */
    MagicalRecordLogLevelOff = 0,

    /** Log fatal errors */
    MagicalRecordLogLevelFatal = 1 << 0,

    /** Log all errors */
    MagicalRecordLogLevelError = 1 << 1,

    /** Log warnings, and all errors */
    MagicalRecordLogLevelWarn = 1 << 2,

    /** Log informative messagess, warnings and all errors */
    MagicalRecordLogLevelInfo = 1 << 3,

    /** Log verbose diagnostic information, messages, warnings and all errors */
    MagicalRecordLogLevelVerbose = 1 << 4,
};

/**
 Defines a mask for logging that will be used by to filter log messages.

 @since Available in v2.3 and later.
 */
typedef NS_ENUM (NSInteger, MagicalRecordLoggingMask)
{
    /** Don't log anything */
    MagicalRecordLogMaskOff = 0,

    /** Log all fatal messages */
    MagicalRecordLoggingMaskFatal = (MagicalRecordLogLevelFatal),

    /** Log all errors and fatal messages */
    MagicalRecordLoggingMaskError = (MagicalRecordLogLevelFatal | MagicalRecordLogLevelError),

    /** Log warnings, errors and fatal messages */
    MagicalRecordLoggingMaskWarn = (MagicalRecordLogLevelFatal | MagicalRecordLogLevelError | MagicalRecordLogLevelWarn),

    /** Log informative, warning and error messages */
    MagicalRecordLoggingMaskInfo = (MagicalRecordLogLevelFatal | MagicalRecordLogLevelError | MagicalRecordLogLevelWarn | MagicalRecordLogLevelInfo),

    /** Log verbose diagnostic, informative, warning and error messages */
    MagicalRecordLoggingMaskVerbose = (MagicalRecordLogLevelFatal | MagicalRecordLogLevelError | MagicalRecordLogLevelWarn | MagicalRecordLogLevelInfo | MagicalRecordLogLevelVerbose),
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
 @name Logging Mask
 */

/**
 Returns the logging mask set for MagicalRecord in the current application.

 @return Current MagicalRecordLogMask

 @since Available in v2.3 and later.
 */
+ (MagicalRecordLoggingMask) loggingMask;

/**
 Sets the logging mask set for MagicalRecord in the current application.

 @param mask Any value from MagicalRecordLogMask

 @since Available in v2.3 and later.
 */
+ (void) setLoggingMask:(MagicalRecordLoggingMask)mask;

@end
