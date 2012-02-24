
// enable to use caches for the fetchedResultsControllers (iOS only)
// #define STORE_USE_CACHE

#define kCreateNewCoordinatorOnBackgroundOperations     0

#ifndef MR_ENABLE_ACTIVE_RECORD_LOGGING
  #ifdef DEBUG
    #define MR_ENABLE_ACTIVE_RECORD_LOGGING 1
  #else
    #define MR_ENABLE_ACTIVE_RECORD_LOGGING 0
  #endif
#endif

#if MR_ENABLE_ACTIVE_RECORD_LOGGING
#ifdef LOG_VERBOSE
    #define MRLog(...)  DDLogVerbose(__VA_ARGS__)
#else
    #define MRLog(...) NSLog(@"%s(%p) %@", __PRETTY_FUNCTION__, self, [NSString stringWithFormat:__VA_ARGS__])
#endif
#else
    #define MRLog(...) ((void)0)
#endif

#import <CoreData/CoreData.h>

#ifndef MR_USE_ARC
#define MR_USE_ARC __has_feature(objc_arc)
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_5_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_5_0 674.0
#endif

#ifndef kCFCoreFoundationVersionNumber_10_7
#define kCFCoreFoundationVersionNumber_10_7 635.0
#endif

#if TARGET_OS_IPHONE == 0
#define MR_MINIMUM_PRIVATE_QUEUE_CF_VERSION kCFCoreFoundationVersionNumber_10_7
#else
#define MR_MINIMUM_PRIVATE_QUEUE_CF_VERSION kCFCoreFoundationVersionNumber_iPhoneOS_5_0
#endif

#define PRIVATE_QUEUES_ENABLED(...) \
    if (kCFCoreFoundationVersionNumber >= MR_MINIMUM_PRIVATE_QUEUE_CF_VERSION) \
    { \
        __VA_ARGS__ \
    }

#define THREAD_ISOLATION_ENABLED(...) \
    if (kCFCoreFoundationVersionNumber < MR_MINIMUM_PRIVATE_QUEUE_CF_VERSION) \
    { \
        __VA_ARGS__ \
    }


#if MR_USE_ARC
#define MR_RETAIN(xx)
#define MR_RELEASE(xx)
#define MR_AUTORELEASE(xx)
#else
#define MR_RETAIN(xx)           [xx retain];
#define MR_RELEASE(xx)          [xx release];
#define MR_AUTORELEASE(xx)      [xx autorelease];
#endif

#ifdef MR_SHORTHAND
#import "MagicalRecordShorthand.h"
#endif

#import "MagicalRecordHelpers.h"
#import "MRCoreDataAction.h"

#import "NSManagedObject+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSPersistentStoreCoordinator+MagicalRecord.h"
#import "NSManagedObjectModel+MagicalRecord.h"
#import "NSPersistentStore+MagicalRecord.h"

#import "NSManagedObject+MagicalDataImport.h"
#import "NSNumber+MagicalDataImport.h"
#import "NSObject+MagicalDataImport.h"
#import "NSString+MagicalDataImport.h"
#import "NSAttributeDescription+MagicalDataImport.h"
#import "NSRelationshipDescription+MagicalDataImport.h"
#import "NSEntityDescription+MagicalDataImport.h"
