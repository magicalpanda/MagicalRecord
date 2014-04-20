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

 @constant MagicalRecordLogLevelOff Disable all logging
 @constant MagicalRecordLogLevelFatal Log fatal errors
 @constant MagicalRecordLogLevelError Log all errors
 @constant MagicalRecordLogLevelWarn Log warnings, and all errors
 @constant MagicalRecordLogLevelInfo Log informative messages, warnings and all errors
 @constant MagicalRecordLogLevelVerbose Log verbose diagnostic information, messages, warnings and all errors

 @since 2.3.0
 */
typedef NS_ENUM(NSInteger, MagicalRecordLogLevel)
{
    MagicalRecordLogLevelOff = 0,
    MagicalRecordLogLevelFatal = 1 << 0,
    MagicalRecordLogLevelError = 1 << 1,
    MagicalRecordLogLevelWarn = 1 << 2,
    MagicalRecordLogLevelInfo = 1 << 3,
    MagicalRecordLogLevelVerbose = 1 << 4,
};

/**
 Provides options for configuring MagicalRecord.
 */
@interface MagicalRecord (Options)

///------------------
/// @name Log Levels
///------------------

/**
 Returns the logging level for MagicalRecord in the current application.

 @return Current MagicalRecordLogLevel
 
 @since 2.3.0
 */
+ (MagicalRecordLogLevel) logLevel;

/**
 Sets the logging level for MagicalRecord in the current application.

 @param level Any value from MagicalRecordLogLevel

 @since 2.3.0
 */
+ (void) setLogLevel:(MagicalRecordLogLevel)level;

@end
