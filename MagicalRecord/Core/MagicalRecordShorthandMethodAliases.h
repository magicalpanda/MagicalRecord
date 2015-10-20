#import <MagicalRecord/MagicalRecord.h>
#import <MagicalRecord/MagicalRecordDeprecationMacros.h>
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>

@interface NSManagedObject (MagicalAggregationShortHand)

+ (MR_nonnull NSNumber *) numberOfEntities;
+ (MR_nonnull NSNumber *) numberOfEntitiesWithContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nonnull NSNumber *) numberOfEntitiesWithPredicate:(MR_nullable NSPredicate *)searchTerm;
+ (MR_nonnull NSNumber *) numberOfEntitiesWithPredicate:(MR_nullable NSPredicate *)searchTerm inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (NSUInteger) countOfEntities;
+ (NSUInteger) countOfEntitiesWithContext:(MR_nonnull NSManagedObjectContext *)context;
+ (NSUInteger) countOfEntitiesWithPredicate:(MR_nullable NSPredicate *)searchFilter;
+ (NSUInteger) countOfEntitiesWithPredicate:(MR_nullable NSPredicate *)searchFilter inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (BOOL) hasAtLeastOneEntity;
+ (BOOL) hasAtLeastOneEntityInContext:(MR_nonnull NSManagedObjectContext *)context;
- (MR_nullable id) minValueFor:(MR_nonnull NSString *)property;
- (MR_nullable id) maxValueFor:(MR_nonnull NSString *)property;
+ (MR_nullable id) aggregateOperation:(MR_nonnull NSString *)function onAttribute:(MR_nonnull NSString *)attributeName withPredicate:(MR_nullable NSPredicate *)predicate inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable id) aggregateOperation:(MR_nonnull NSString *)function onAttribute:(MR_nonnull NSString *)attributeName withPredicate:(MR_nullable NSPredicate *)predicate;
+ (MR_nullable NSArray *) aggregateOperation:(MR_nonnull NSString *)collectionOperator onAttribute:(MR_nonnull NSString *)attributeName withPredicate:(MR_nullable NSPredicate *)predicate groupBy:(MR_nullable NSString*)groupingKeyPath inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable NSArray *) aggregateOperation:(MR_nonnull NSString *)collectionOperator onAttribute:(MR_nonnull NSString *)attributeName withPredicate:(MR_nullable NSPredicate *)predicate groupBy:(MR_nullable NSString*)groupingKeyPath;
- (MR_nullable instancetype) objectWithMinValueFor:(MR_nonnull NSString *)property;
- (MR_nullable instancetype) objectWithMinValueFor:(MR_nonnull NSString *)property inContext:(MR_nonnull NSManagedObjectContext *)context;

@end


@interface NSManagedObject (MagicalRecord_DataImportShortHand)

- (BOOL) importValuesForKeysWithObject:(MR_nonnull id)objectData;
+ (MR_nonnull instancetype) importFromObject:(MR_nonnull id)data;
+ (MR_nonnull instancetype) importFromObject:(MR_nonnull id)data inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nonnull MR_NSArrayOfNSManagedObjects) importFromArray:(MR_nonnull MR_GENERIC(NSArray, NSDictionary *) *)listOfObjectData;
+ (MR_nonnull MR_NSArrayOfNSManagedObjects) importFromArray:(MR_nonnull MR_GENERIC(NSArray, NSDictionary *) *)listOfObjectData inContext:(MR_nonnull NSManagedObjectContext *)context;

@end


@interface NSManagedObject (MagicalFindersShortHand)

