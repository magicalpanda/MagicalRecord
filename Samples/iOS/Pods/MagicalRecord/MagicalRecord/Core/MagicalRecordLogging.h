//
//  MagicalRecordLogging.h
//  MagicalRecord
//
//  Created by Saul Mora on 10/4/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import <MagicalRecord/MagicalRecord+Options.h>

#if MR_LOGGING_DISABLED

#define MRLogError(frmt, ...) ((void)0)
#define MRLogWarn(frmt, ...) ((void)0)
#define MRLogInfo(frmt, ...) ((void)0)
#define MRLogDebug(frmt, ...) ((void)0)
#define MRLogVerbose(frmt, ...) ((void)0)

#else

#ifndef MR_LOGGING_CONTEXT
#define MR_LOGGING_CONTEXT 0
#endif

#if __has_include("CocoaLumberjack.h")
    #define MR_LOG_LEVEL_DEF (DDLogLevel)[MagicalRecord loggingLevel]
    #define CAST (DDLogFlag)
    #import <CocoaLumberjack/CocoaLumberjack.h>
#else
    #define MR_LOG_LEVEL_DEF [MagicalRecord loggingLevel]
    #define LOG_ASYNC_ENABLED YES
    #define CAST
    #define LOG_MAYBE(async, lvl, flg, ctx, tag, fnct, frmt, ...) \
        do                                                        \
        {                                                         \
            if ((lvl & flg) == flg)                               \
            {                                                     \
                NSLog(frmt, ##__VA_ARGS__);                       \
            }                                                     \
        } while (0)
#endif

#define MRLogError(frmt, ...) LOG_MAYBE(NO, MR_LOG_LEVEL_DEF, CAST MagicalRecordLoggingMaskError, MR_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define MRLogWarn(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, MR_LOG_LEVEL_DEF, CAST MagicalRecordLoggingMaskWarn, MR_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define MRLogInfo(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, MR_LOG_LEVEL_DEF, CAST MagicalRecordLoggingMaskInfo, MR_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define MRLogDebug(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, MR_LOG_LEVEL_DEF, CAST MagicalRecordLoggingMaskDebug, MR_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define MRLogVerbose(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, MR_LOG_LEVEL_DEF, CAST MagicalRecordLoggingMaskVerbose, MR_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#endif
