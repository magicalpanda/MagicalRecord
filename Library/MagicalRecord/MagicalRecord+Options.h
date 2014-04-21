//
//  MagicalRecord+Options.h
//  Magical Record
//
//  Created by Saul Mora on 3/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"


/**
 Defines "levels" of logging that will be used by MagicalRecord while running.

 @since Available in v2.3 and later.
 */
typedef NS_ENUM(NSInteger, MagicalRecordLogLevel)
{
    /** Disable all logging */
    MagicalRecordLogLevelOff = 0,

    /** Log fatal errors */
    MagicalRecordLogLevelFatal = 1 << 0,

    /** Log all errors */
    MagicalRecordLogLevelError = 1 << 1,

    /** Log warnings, and all errors */
    MagicalRecordLogLevelWarn = 1 << 2,

    /** Log informative messages, warnings and all errors */
    MagicalRecordLogLevelInfo = 1 << 3,

    /** Log verbose diagnostic information, messages, warnings and all errors */
    MagicalRecordLogLevelVerbose = 1 << 4,
};

/**
 Provides options for configuring MagicalRecord.
 */
@interface MagicalRecord (Options)

/**
 @name Log Levels
 */

/**
 Returns the logging level for MagicalRecord in the current application.

 @return Current MagicalRecordLogLevel
 
 @since Available in v2.3 and later.
 */
+ (MagicalRecordLogLevel) logLevel;

/**
 Sets the logging level for MagicalRecord in the current application.

 @param level Any value from MagicalRecordLogLevel

 @since Available in v2.3 and later.
 */
+ (void) setLogLevel:(MagicalRecordLogLevel)level;

@end
