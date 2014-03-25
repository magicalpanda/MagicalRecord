
#ifndef NS_BLOCKS_AVAILABLE
    #warning MagicalRecord requires blocks
#endif

#ifdef __OBJC__
    #import <CoreFoundation/CoreFoundation.h>
    #import <CoreData/CoreData.h>
    #import "MagicalRecord.h"
    #import "MagicalRecord+Options.h"
    #import "MagicalRecord+Setup.h"

    #import "MagicalRecordStack.h"
    #import "MagicalRecordStack+Actions.h"
    #import "SQLiteMagicalRecordStack.h"
    #import "SQLiteWithSavingContextMagicalRecordStack.h"
    #import "ClassicSQLiteMagicalRecordStack.h"
    #import "ClassicWithBackgroundCoordinatorSQLiteMagicalRecordStack.h"

    #import "InMemoryMagicalRecordStack.h"
    #import "iCloudMagicalRecordStack.h"

    #import "AutoMigratingMagicalRecordStack.h"
    #import "AutoMigratingWithSourceAndTargetModelMagicalRecordStack.h"
    #import "ManuallyMigratingMagicalRecordStack.h"

    #import "NSManagedObject+MagicalRecord.h"
    #import "NSManagedObject+MagicalRequests.h"
    #import "NSManagedObject+MagicalFinders.h"
    #import "NSManagedObject+MagicalAggregation.h"
    #import "NSManagedObjectContext+MagicalRecord.h"
    #import "NSManagedObjectContext+MagicalObserving.h"
    #import "NSManagedObjectContext+MagicalSaves.h"

    #import "NSPersistentStoreCoordinator+MagicalRecord.h"
    #import "NSPersistentStoreCoordinator+MagicalAutoMigrations.h"
    #import "NSPersistentStoreCoordinator+MagicalManualMigrations.h"
    #import "NSPersistentStoreCoordinator+MagicalInMemoryStoreAdditions.h"
    #import "NSPersistentStoreCoordinator+MagicaliCloudAdditions.h"

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
    #import "NSError+MagicalRecordErrorHandling.h"

    #if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
        #import "NSManagedObject+MagicalFetching.h"
        #import "NSFetchedResultsController+MagicalFetching.h"
    #endif

    #define MR_SHORTHAND 1
    #import "MagicalRecordShorthand.h"

#endif

// @see https://github.com/ccgus/fmdb/commit/aef763eeb64e6fa654e7d121f1df4c16a98d9f4f
#define MRDispatchQueueRelease(q) (dispatch_release(q))

#if TARGET_OS_IPHONE
    #if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
        #undef MRDispatchQueueRelease
        #define MRDispatchQueueRelease(q)
    #endif
#else
    #if MAC_OS_X_VERSION_MIN_REQUIRED >= 1080
        #undef MRDispatchQueueRelease
        #define MRDispatchQueueRelease(q)
    #endif
#endif
