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

// First, check if we can use Cocoalumberjack for logging
#if defined(COCOAPODS_POD_AVAILABLE_CocoaLumberjack)
    #import <CocoaLumberjack/DDLog.h>
    extern int ddLogLevel;
    #define MRLogError(...)   DDLogError(__VA_ARGS__)
    #define MRLogWarn(...)    DDLogWarn(__VA_ARGS__)
    #define MRLogInfo(...)    DDLogInfo(__VA_ARGS__)
    #define MRLogVerbose(...) DDLogVerbose(__VA_ARGS__)
#else
    // if not, only log in DEBUG
    #if defined(DEBUG)
        #define MRLog(...) NSLog(@"%s(%p) %@", __PRETTY_FUNCTION__, self, [NSString stringWithFormat:__VA_ARGS__])
    #else
        #define MRLog(...) ((void)0)
    #endif

    #define MRLogError(...)   MRLog(__VA_ARGS__)
    #define MRLogWarn(...)    MRLog(__VA_ARGS__)
    #define MRLogInfo(...)    MRLog(__VA_ARGS__)
    #define MRLogVerbose(...) MRLog(__VA_ARGS__)
#endif

#ifdef NS_BLOCKS_AVAILABLE

extern NSString * const kMagicalRecordCleanedUpNotification;

@class NSManagedObjectContext;
typedef void (^CoreDataBlock)(NSManagedObjectContext *context);

#endif

@interface MagicalRecord : NSObject

+ (NSString *) currentStack;

+ (void) cleanUp;

+ (void) setDefaultModelFromClass:(Class)klass;
+ (void) setDefaultModelNamed:(NSString *)modelName;
+ (NSString *) defaultStoreName;

@end