+ (MR_nullable MR_NSArrayOfNSManagedObjects) findAll;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) findAllInContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) findAllSortedBy:(MR_nonnull NSString *)sortTerm ascending:(BOOL)ascending;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) findAllSortedBy:(MR_nonnull NSString *)sortTerm ascending:(BOOL)ascending inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) findAllSortedBy:(MR_nonnull NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(MR_nullable NSPredicate *)searchTerm;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) findAllSortedBy:(MR_nonnull NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(MR_nullable NSPredicate *)searchTerm inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) findAllWithPredicate:(MR_nullable NSPredicate *)searchTerm;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) findAllWithPredicate:(MR_nullable NSPredicate *)searchTerm inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable instancetype) findFirst;
+ (MR_nullable instancetype) findFirstInContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable instancetype) findFirstWithPredicate:(MR_nullable NSPredicate *)searchTerm;
+ (MR_nullable instancetype) findFirstWithPredicate:(MR_nullable NSPredicate *)searchTerm inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable instancetype) findFirstWithPredicate:(MR_nullable NSPredicate *)searchterm sortedBy:(MR_nullable NSString *)property ascending:(BOOL)ascending;
+ (MR_nullable instancetype) findFirstWithPredicate:(MR_nullable NSPredicate *)searchterm sortedBy:(MR_nullable NSString *)property ascending:(BOOL)ascending inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable instancetype) findFirstWithPredicate:(MR_nullable NSPredicate *)searchTerm andRetrieveAttributes:(MR_nullable NSArray *)attributes;
+ (MR_nullable instancetype) findFirstWithPredicate:(MR_nullable NSPredicate *)searchTerm andRetrieveAttributes:(MR_nullable NSArray *)attributes inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable instancetype) findFirstWithPredicate:(MR_nullable NSPredicate *)searchTerm sortedBy:(MR_nullable NSString *)sortBy ascending:(BOOL)ascending andRetrieveAttributes:(MR_nullable id)attributes, ...;
+ (MR_nullable instancetype) findFirstWithPredicate:(MR_nullable NSPredicate *)searchTerm sortedBy:(MR_nullable NSString *)sortBy ascending:(BOOL)ascending inContext:(MR_nonnull NSManagedObjectContext *)context andRetrieveAttributes:(MR_nullable id)attributes, ...;
+ (MR_nullable instancetype) findFirstByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nonnull id)searchValue;
+ (MR_nullable instancetype) findFirstByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nonnull id)searchValue inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable instancetype) findFirstOrderedByAttribute:(MR_nonnull NSString *)attribute ascending:(BOOL)ascending;
+ (MR_nullable instancetype) findFirstOrderedByAttribute:(MR_nonnull NSString *)attribute ascending:(BOOL)ascending inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nonnull instancetype) findFirstOrCreateByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nonnull id)searchValue;
+ (MR_nonnull instancetype) findFirstOrCreateByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nonnull id)searchValue inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) findByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nonnull id)searchValue;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) findByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nonnull id)searchValue inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) findByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nonnull id)searchValue andOrderBy:(MR_nullable NSString *)sortTerm ascending:(BOOL)ascending;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) findByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nonnull id)searchValue andOrderBy:(MR_nullable NSString *)sortTerm ascending:(BOOL)ascending inContext:(MR_nonnull NSManagedObjectContext *)context;

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (MR_nonnull NSFetchedResultsController *) fetchController:(MR_nonnull NSFetchRequest *)request delegate:(MR_nullable id<NSFetchedResultsControllerDelegate>)delegate useFileCache:(BOOL)useFileCache groupedBy:(MR_nullable NSString *)groupKeyPath inContext:(MR_nonnull NSManagedObjectContext *)context;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (MR_nonnull NSFetchedResultsController *) fetchAllWithDelegate:(MR_nullable id<NSFetchedResultsControllerDelegate>)delegate;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (MR_nonnull NSFetchedResultsController *) fetchAllWithDelegate:(MR_nullable id<NSFetchedResultsControllerDelegate>)delegate inContext:(MR_nonnull NSManagedObjectContext *)context;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (MR_nonnull NSFetchedResultsController *) fetchAllSortedBy:(MR_nullable NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(MR_nullable NSPredicate *)searchTerm groupBy:(MR_nullable NSString *)groupingKeyPath delegate:(MR_nullable id<NSFetchedResultsControllerDelegate>)delegate;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (MR_nonnull NSFetchedResultsController *) fetchAllSortedBy:(MR_nullable NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(MR_nullable NSPredicate *)searchTerm groupBy:(MR_nullable NSString *)groupingKeyPath delegate:(MR_nullable id<NSFetchedResultsControllerDelegate>)delegate inContext:(MR_nonnull NSManagedObjectContext *)context;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (MR_nonnull NSFetchedResultsController *) fetchAllGroupedBy:(MR_nullable NSString *)group withPredicate:(MR_nullable NSPredicate *)searchTerm sortedBy:(MR_nullable NSString *)sortTerm ascending:(BOOL)ascending;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (MR_nonnull NSFetchedResultsController *) fetchAllGroupedBy:(MR_nullable NSString *)group withPredicate:(MR_nullable NSPredicate *)searchTerm sortedBy:(MR_nullable NSString *)sortTerm ascending:(BOOL)ascending inContext:(MR_nonnull NSManagedObjectContext *)context;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (MR_nonnull NSFetchedResultsController *) fetchAllGroupedBy:(MR_nullable NSString *)group withPredicate:(MR_nullable NSPredicate *)searchTerm sortedBy:(MR_nullable NSString *)sortTerm ascending:(BOOL)ascending delegate:(MR_nullable id<NSFetchedResultsControllerDelegate>)delegate;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (MR_nonnull NSFetchedResultsController *) fetchAllGroupedBy:(MR_nullable NSString *)group withPredicate:(MR_nullable NSPredicate *)searchTerm sortedBy:(MR_nullable NSString *)sortTerm ascending:(BOOL)ascending delegate:(MR_nullable id<NSFetchedResultsControllerDelegate>)delegate inContext:(MR_nonnull NSManagedObjectContext *)context;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

@end


@interface NSManagedObject (MagicalRecordShortHand)

+ (MR_nonnull NSString *) entityName;
+ (NSUInteger) defaultBatchSize;
+ (void) setDefaultBatchSize:(NSUInteger)newBatchSize;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) executeFetchRequest:(MR_nonnull NSFetchRequest *)request;
+ (MR_nullable MR_NSArrayOfNSManagedObjects) executeFetchRequest:(MR_nonnull NSFetchRequest *)request inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable instancetype) executeFetchRequestAndReturnFirstObject:(MR_nonnull NSFetchRequest *)request;
+ (MR_nullable instancetype) executeFetchRequestAndReturnFirstObject:(MR_nonnull NSFetchRequest *)request inContext:(MR_nonnull NSManagedObjectContext *)context;

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (BOOL) performFetch:(MR_nonnull NSFetchedResultsController *)controller;

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */
+ (MR_nullable NSEntityDescription *) entityDescription;
+ (MR_nullable NSEntityDescription *) entityDescriptionInContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable MR_GENERIC(NSArray, NSPropertyDescription *) *) propertiesNamed:(MR_nonnull MR_GENERIC(NSArray, NSString *) *)properties;
+ (MR_nullable MR_GENERIC(NSArray, NSPropertyDescription *) *) propertiesNamed:(MR_nonnull MR_GENERIC(NSArray, NSString *) *)properties inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nullable instancetype) createEntity;
+ (MR_nullable instancetype) createEntityInContext:(MR_nonnull NSManagedObjectContext *)context;
- (BOOL) deleteEntity;
- (BOOL) deleteEntityInContext:(MR_nonnull NSManagedObjectContext *)context;
+ (BOOL) deleteAllMatchingPredicate:(MR_nonnull NSPredicate *)predicate;
+ (BOOL) deleteAllMatchingPredicate:(MR_nonnull NSPredicate *)predicate inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (BOOL) truncateAll;
+ (BOOL) truncateAllInContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nonnull MR_GENERIC(NSArray, NSSortDescriptor *) *) ascendingSortDescriptors:(MR_nonnull MR_GENERIC(NSArray, NSString *) *)attributesToSortBy;
+ (MR_nonnull MR_GENERIC(NSArray, NSSortDescriptor *) *) descendingSortDescriptors:(MR_nonnull MR_GENERIC(NSArray, NSString *) *)attributesToSortBy;
- (MR_nullable instancetype) inContext:(MR_nonnull NSManagedObjectContext *)otherContext;
- (MR_nullable instancetype) inThreadContext;

