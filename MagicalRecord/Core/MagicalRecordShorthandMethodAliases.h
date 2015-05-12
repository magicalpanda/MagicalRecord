#import <MagicalRecord/MagicalRecordDeprecationMacros.h>
#import <MagicalRecord/NSManagedObjectContext+MagicalSaves.h>


@interface NSManagedObject (MagicalAggregationShortHand)

+ (NSNumber *) numberOfEntities;
+ (NSNumber *) numberOfEntitiesWithContext:(NSManagedObjectContext *)context;
+ (NSNumber *) numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm;
+ (NSNumber *) numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (NSUInteger) countOfEntities;
+ (NSUInteger) countOfEntitiesWithContext:(NSManagedObjectContext *)context;
+ (NSUInteger) countOfEntitiesWithPredicate:(NSPredicate *)searchFilter;
+ (NSUInteger) countOfEntitiesWithPredicate:(NSPredicate *)searchFilter inContext:(NSManagedObjectContext *)context;
+ (BOOL) hasAtLeastOneEntity;
+ (BOOL) hasAtLeastOneEntityInContext:(NSManagedObjectContext *)context;
- (id) minValueFor:(NSString *)property;
- (id) maxValueFor:(NSString *)property;
+ (id) aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (id) aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate;
+ (NSArray *) aggregateOperation:(NSString *)collectionOperator onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate groupBy:(NSString*)groupingKeyPath inContext:(NSManagedObjectContext *)context;
+ (NSArray *) aggregateOperation:(NSString *)collectionOperator onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate groupBy:(NSString*)groupingKeyPath;
- (instancetype) objectWithMinValueFor:(NSString *)property;
- (instancetype) objectWithMinValueFor:(NSString *)property inContext:(NSManagedObjectContext *)context;

@end


@interface NSManagedObject (MagicalFindersShortHand)

+ (NSArray *) findAll;
+ (NSArray *) findAllInContext:(NSManagedObjectContext *)context;
+ (NSArray *) findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSArray *) findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSArray *) findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
+ (NSArray *) findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (NSArray *) findAllWithPredicate:(NSPredicate *)searchTerm;
+ (NSArray *) findAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (instancetype) findFirst;
+ (instancetype) findFirstInContext:(NSManagedObjectContext *)context;
+ (instancetype) findFirstWithPredicate:(NSPredicate *)searchTerm;
+ (instancetype) findFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (instancetype) findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending;
+ (instancetype) findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (instancetype) findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes;
+ (instancetype) findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes inContext:(NSManagedObjectContext *)context;
+ (instancetype) findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending andRetrieveAttributes:(id)attributes, ...;
+ (instancetype) findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context andRetrieveAttributes:(id)attributes, ...;
+ (instancetype) findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (instancetype) findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
+ (instancetype) findFirstOrderedByAttribute:(NSString *)attribute ascending:(BOOL)ascending;
+ (instancetype) findFirstOrderedByAttribute:(NSString *)attribute ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (instancetype) findFirstOrCreateByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (instancetype) findFirstOrCreateByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
+ (NSArray *) findByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (NSArray *) findByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
+ (NSArray *) findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSArray *) findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchController:(NSFetchRequest *)request delegate:(id<NSFetchedResultsControllerDelegate>)delegate useFileCache:(BOOL)useFileCache groupedBy:(NSString *)groupKeyPath inContext:(NSManagedObjectContext *)context;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id<NSFetchedResultsControllerDelegate>)delegate;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

@end


@interface NSManagedObject (MagicalRequestsShortHand)

+ (NSFetchRequest *) createFetchRequest;
+ (NSFetchRequest *) createFetchRequestInContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) requestAll;
+ (NSFetchRequest *) requestAllInContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) requestAllWithPredicate:(NSPredicate *)searchTerm;
+ (NSFetchRequest *) requestAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) requestAllWhere:(NSString *)property isEqualTo:(id)value;
+ (NSFetchRequest *) requestAllWhere:(NSString *)property isEqualTo:(id)value inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) requestFirstWithPredicate:(NSPredicate *)searchTerm;
+ (NSFetchRequest *) requestFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (NSFetchRequest *) requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

@end


