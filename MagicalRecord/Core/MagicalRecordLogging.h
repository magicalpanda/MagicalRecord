//
//  MagicalRecordLogging.h
//  MagicalRecord
//
//  Created by Saul Mora on 10/4/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"
#import "MagicalRecord+Options.h"

#if !defined(MR_LOGGING_ENABLED) && __has_include("CocoaLumberjack.h")
    #define MR_LOGGING_ENABLED 1
#endif

#if MR_LOGGING_ENABLED

#ifndef MR_LOGGING_CONTEXT
    #define MR_LOGGING_CONTEXT 0
#endif

#if __has_include("CocoaLumberjack.h")
    #define LOG_LEVEL_DEF (DDLogLevel)[MagicalRecord loggingLevel]
    #define CAST (DDLogFlag)
    #import "CocoaLumberjack.h"
#else
    #define LOG_LEVEL_DEF [MagicalRecord loggingLevel]
    #define LOG_ASYNC_ENABLED YES
    #define CAST
    #define LOG_MAYBE(async, lvl, flg, ctx, tag, fnct, frmt, ...) do { if ((lvl & flg) == flg) { NSLog (frmt, ##__VA_ARGS__); } } while(0)
#endif

#define MRLogFatal(frmt, ...)   LOG_MAYBE(NO,                LOG_LEVEL_DEF, CAST MagicalRecordLoggingMaskFatal,   MR_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define MRLogError(frmt, ...)   LOG_MAYBE(NO,                LOG_LEVEL_DEF, CAST MagicalRecordLoggingMaskError,   MR_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define MRLogWarn(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, CAST MagicalRecordLoggingMaskWarn,    MR_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define MRLogInfo(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, CAST MagicalRecordLoggingMaskInfo,    MR_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define MRLogVerbose(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, CAST MagicalRecordLoggingMaskVerbose, MR_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#else

#define MRLogFatal(frmt, ...)   ((void)0)
#define MRLogError(frmt, ...)   ((void)0)
#define MRLogWarn(frmt, ...)    ((void)0)
#define MRLogInfo(frmt, ...)    ((void)0)
#define MRLogVerbose(frmt, ...) ((void)0)

#endif