@end


@interface NSManagedObject (MagicalRecordDeprecatedShortHand)

+ (MR_nullable instancetype) createInContext:(MR_nonnull NSManagedObjectContext *)context MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_createEntityInContext:");
- (BOOL) deleteInContext:(MR_nonnull NSManagedObjectContext *)context MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_deleteEntityInContext:");

@end


@interface NSManagedObject (MagicalRequestsShortHand)

+ (MR_nonnull NSFetchRequest *) createFetchRequest;
+ (MR_nonnull NSFetchRequest *) createFetchRequestInContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nonnull NSFetchRequest *) requestAll;
+ (MR_nonnull NSFetchRequest *) requestAllInContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nonnull NSFetchRequest *) requestAllWithPredicate:(MR_nullable NSPredicate *)searchTerm;
+ (MR_nonnull NSFetchRequest *) requestAllWithPredicate:(MR_nullable NSPredicate *)searchTerm inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nonnull NSFetchRequest *) requestAllWhere:(MR_nonnull NSString *)property isEqualTo:(MR_nonnull id)value;
+ (MR_nonnull NSFetchRequest *) requestAllWhere:(MR_nonnull NSString *)property isEqualTo:(MR_nonnull id)value inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nonnull NSFetchRequest *) requestFirstWithPredicate:(MR_nullable NSPredicate *)searchTerm;
+ (MR_nonnull NSFetchRequest *) requestFirstWithPredicate:(MR_nullable NSPredicate *)searchTerm inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nonnull NSFetchRequest *) requestFirstByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nullable id)searchValue;
+ (MR_nonnull NSFetchRequest *) requestFirstByAttribute:(MR_nonnull NSString *)attribute withValue:(MR_nullable id)searchValue inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nonnull NSFetchRequest *) requestAllSortedBy:(MR_nonnull NSString *)sortTerm ascending:(BOOL)ascending;
+ (MR_nonnull NSFetchRequest *) requestAllSortedBy:(MR_nonnull NSString *)sortTerm ascending:(BOOL)ascending inContext:(MR_nonnull NSManagedObjectContext *)context;
+ (MR_nonnull NSFetchRequest *) requestAllSortedBy:(MR_nonnull NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(MR_nullable NSPredicate *)searchTerm;
+ (MR_nonnull NSFetchRequest *) requestAllSortedBy:(MR_nonnull NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(MR_nullable NSPredicate *)searchTerm inContext:(MR_nonnull NSManagedObjectContext *)context;

@end


@interface NSManagedObjectContext (MagicalRecordChainSaveShortHand)

- (void)saveWithBlock:(void (^ __MR_nonnull)(NSManagedObjectContext * __MR_nonnull localContext))block;
- (void)saveWithBlock:(void (^ __MR_nonnull)(NSManagedObjectContext * __MR_nonnull localContext))block completion:(MR_nullable MRSaveCompletionHandler)completion;
- (void)saveWithBlockAndWait:(void (^ __MR_nonnull)(NSManagedObjectContext * __MR_nonnull localContext))block;

@end


@interface NSManagedObjectContext (MagicalObservingShortHand)

- (void) observeContext:(MR_nonnull NSManagedObjectContext *)otherContext;
- (void) stopObservingContext:(MR_nonnull NSManagedObjectContext *)otherContext;
- (void) observeContextOnMainThread:(MR_nonnull NSManagedObjectContext *)otherContext;
- (void) observeiCloudChangesInCoordinator:(MR_nonnull NSPersistentStoreCoordinator *)coordinator;
- (void) stopObservingiCloudChangesInCoordinator:(MR_nonnull NSPersistentStoreCoordinator *)coordinator;

@end


@interface NSManagedObjectContext (MagicalRecordShortHand)

+ (void) initializeDefaultContextWithCoordinator:(MR_nonnull NSPersistentStoreCoordinator *)coordinator;
+ (MR_nonnull NSManagedObjectContext *) rootSavingContext;
+ (MR_nonnull NSManagedObjectContext *) defaultContext;
+ (MR_nonnull NSManagedObjectContext *) context;
+ (MR_nonnull NSManagedObjectContext *) contextWithParent:(MR_nonnull NSManagedObjectContext *)parentContext;
+ (MR_nonnull NSManagedObjectContext *) contextWithStoreCoordinator:(MR_nonnull NSPersistentStoreCoordinator *)coordinator;
+ (MR_nonnull NSManagedObjectContext *) newMainQueueContext NS_RETURNS_RETAINED;
+ (MR_nonnull NSManagedObjectContext *) newPrivateQueueContext NS_RETURNS_RETAINED;
- (void) setWorkingName:(MR_nonnull NSString *)workingName;
- (MR_nonnull NSString *) workingName;
- (MR_nonnull NSString *) description;
- (MR_nonnull NSString *) parentChain;
+ (void) resetDefaultContext;
- (void) deleteObjects:(MR_nonnull id <NSFastEnumeration>)objects;

@end


@interface NSManagedObjectContext (MagicalRecordDeprecatedShortHand)

+ (MR_nonnull NSManagedObjectContext *) contextWithoutParent MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_newPrivateQueueContext");
+ (MR_nonnull NSManagedObjectContext *) newContext MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_context");
+ (MR_nonnull NSManagedObjectContext *) newContextWithParent:(MR_nonnull NSManagedObjectContext *)parentContext MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_contextWithParent:");
+ (MR_nonnull NSManagedObjectContext *) newContextWithStoreCoordinator:(MR_nonnull NSPersistentStoreCoordinator *)coordinator MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "MR_contextWithStoreCoordinator:");

@end


@interface NSManagedObjectContext (MagicalSavesShortHand)

- (void) saveOnlySelfWithCompletion:(MR_nullable MRSaveCompletionHandler)completion;
- (void) saveToPersistentStoreWithCompletion:(MR_nullable MRSaveCompletionHandler)completion;
- (void) saveOnlySelfAndWait;
- (void) saveToPersistentStoreAndWait;
- (void) saveWithOptions:(MRSaveOptions)saveOptions completion:(MR_nullable MRSaveCompletionHandler)completion;

@end


@interface NSManagedObjectContext (MagicalSavesDeprecatedShortHand)

- (void) save MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("3.0", "MR_saveToPersistentStoreAndWait");
- (void) saveWithErrorCallback:(void (^ __MR_nullable)(NSError * __MR_nullable error))errorCallback MR_DEPRECATED_WILL_BE_REMOVED_IN("3.0");
- (void) saveInBackgroundCompletion:(void (^ __MR_nullable)(void))completion MR_DEPRECATED_WILL_BE_REMOVED_IN("3.0");
- (void) saveInBackgroundErrorHandler:(void (^ __MR_nullable)(NSError * __MR_nullable error))errorCallback MR_DEPRECATED_WILL_BE_REMOVED_IN("3.0");
- (void) saveInBackgroundErrorHandler:(void (^ __MR_nullable)(NSError * __MR_nullable error))errorCallback completion:(void (^ __MR_nullable)(void))completion MR_DEPRECATED_WILL_BE_REMOVED_IN("3.0");
- (void) saveNestedContexts MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("3.0", "MR_saveToPersistentStoreWithCompletion:");
- (void) saveNestedContextsErrorHandler:(void (^ __MR_nullable)(NSError * __MR_nullable error))errorCallback MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("3.0", "MR_saveToPersistentStoreWithCompletion:");
- (void) saveNestedContextsErrorHandler:(void (^ __MR_nullable)(NSError * __MR_nullable error))errorCallback completion:(void (^ __MR_nullable)(void))completion MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("3.0", "MR_saveToPersistentStoreWithCompletion:");

@end


@interface NSManagedObjectContext (MagicalThreadingShortHand)

+ (MR_nonnull NSManagedObjectContext *) contextForCurrentThread __attribute((deprecated("This method will be removed in MagicalRecord 3.0")));
+ (void) clearNonMainThreadContextsCache __attribute((deprecated("This method will be removed in MagicalRecord 3.0")));
+ (void) resetContextForCurrentThread __attribute((deprecated("This method will be removed in MagicalRecord 3.0")));
+ (void) clearContextForCurrentThread __attribute((deprecated("This method will be removed in MagicalRecord 3.0")));

@end


@interface NSManagedObjectModel (MagicalRecordShortHand)

+ (MR_nullable NSManagedObjectModel *) defaultManagedObjectModel;
+ (void) setDefaultManagedObjectModel:(MR_nullable NSManagedObjectModel *)newDefaultModel;
+ (MR_nullable NSManagedObjectModel *) mergedObjectModelFromMainBundle;
+ (MR_nullable NSManagedObjectModel *) newManagedObjectModelNamed:(MR_nonnull NSString *)modelFileName NS_RETURNS_RETAINED;
+ (MR_nullable NSManagedObjectModel *) managedObjectModelNamed:(MR_nonnull NSString *)modelFileName;
+ (MR_nullable NSManagedObjectModel *) newModelNamed:(MR_nonnull NSString *) modelName inBundleNamed:(MR_nonnull NSString *) bundleName NS_RETURNS_RETAINED;
+ (MR_nullable NSManagedObjectModel *) newModelNamed:(MR_nonnull NSString *) modelName inBundle:(MR_nonnull NSBundle*) bundle NS_RETURNS_RETAINED;

@end


@interface NSPersistentStore (MagicalRecordShortHand)

+ (MR_nonnull NSURL *) defaultLocalStoreUrl;
+ (MR_nullable NSPersistentStore *) defaultPersistentStore;
+ (void) setDefaultPersistentStore:(MR_nullable NSPersistentStore *) store;
+ (MR_nullable NSURL *) urlForStoreName:(MR_nonnull NSString *)storeFileName;
+ (MR_nullable NSURL *) cloudURLForUbiquitousContainer:(MR_nonnull NSString *)bucketName;
+ (MR_nullable NSURL *) cloudURLForUbiqutiousContainer:(MR_nonnull NSString *)bucketName MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "cloudURLForUbiquitousContainer:");

