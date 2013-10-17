//
//  MagicalRecordLogging.h
//  MagicalRecord
//
//  Created by Saul Mora on 10/4/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#ifndef MagicalRecord_MagicalRecordLogging_h
#define MagicalRecord_MagicalRecordLogging_h

#define MR_LOG_FLAG_FATAL   (1 << 0)  // 0...0001
#define MR_LOG_FLAG_ERROR   (1 << 1)  // 0...0010
#define MR_LOG_FLAG_WARN    (1 << 2)  // 0...0100
#define MR_LOG_FLAG_INFO    (1 << 3)  // 0...1000
#define MR_LOG_FLAG_VERBOSE (1 << 4)  // 0...1000

#define MR_LOG_LEVEL_OFF     0
#define MR_LOG_LEVEL_FATAL   (MR_LOG_FLAG_FATAL)
#define MR_LOG_LEVEL_ERROR   (MR_LOG_FLAG_FATAL | MR_LOG_FLAG_ERROR )                                                    // 0...0001
#define MR_LOG_LEVEL_WARN    (MR_LOG_FLAG_FATAL | MR_LOG_FLAG_ERROR | MR_LOG_FLAG_WARN)                                    // 0...0011
#define MR_LOG_LEVEL_INFO    (MR_LOG_FLAG_FATAL | MR_LOG_FLAG_ERROR | MR_LOG_FLAG_WARN | MR_LOG_FLAG_INFO)                    // 0...0111
#define MR_LOG_LEVEL_VERBOSE (MR_LOG_FLAG_FATAL | MR_LOG_FLAG_ERROR | MR_LOG_FLAG_WARN | MR_LOG_FLAG_INFO | MR_LOG_FLAG_VERBOSE) // 0...1111

#if MR_LOGGING_ENABLED > 0
    // First, check if we can use Cocoalumberjack for logging
    #ifdef LOG_LEVEL_VERBOSE
//        #import "DDLog.h"
        #define MRLogFatal(frmt, ...)   LOG_OBJC_MAYBE(LOG_ASYNC_ERROR,   [MagicalRecord logLevel], MR_LOG_FLAG_FATAL,   0, frmt, ##__VA_ARGS__)
        #define MRLogError(frmt, ...)   LOG_OBJC_MAYBE(LOG_ASYNC_ERROR,   [MagicalRecord logLevel], MR_LOG_FLAG_ERROR,   0, frmt, ##__VA_ARGS__)
        #define MRLogWarn(frmt, ...)    LOG_OBJC_MAYBE(LOG_ASYNC_WARN,    [MagicalRecord logLevel], MR_LOG_FLAG_WARN,    0, frmt, ##__VA_ARGS__)
        #define MRLogInfo(frmt, ...)    LOG_OBJC_MAYBE(LOG_ASYNC_INFO,    [MagicalRecord logLevel], MR_LOG_FLAG_INFO,    0, frmt, ##__VA_ARGS__)
        #define MRLogVerbose(frmt, ...) LOG_OBJC_MAYBE(LOG_ASYNC_VERBOSE, [MagicalRecord logLevel], MR_LOG_FLAG_VERBOSE, 0, frmt, ##__VA_ARGS__)

        #define MRLogCFatal(frmt, ...)   LOG_C_MAYBE(LOG_ASYNC_ERROR,   [MagicalRecord logLevel], MR_LOG_FLAG_FATAL,   0, frmt, ##__VA_ARGS__)
        #define MRLogCError(frmt, ...)   LOG_C_MAYBE(LOG_ASYNC_ERROR,   [MagicalRecord logLevel], MR_LOG_FLAG_ERROR,   0, frmt, ##__VA_ARGS__)
        #define MRLogCWarn(frmt, ...)    LOG_C_MAYBE(LOG_ASYNC_WARN,    [MagicalRecord logLevel], MR_LOG_FLAG_WARN,    0, frmt, ##__VA_ARGS__)
        #define MRLogCInfo(frmt, ...)    LOG_C_MAYBE(LOG_ASYNC_INFO,    [MagicalRecord logLevel], MR_LOG_FLAG_INFO,    0, frmt, ##__VA_ARGS__)
        #define MRLogCVerbose(frmt, ...) LOG_C_MAYBE(LOG_ASYNC_VERBOSE, [MagicalRecord logLevel], MR_LOG_FLAG_VERBOSE, 0, frmt, ##__VA_ARGS__)

    #else
        #define MRLogVerbose(...) NSLog(@"%s(%p) %@", __PRETTY_FUNCTION__, self, [NSString stringWithFormat:__VA_ARGS__])
        #define MRLogInfo(...) NSLog(@"%s(%p) %@", __PRETTY_FUNCTION__, self, [NSString stringWithFormat:__VA_ARGS__])
        #define MRLogWarn(...) NSLog(@"%s(%p) %@", __PRETTY_FUNCTION__, self, [NSString stringWithFormat:__VA_ARGS__])
        #define MRLogError(...) NSLog(@"%s(%p) %@", __PRETTY_FUNCTION__, self, [NSString stringWithFormat:__VA_ARGS__])
        #define MRLogFatal(...) NSLog(@"%s(%p) %@", __PRETTY_FUNCTION__, self, [NSString stringWithFormat:__VA_ARGS__])

        #define MRCLogVerbose(...) NSLog(__VA_ARGS__)
        #define MRCLogInfo(...) NSLog(__VA_ARGS__)
        #define MRCLogWarn(...) NSLog(__VA_ARGS__)
        #define MRCLogError(...) NSLog(__VA_ARGS__)
        #define MRCLogFatal(...) NSLog(__VA_ARGS__)
    #endif
#else

    #define MRLogVerbose(...) ((void)0)
    #define MRLogInfo(...) ((void)0)
    #define MRLogWarn(...) ((void)0)
    #define MRLogError(...) ((void)0)
    #define MRLogFatal(...) ((void)0)

    #define MRCLogVerbose(...) ((void)0)
    #define MRCLogInfo(...) ((void)0)
    #define MRCLogWarn(...) ((void)0)
    #define MRCLogError(...) ((void)0)
    #define MRCLogFatal(...) ((void)0)

#endif

#endif

