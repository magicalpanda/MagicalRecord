//
//  MagicalRecordLogging.h
//  MagicalRecord
//
//  Created by Saul Mora on 10/4/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#ifndef MagicalRecord_MagicalRecordLogging_h
#define MagicalRecord_MagicalRecordLogging_h

#import "MagicalRecord+Options.h"

#define MR_LOG_LEVEL_OFF     (MagicalRecordLogLevelOff)
#define MR_LOG_LEVEL_FATAL   (MagicalRecordLogLevelFatal)
#define MR_LOG_LEVEL_ERROR   (MagicalRecordLogLevelFatal | MagicalRecordLogLevelError )
#define MR_LOG_LEVEL_WARN    (MagicalRecordLogLevelFatal | MagicalRecordLogLevelError | MagicalRecordLogLevelWarn)
#define MR_LOG_LEVEL_INFO    (MagicalRecordLogLevelFatal | MagicalRecordLogLevelError | MagicalRecordLogLevelWarn | MagicalRecordLogLevelInfo)
#define MR_LOG_LEVEL_VERBOSE (MagicalRecordLogLevelFatal | MagicalRecordLogLevelError | MagicalRecordLogLevelWarn | MagicalRecordLogLevelInfo | MagicalRecordLogLevelVerbose)

#define LOG_ASYNC_ENABLED YES

#define LOG_ASYNC_ERROR   ( NO && LOG_ASYNC_ENABLED)
#define LOG_ASYNC_WARN    (YES && LOG_ASYNC_ENABLED)
#define LOG_ASYNC_INFO    (YES && LOG_ASYNC_ENABLED)
#define LOG_ASYNC_VERBOSE (YES && LOG_ASYNC_ENABLED)

#ifndef LOG_MACRO

    #define LOG_MACRO(isAsynchronous, lvl, flg, ctx, atag, fnct, frmt, ...) \
    NSLog (frmt, ##__VA_ARGS__)

    #define LOG_MAYBE(async, lvl, flg, ctx, fnct, frmt, ...) \
    do { if(lvl & flg) LOG_MACRO(async, lvl, flg, ctx, nil, fnct, frmt, ##__VA_ARGS__); } while(0)

    #define LOG_OBJC_MAYBE(async, lvl, flg, ctx, frmt, ...) \
    LOG_MAYBE(async, lvl, flg, ctx, sel_getName(_cmd), frmt, ##__VA_ARGS__)

    #define LOG_C_MAYBE(async, lvl, flg, ctx, frmt, ...) \
    LOG_MAYBE(async, lvl, flg, ctx, __FUNCTION__, frmt, ##__VA_ARGS__)

#endif

#define MRLogFatal(frmt, ...)   LOG_OBJC_MAYBE(LOG_ASYNC_ERROR,   [MagicalRecord logLevel], MR_LOG_LEVEL_FATAL,   0, frmt, ##__VA_ARGS__)
#define MRLogError(frmt, ...)   LOG_OBJC_MAYBE(LOG_ASYNC_ERROR,   [MagicalRecord logLevel], MR_LOG_LEVEL_ERROR,   0, frmt, ##__VA_ARGS__)
#define MRLogWarn(frmt, ...)    LOG_OBJC_MAYBE(LOG_ASYNC_WARN,    [MagicalRecord logLevel], MR_LOG_LEVEL_WARN,    0, frmt, ##__VA_ARGS__)
#define MRLogInfo(frmt, ...)    LOG_OBJC_MAYBE(LOG_ASYNC_INFO,    [MagicalRecord logLevel], MR_LOG_LEVEL_INFO,    0, frmt, ##__VA_ARGS__)
#define MRLogVerbose(frmt, ...) LOG_OBJC_MAYBE(LOG_ASYNC_VERBOSE, [MagicalRecord logLevel], MR_LOG_LEVEL_VERBOSE, 0, frmt, ##__VA_ARGS__)

#define MRLogCFatal(frmt, ...)   LOG_C_MAYBE(LOG_ASYNC_ERROR,   [MagicalRecord logLevel], MR_LOG_LEVEL_FATAL,   0, frmt, ##__VA_ARGS__)
#define MRLogCError(frmt, ...)   LOG_C_MAYBE(LOG_ASYNC_ERROR,   [MagicalRecord logLevel], MR_LOG_LEVEL_ERROR,   0, frmt, ##__VA_ARGS__)
#define MRLogCWarn(frmt, ...)    LOG_C_MAYBE(LOG_ASYNC_WARN,    [MagicalRecord logLevel], MR_LOG_LEVEL_WARN,    0, frmt, ##__VA_ARGS__)
#define MRLogCInfo(frmt, ...)    LOG_C_MAYBE(LOG_ASYNC_INFO,    [MagicalRecord logLevel], MR_LOG_LEVEL_INFO,    0, frmt, ##__VA_ARGS__)
#define MRLogCVerbose(frmt, ...) LOG_C_MAYBE(LOG_ASYNC_VERBOSE, [MagicalRecord logLevel], MR_LOG_LEVEL_VERBOSE, 0, frmt, ##__VA_ARGS__)

#endif

