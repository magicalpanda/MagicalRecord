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
typedef NS_ENUM (NSInteger, MagicalRecordLoggingMask)
{
    /** Disable all logging */
    MagicalRecordLoggingMaskOff = 0,

    /** Log fatal errors */
    MagicalRecordLoggingMaskFatal = 1 << 0,

    /** Log all errors */
    MagicalRecordLoggingMaskError = 1 << 1,

    /** Log warnings, and all errors */
    MagicalRecordLoggingMaskWarn = 1 << 2,

    /** Log informative messagess, warnings and all errors */
    MagicalRecordLoggingMaskInfo = 1 << 3,

    /** Log verbose diagnostic information, messages, warnings and all errors */
    MagicalRecordLoggingMaskVerbose = 1 << 4,
};

/**
 Defines a mask for logging that will be used by to filter log messages.

 @since Available in v2.3 and later.
 */
typedef NS_ENUM (NSInteger, MagicalRecordLoggingLevel)
{
    /** Don't log anything */
    MagicalRecordLoggingLevelOff = 0,

    /** Log all fatal messages */
    MagicalRecordLoggingLevelFatal = (MagicalRecordLoggingMaskFatal),

    /** Log all errors and fatal messages */
    MagicalRecordLoggingLevelError = (MagicalRecordLoggingMaskFatal | MagicalRecordLoggingMaskError),

    /** Log warnings, errors and fatal messages */
    MagicalRecordLoggingLevelWarn = (MagicalRecordLoggingMaskFatal | MagicalRecordLoggingMaskError | MagicalRecordLoggingMaskWarn),

    /** Log informative, warning and error messages */
    MagicalRecordLoggingLevelInfo = (MagicalRecordLoggingMaskFatal | MagicalRecordLoggingMaskError | MagicalRecordLoggingMaskWarn | MagicalRecordLoggingMaskInfo),

    /** Log verbose diagnostic, informative, warning and error messages */
    MagicalRecordLoggingLevelVerbose = (MagicalRecordLoggingMaskFatal | MagicalRecordLoggingMaskError | MagicalRecordLoggingMaskWarn | MagicalRecordLoggingMaskInfo | MagicalRecordLoggingMaskVerbose),
};

/**
 Provides options for configuring MagicalRecord.
 */
@interface MagicalRecord (Options)

/**
 @name Logging Level
 */

/**
 Returns the current logging level for MagicalRecord in the current application.

 @return Current MagicalRecordLoggingLevel
 
 @since Available in v2.3 and later.
 */
+ (MagicalRecordLoggingLevel) loggingLevel;

/**
 Sets the logging level for MagicalRecord in the current application.

 @param level Any value from MagicalRecordLoggingLevel

 @since Available in v2.3 and later.
 */
+ (void) setLoggingLevel:(MagicalRecordLoggingLevel)level;

@end