@interface NSManagedObjectContext (MagicalRecordChainSaveShortHand)

- (void)saveWithBlock:(void (^)(NSManagedObjectContext *localContext))block;
- (void)saveWithBlock:(void (^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;
- (void)saveWithBlockAndWait:(void (^)(NSManagedObjectContext *localContext))block;

@end


@interface NSManagedObjectContext (MagicalObservingShortHand)

- (void) observeContext:(NSManagedObjectContext *)otherContext;
- (void) stopObservingContext:(NSManagedObjectContext *)otherContext;
- (void) observeContextOnMainThread:(NSManagedObjectContext *)otherContext;
- (void) observeiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator;
- (void) stopObservingiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator;

@end


@interface NSManagedObjectContext (MagicalRecordShortHand)

+ (void) initializeDefaultContextWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;
+ (NSManagedObjectContext *) rootSavingContext;
+ (NSManagedObjectContext *) defaultContext;
+ (NSManagedObjectContext *) context;
+ (NSManagedObjectContext *) contextWithParent:(NSManagedObjectContext *)parentContext;
+ (NSManagedObjectContext *) contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;
+ (NSManagedObjectContext *) newMainQueueContext NS_RETURNS_RETAINED;
+ (NSManagedObjectContext *) newPrivateQueueContext NS_RETURNS_RETAINED;
- (void) setWorkingName:(NSString *)workingName;
- (NSString *) workingName;
- (NSString *) description;
- (NSString *) parentChain;
+ (void) resetDefaultContext;
- (void) deleteObjects:(id <NSFastEnumeration>)objects;

@end


@interface NSManagedObjectContext (MagicalRecordDeprecatedShortHand)

+ (NSManagedObjectContext *) contextWithoutParent MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_newPrivateQueueContext");
+ (NSManagedObjectContext *) newContext MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_context");
+ (NSManagedObjectContext *) newContextWithParent:(NSManagedObjectContext *)parentContext MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_contextWithParent:");
+ (NSManagedObjectContext *) newContextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_contextWithStoreCoordinator:");

@end


@interface NSManagedObjectContext (MagicalSavesShortHand)

- (void) saveOnlySelfWithCompletion:(MRSaveCompletionHandler)completion;
- (void) saveToPersistentStoreWithCompletion:(MRSaveCompletionHandler)completion;
- (void) saveOnlySelfAndWait;
- (void) saveToPersistentStoreAndWait;
- (void) saveWithOptions:(MRSaveOptions)saveOptions completion:(MRSaveCompletionHandler)completion;

@end


@interface NSManagedObjectContext (MagicalSavesDeprecatedShortHand)

- (void) save MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("3.0", "MR_saveToPersistentStoreAndWait");
- (void) saveWithErrorCallback:(void(^)(NSError *error))errorCallback MR_DEPRECATED_WILL_BE_REMOVED_IN("3.0");
- (void) saveInBackgroundCompletion:(void (^)(void))completion MR_DEPRECATED_WILL_BE_REMOVED_IN("3.0");
- (void) saveInBackgroundErrorHandler:(void (^)(NSError *error))errorCallback MR_DEPRECATED_WILL_BE_REMOVED_IN("3.0");
- (void) saveInBackgroundErrorHandler:(void (^)(NSError *error))errorCallback completion:(void (^)(void))completion MR_DEPRECATED_WILL_BE_REMOVED_IN("3.0");
- (void) saveNestedContexts MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("3.0", "MR_saveToPersistentStoreWithCompletion:");
- (void) saveNestedContextsErrorHandler:(void (^)(NSError *error))errorCallback MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("3.0", "MR_saveToPersistentStoreWithCompletion:");
- (void) saveNestedContextsErrorHandler:(void (^)(NSError *error))errorCallback completion:(void (^)(void))completion MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("3.0", "MR_saveToPersistentStoreWithCompletion:");

@end


@interface NSManagedObjectContext (MagicalThreadingShortHand)

+ (NSManagedObjectContext *) contextForCurrentThread __attribute((deprecated("This method will be removed in MagicalRecord 3.0")));
+ (void) clearNonMainThreadContextsCache __attribute((deprecated("This method will be removed in MagicalRecord 3.0")));
+ (void) resetContextForCurrentThread __attribute((deprecated("This method will be removed in MagicalRecord 3.0")));
+ (void) clearContextForCurrentThread __attribute((deprecated("This method will be removed in MagicalRecord 3.0")));

@end


@interface NSManagedObjectModel (MagicalRecordShortHand)

+ (NSManagedObjectModel *) defaultManagedObjectModel;
+ (void) setDefaultManagedObjectModel:(NSManagedObjectModel *)newDefaultModel;
+ (NSManagedObjectModel *) mergedObjectModelFromMainBundle;
+ (NSManagedObjectModel *) newManagedObjectModelNamed:(NSString *)modelFileName NS_RETURNS_RETAINED;
+ (NSManagedObjectModel *) managedObjectModelNamed:(NSString *)modelFileName;
+ (NSManagedObjectModel *) newModelNamed:(NSString *) modelName inBundleNamed:(NSString *) bundleName NS_RETURNS_RETAINED;
+ (NSManagedObjectModel *) newModelNamed:(NSString *) modelName inBundle:(NSBundle*) bundle NS_RETURNS_RETAINED;

@end


@interface NSPersistentStore (MagicalRecordShortHand)

+ (NSURL *) defaultLocalStoreUrl;
+ (NSPersistentStore *) defaultPersistentStore;
+ (void) setDefaultPersistentStore:(NSPersistentStore *) store;
+ (NSURL *) urlForStoreName:(NSString *)storeFileName;
+ (NSURL *) cloudURLForUbiqutiousContainer:(NSString *)bucketName;

@end


@interface NSPersistentStoreCoordinator (MagicalRecordShortHand)

+ (NSPersistentStoreCoordinator *) defaultStoreCoordinator;
+ (void) setDefaultStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;
+ (NSPersistentStoreCoordinator *) coordinatorWithInMemoryStore;
+ (NSPersistentStoreCoordinator *) newPersistentStoreCoordinator NS_RETURNS_RETAINED;
+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreNamed:(NSString *)storeFileName;
+ (NSPersistentStoreCoordinator *) coordinatorWithAutoMigratingSqliteStoreNamed:(NSString *)storeFileName;
+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreAtURL:(NSURL *)storeURL;
+ (NSPersistentStoreCoordinator *) coordinatorWithAutoMigratingSqliteStoreAtURL:(NSURL *)storeURL;
+ (NSPersistentStoreCoordinator *) coordinatorWithPersistentStore:(NSPersistentStore *)persistentStore;
+ (NSPersistentStoreCoordinator *) coordinatorWithiCloudContainerID:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)subPathComponent;
+ (NSPersistentStoreCoordinator *) coordinatorWithiCloudContainerID:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreAtURL:(NSURL *)storeURL cloudStorePathComponent:(NSString *)subPathComponent;
+ (NSPersistentStoreCoordinator *) coordinatorWithiCloudContainerID:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)subPathComponent completion:(void(^)(void))completionHandler;
+ (NSPersistentStoreCoordinator *) coordinatorWithiCloudContainerID:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreAtURL:(NSURL *)storeURL cloudStorePathComponent:(NSString *)subPathComponent completion:(void (^)(void))completionHandler;
- (NSPersistentStore *) addInMemoryStore;
- (NSPersistentStore *) addAutoMigratingSqliteStoreNamed:(NSString *) storeFileName;
- (NSPersistentStore *) addAutoMigratingSqliteStoreAtURL:(NSURL *)storeURL;
- (NSPersistentStore *) addSqliteStoreNamed:(id)storeFileName withOptions:(__autoreleasing NSDictionary *)options;
- (NSPersistentStore *) addSqliteStoreNamed:(id)storeFileName configuration:(NSString *)configuration withOptions:(__autoreleasing NSDictionary *)options;
- (void) addiCloudContainerID:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)subPathComponent;
- (void) addiCloudContainerID:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreAtURL:(NSURL *)storeURL cloudStorePathComponent:(NSString *)subPathComponent;
- (void) addiCloudContainerID:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)subPathComponent completion:(void(^)(void))completionBlock;
- (void) addiCloudContainerID:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreAtURL:(NSURL *)storeURL cloudStorePathComponent:(NSString *)subPathComponent completion:(void (^)(void))completionBlock;

@end
