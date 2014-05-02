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

/**
 @name Configuration Options
 */

/**
 If this is true, the default managed object model will be automatically created if it doesn't exist when calling `[NSManagedObjectModel MR_defaultManagedObjectModel]`.

 @return current value of shouldAutoCreateManagedObjectModel.

 @since Available in v2.0.4 and later
 */
+ (BOOL) shouldAutoCreateManagedObjectModel;

/**
 Setting this to true will make MagicalRecord create the default managed object model automatically if it doesn't exist when calling `[NSManagedObjectModel MR_defaultManagedObjectModel]`.

 @param autoCreate BOOL value that flags whether the default persistent store should be automatically created.

 @since Available in v2.0.4 and later
 */
+ (void) setShouldAutoCreateManagedObjectModel:(BOOL)autoCreate;

/**
 If this is true, the default persistent store will be automatically created if it doesn't exist when calling `[NSPersistentStoreCoordinator MR_defaultStoreCoordinator]`.

 @return current value of shouldAutoCreateDefaultPersistentStoreCoordinator.

 @since Available in v2.0.4 and later
 */
+ (BOOL) shouldAutoCreateDefaultPersistentStoreCoordinator;

/**
 Setting this to true will make MagicalRecord create the default persistent store automatically if it doesn't exist when calling `[NSPersistentStoreCoordinator MR_defaultStoreCoordinator]`.

 @param autoCreate BOOL value that flags whether the default persistent store should be automatically created.

 @since Available in v2.0.4 and later
 */
+ (void) setShouldAutoCreateDefaultPersistentStoreCoordinator:(BOOL)autoCreate;

/**
 If this is true and MagicalRecord encounters a store with a version that does not match that of the model, the store will be removed from the disk.
 This is extremely useful during development where frequent model changes can potentially require a delete and reinstall of the app.

 @return current value of shouldDeleteStoreOnModelMismatch
 
 @since Available in v2.0.4 and later
 */
+ (BOOL) shouldDeleteStoreOnModelMismatch;

/**
 Setting this to true will make MagicalRecord delete any stores that it encounters which do not match the version of their model.
 This is extremely useful during development where frequent model changes can potentially require a delete and reinstall of the app.

 @param shouldDelete BOOL value that flags whether mismatched stores should be deleted
 
 @since Available in v2.0.4 and later
 */
+ (void) setShouldDeleteStoreOnModelMismatch:(BOOL)shouldDelete;

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
