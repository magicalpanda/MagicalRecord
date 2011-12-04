
// enable to use caches for the fetchedResultsControllers (iOS only)
// #define STORE_USE_CACHE

#define kCreateNewCoordinatorOnBackgroundOperations     0

#define ENABLE_ACTIVE_RECORD_LOGGING

#ifdef ENABLE_ACTIVE_RECORD_LOGGING
#ifdef LOG_VERBOSE
    #define MRLog(...)  DDLogVerbose(__VA_ARGS__)
#else
    #define MRLog(...) NSLog(@"%s(%p) %@", __PRETTY_FUNCTION__, self, [NSString stringWithFormat:__VA_ARGS__])
#endif
#else
    #define MRLog(...) ((void)0)
#endif

#import <CoreData/CoreData.h>

#ifndef NS_AUTOMATED_REFCOUNT_UNAVAILABLE
#define MR_RETAIN(xx)           [xx retain];
#define MR_RELEASE(xx)          [xx release];
#define MR_AUTORELEASE(xx)      [xx autorelease];
#else
#define MR_RETAIN(xx)  ((void)0)
#define MR_RELEASE(xx)  ((void)0)
#define MR_AUTORELEASE(xx)  ((void)0)
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
#import "NSAttributeDescription+MagicalDataImport.h"
#import "NSRelationshipDescription+MagicalDataImport.h"
#import "NSEntityDescription+MagicalDataImport.h"
