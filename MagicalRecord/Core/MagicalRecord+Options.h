//
//  MagicalRecord+Options.h
//  Magical Record
//
//  Created by Saul Mora on 3/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <MagicalRecord/MagicalRecordInternal.h>

/**
 Defines "levels" of logging that will be used as values in a bitmask that filters log messages.

 @since Available in v2.3 and later.
 */
typedef NS_ENUM (NSUInteger, MagicalRecordLoggingMask)
{
    /** Log all errors */
    MagicalRecordLoggingMaskError = 1 << 0,

    /** Log warnings, and all errors */
    MagicalRecordLoggingMaskWarn = 1 << 1,

    /** Log informative messages, warnings and all errors */
    MagicalRecordLoggingMaskInfo = 1 << 2,

    /** Log debugging messages, informative messages, warnings and all errors */
    MagicalRecordLoggingMaskDebug = 1 << 3,

    /** Log verbose diagnostic information, debugging messages, informative messages, messages, warnings and all errors */
    MagicalRecordLoggingMaskVerbose = 1 << 4,
};

/**
 Defines a mask for logging that will be used by to filter log messages.

 @since Available in v2.3 and later.
 */
typedef NS_ENUM (NSUInteger, MagicalRecordLoggingLevel)
{
    /** Don't log anything */
    MagicalRecordLoggingLevelOff = 0,

    /** Log all errors and fatal messages */
    MagicalRecordLoggingLevelError = (MagicalRecordLoggingMaskError),

    /** Log warnings, errors and fatal messages */
    MagicalRecordLoggingLevelWarn = (MagicalRecordLoggingLevelError | MagicalRecordLoggingMaskWarn),

    /** Log informative, warning and error messages */
    MagicalRecordLoggingLevelInfo = (MagicalRecordLoggingLevelWarn | MagicalRecordLoggingMaskInfo),

    /** Log all debugging, informative, warning and error messages */
    MagicalRecordLoggingLevelDebug = (MagicalRecordLoggingLevelInfo | MagicalRecordLoggingMaskDebug),

    /** Log verbose diagnostic, debugging, informative, warning and error messages */
    MagicalRecordLoggingLevelVerbose = (MagicalRecordLoggingLevelDebug | MagicalRecordLoggingMaskVerbose),

    /** Log everything */
    MagicalRecordLoggingLevelAll = NSUIntegerMax
};


@interface MagicalRecord (Options)

/**
 @name Configuration Options
 */

/**
 If this is true, the default managed object model will be automatically created if it doesn't exist when calling `[NSManagedObjectModel MR_defaultManagedObjectModel]`.

 @return current value of shouldAutoCreateManagedObjectModel.

 @since Available in v2.0.4 and later.
 */
+ (BOOL) shouldAutoCreateManagedObjectModel;

/**
 Setting this to true will make MagicalRecord create the default managed object model automatically if it doesn't exist when calling `[NSManagedObjectModel MR_defaultManagedObjectModel]`.

 @param autoCreate BOOL value that flags whether the default persistent store should be automatically created.

 @since Available in v2.0.4 and later.
 */
+ (void) setShouldAutoCreateManagedObjectModel:(BOOL)autoCreate;

/**
 If this is true, the default persistent store will be automatically created if it doesn't exist when calling `[NSPersistentStoreCoordinator MR_defaultStoreCoordinator]`.

 @return current value of shouldAutoCreateDefaultPersistentStoreCoordinator.

 @since Available in v2.0.4 and later.
 */
+ (BOOL) shouldAutoCreateDefaultPersistentStoreCoordinator;

/**
 Setting this to true will make MagicalRecord create the default persistent store automatically if it doesn't exist when calling `[NSPersistentStoreCoordinator MR_defaultStoreCoordinator]`.

 @param autoCreate BOOL value that flags whether the default persistent store should be automatically created.

 @since Available in v2.0.4 and later.
 */
+ (void) setShouldAutoCreateDefaultPersistentStoreCoordinator:(BOOL)autoCreate;

/**
 If this is true and MagicalRecord encounters a store with a version that does not match that of the model, the store will be removed from the disk.
 This is extremely useful during development where frequent model changes can potentially require a delete and reinstall of the app.

 @return current value of shouldDeleteStoreOnModelMismatch
 
 @since Available in v2.0.4 and later.
 */
+ (BOOL) shouldDeleteStoreOnModelMismatch;

/**
 Setting this to true will make MagicalRecord delete any stores that it encounters which do not match the version of their model.
 This is extremely useful during development where frequent model changes can potentially require a delete and reinstall of the app.

 @param shouldDelete BOOL value that flags whether mismatched stores should be deleted
 
 @since Available in v2.0.4 and later.
 */
+ (void) setShouldDeleteStoreOnModelMismatch:(BOOL)shouldDelete;

/**
 @name Logging Levels
 */

/**
 Returns the logging mask set for MagicalRecord in the current application.

 @return Current MagicalRecordLoggingLevel
 
 @since Available in v2.3 and later.
 */
+ (MagicalRecordLoggingLevel) loggingLevel;

/**
 Sets the logging mask set for MagicalRecord in the current application.

 @param level Any value from MagicalRecordLogLevel

 @since Available in v2.3 and later.
 */
+ (void) setLoggingLevel:(MagicalRecordLoggingLevel)level;

@end
