//
//  MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#if TARGET_OS_IPHONE == 0
#define MAC_PLATFORM_ONLY YES
#endif

// enable to use caches for the fetchedResultsControllers (iOS only)
// #define STORE_USE_CACHE

#ifndef MR_ENABLE_LOGGING
    #ifdef DEBUG
        #define MR_ENABLE_LOGGING 1
    #else
        #define MR_ENABLE_LOGGING 0
    #endif
#endif

#if MR_ENABLE_LOGGING != 0
      // First, check if we can use Cocoalumberjack for logging
    #ifdef LOG_VERBOSE
        #define MR_LOG_LEVEL LOG_LEVEL_VERBOSE
        #define MRLog(...)  DDLogVerbose(__VA_ARGS__)
        #define MRCLog(...) DDLogCVerbose(__VA_ARGS__)
    #else
        #define MR_LOG_LEVEL -1
        #define MRLog(...) NSLog(@"%s(%p) %@", __PRETTY_FUNCTION__, self, [NSString stringWithFormat:__VA_ARGS__])
        #define MRCLog(...)
    #endif
#else
    #define MR_LOG_LEVEL -1
    #define MRLog(...) ((void)0)
    #define MRCLog(...) ((void)0)
#endif

#ifdef NS_BLOCKS_AVAILABLE

@class NSManagedObjectContext;
typedef void (^CoreDataBlock)(NSManagedObjectContext *context);

#endif

@interface MagicalRecord : NSObject

+ (void) cleanUp;

+ (NSString *) defaultStoreName;

@end