@end


@interface NSPersistentStoreCoordinator (MagicalRecordShortHand)

+ (MR_nullable NSPersistentStoreCoordinator *) defaultStoreCoordinator;
+ (void) setDefaultStoreCoordinator:(MR_nullable NSPersistentStoreCoordinator *)coordinator;
+ (MR_nonnull NSPersistentStoreCoordinator *) coordinatorWithInMemoryStore;
+ (MR_nonnull NSPersistentStoreCoordinator *) newPersistentStoreCoordinator NS_RETURNS_RETAINED;
+ (MR_nonnull NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreNamed:(MR_nonnull NSString *)storeFileName;
+ (MR_nonnull NSPersistentStoreCoordinator *) coordinatorWithAutoMigratingSqliteStoreNamed:(MR_nonnull NSString *)storeFileName;
+ (MR_nonnull NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreAtURL:(MR_nonnull NSURL *)storeURL;
+ (MR_nonnull NSPersistentStoreCoordinator *) coordinatorWithAutoMigratingSqliteStoreAtURL:(MR_nonnull NSURL *)storeURL;
+ (MR_nonnull NSPersistentStoreCoordinator *) coordinatorWithPersistentStore:(MR_nonnull NSPersistentStore *)persistentStore;
+ (MR_nonnull NSPersistentStoreCoordinator *) coordinatorWithiCloudContainerID:(MR_nonnull NSString *)containerID contentNameKey:(MR_nullable NSString *)contentNameKey localStoreNamed:(MR_nonnull NSString *)localStoreName cloudStorePathComponent:(MR_nullable NSString *)subPathComponent;
+ (MR_nonnull NSPersistentStoreCoordinator *) coordinatorWithiCloudContainerID:(MR_nonnull NSString *)containerID contentNameKey:(MR_nullable NSString *)contentNameKey localStoreAtURL:(MR_nonnull NSURL *)storeURL cloudStorePathComponent:(MR_nullable NSString *)subPathComponent;
+ (MR_nonnull NSPersistentStoreCoordinator *) coordinatorWithiCloudContainerID:(MR_nonnull NSString *)containerID contentNameKey:(MR_nullable NSString *)contentNameKey localStoreNamed:(MR_nonnull NSString *)localStoreName cloudStorePathComponent:(MR_nullable NSString *)subPathComponent completion:(void (^ __MR_nullable)(void))completionHandler;
+ (MR_nonnull NSPersistentStoreCoordinator *) coordinatorWithiCloudContainerID:(MR_nonnull NSString *)containerID contentNameKey:(MR_nullable NSString *)contentNameKey localStoreAtURL:(MR_nonnull NSURL *)storeURL cloudStorePathComponent:(MR_nullable NSString *)subPathComponent completion:(void (^ __MR_nullable)(void))completionHandler;
- (MR_nullable NSPersistentStore *) addInMemoryStore;
- (MR_nullable NSPersistentStore *) addAutoMigratingSqliteStoreNamed:(MR_nonnull NSString *) storeFileName;
- (MR_nullable NSPersistentStore *) addAutoMigratingSqliteStoreAtURL:(MR_nonnull NSURL *)storeURL;
- (MR_nullable NSPersistentStore *) addSqliteStoreNamed:(MR_nonnull id)storeFileName withOptions:(MR_nullable __autoreleasing NSDictionary *)options;
- (MR_nullable NSPersistentStore *) addSqliteStoreNamed:(MR_nonnull id)storeFileName configuration:(MR_nullable NSString *)configuration withOptions:(MR_nullable __autoreleasing NSDictionary *)options;
- (void) addiCloudContainerID:(MR_nonnull NSString *)containerID contentNameKey:(MR_nullable NSString *)contentNameKey localStoreNamed:(MR_nonnull NSString *)localStoreName cloudStorePathComponent:(MR_nullable NSString *)subPathComponent;
- (void) addiCloudContainerID:(MR_nonnull NSString *)containerID contentNameKey:(MR_nullable NSString *)contentNameKey localStoreAtURL:(MR_nonnull NSURL *)storeURL cloudStorePathComponent:(MR_nullable NSString *)subPathComponent;
- (void) addiCloudContainerID:(MR_nonnull NSString *)containerID contentNameKey:(MR_nullable NSString *)contentNameKey localStoreNamed:(MR_nonnull NSString *)localStoreName cloudStorePathComponent:(MR_nullable NSString *)subPathComponent completion:(void (^ __MR_nullable)(void))completionBlock;
- (void) addiCloudContainerID:(MR_nonnull NSString *)containerID contentNameKey:(MR_nullable NSString *)contentNameKey localStoreAtURL:(MR_nonnull NSURL *)storeURL cloudStorePathComponent:(MR_nullable NSString *)subPathComponent completion:(void (^ __MR_nullable)(void))completionBlock;

@end
