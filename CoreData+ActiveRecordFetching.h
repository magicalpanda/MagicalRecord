
// enable to use caches for the fetchedResultsControllers (iOS only)
// #define STORE_USE_CACHE

#define kCreateNewCoordinatorOnBackgroundOperations     0

#define ENABLE_ACTIVE_RECORD_LOGGING

#ifdef ENABLE_ACTIVE_RECORD_LOGGING
    #define ARLog(...) NSLog(@"%s(%p) %@", __PRETTY_FUNCTION__, self, [NSString stringWithFormat:__VA_ARGS__])
#else
    #define ARLog(...) ((void)0)
#endif

#import "ActiveRecordHelpers.h"
#import "ARCoreDataAction.h"
#import "NSManagedObject+ActiveRecord.h"
#import "NSManagedObjectContext+ActiveRecord.h"
#import "NSPersistentStoreCoordinator+ActiveRecord.h"
#import "NSManagedObjectModel+ActiveRecord.h"
#import "NSPersistentStore+ActiveRecord.h"