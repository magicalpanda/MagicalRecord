
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

#ifdef __OBJC__

#if MR_ENABLE_ACTIVE_RECORD_LOGGING != 0
#ifdef LOG_VERBOSE
    #define MRLog(...)  DDLogVerbose(__VA_ARGS__)
#else
    #define MRLog(...) NSLog(@"%s(%p) %@", __PRETTY_FUNCTION__, self, [NSString stringWithFormat:__VA_ARGS__])
#endif
#else
    #define MRLog(...) ((void)0)
#endif

//    #if !( __has_feature(objc_arc) && __has_feature(objc_arc_weak) )
//        #error MagicalRecord now requires ARC to be enabled
//    #endif

    #import <CoreData/CoreData.h>

    #ifdef MR_SHORTHAND
    #import "MagicalRecordShorthand.h"
    #endif

    #import "MagicalRecord.h"
    #import "MagicalRecord+Actions.h"
    #import "MagicalRecord+ErrorHandling.h"
    #import "MagicalRecord+Options.h"
    #import "MagicalRecord+ShorthandSupport.h"
    #import "MagicalRecord+Setup.h"
    #import "MagicalRecord+iCloud.h"

    #import "NSManagedObject+MagicalRecord.h"
    #import "NSManagedObject+MagicalRequests.h"
    #import "NSManagedObject+MagicalFinders.h"
    #import "NSManagedObject+MagicalAggregation.h"
    #import "NSManagedObjectContext+MagicalRecord.h"
    #import "NSManagedObjectContext+MagicalObserving.h"
    #import "NSManagedObjectContext+MagicalSaves.h"
    #import "NSManagedObjectContext+MagicalThreading.h"
    #import "NSPersistentStoreCoordinator+MagicalRecord.h"
    #import "NSManagedObjectModel+MagicalRecord.h"
    #import "NSPersistentStore+MagicalRecord.h"

    #import "MagicalImportFunctions.h"
    #import "NSManagedObject+MagicalDataImport.h"
    #import "NSNumber+MagicalDataImport.h"
    #import "NSObject+MagicalDataImport.h"
    #import "NSString+MagicalDataImport.h"
    #import "NSAttributeDescription+MagicalDataImport.h"
    #import "NSRelationshipDescription+MagicalDataImport.h"
    #import "NSEntityDescription+MagicalDataImport.h"

#endif
