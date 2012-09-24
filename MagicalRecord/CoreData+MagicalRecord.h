
#ifndef NS_BLOCKS_AVAILABLE
    #warning MagicalRecord requires blocks
#endif

#ifdef __OBJC__
//    #if !( __has_feature(objc_arc) && __has_feature(objc_arc_weak) )
//        #error MagicalRecord now requires ARC to be enabled
//    #endif

    #import <CoreFoundation/CoreFoundation.h>
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

// @see https://github.com/ccgus/fmdb/commit/aef763eeb64e6fa654e7d121f1df4c16a98d9f4f
#define MRDispatchQueueRelease(q) (dispatch_release(q))

#if TARGET_OS_IPHONE
    #if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
        #define MRDispatchQueueRelease(q)
    #endif
#else
    #if MAC_OS_X_VERSION_MIN_REQUIRED >= 1080
        #define MRDispatchQueueRelease(q)
    #endif
#endif
