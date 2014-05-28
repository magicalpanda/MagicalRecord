#ifdef MR_SHORTHAND

#import "MagicalRecordDeprecated.h"
#import "NSManagedObjectContext+MagicalSaves.h"


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
+ (NSNumber *)aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (NSNumber *)aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate;
- (id) objectWithMinValueFor:(NSString *)property;
- (id) objectWithMinValueFor:(NSString *)property inContext:(NSManagedObjectContext *)context;

@end


@interface NSManagedObject (MagicalFetchingShortHand)


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


@interface NSManagedObject (MagicalRecordShortHand)

+ (NSArray *) executeFetchRequest:(NSFetchRequest *)request;
+ (NSArray *) executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;
+ (id) executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request;
+ (id) executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;
+ (NSEntityDescription *) entityDescription;
+ (NSEntityDescription *) entityDescriptionInContext:(NSManagedObjectContext *)context;
+ (NSArray *) propertiesNamed:(NSArray *)properties;
+ (instancetype) createEntity;
+ (instancetype) createEntityInContext:(NSManagedObjectContext *)context;
+ (instancetype) createEntityWithDescription:(NSEntityDescription *)entityDescription inContext:(NSManagedObjectContext *)context;
- (BOOL) isEntityDeleted;
- (BOOL) deleteEntity;
- (BOOL) deleteEntityInContext:(NSManagedObjectContext *)context;
+ (BOOL) deleteAllMatchingPredicate:(NSPredicate *)predicate;
+ (BOOL) deleteAllMatchingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (BOOL) truncateAll;
+ (BOOL) truncateAllInContext:(NSManagedObjectContext *)context;
+ (NSArray *) ascendingSortDescriptors:(NSArray *)attributesToSortBy;
+ (NSArray *) descendingSortDescriptors:(NSArray *)attributesToSortBy;
- (void) obtainPermanentObjectID;
- (void) refresh;
- (instancetype) inContext:(NSManagedObjectContext *)otherContext;
- (instancetype) inContextIfTemporaryObject:(NSManagedObjectContext *)otherContext;
- (BOOL) isValidForInsert;
- (BOOL) isValidForUpdate;

@end


@interface NSManagedObject (MagicalRecordOptionalShortHand)

- (void) awakeFromCreation;

@end


@interface NSManagedObject (MagicalRecordDeprecatedShortHand)

+ (instancetype) createInContext:(NSManagedObjectContext *)context MR_DEPRECATED_IN_3_0_PLEASE_USE("createEntityInContext:");
- (BOOL) deleteInContext:(NSManagedObjectContext *)context MR_DEPRECATED_IN_3_0_PLEASE_USE("deleteEntityInContext:");
- (instancetype) inContextIfTempObject:(NSManagedObjectContext *)otherContext MR_DEPRECATED_IN_3_0_PLEASE_USE("inContextIfTemporaryObject:");

@end


@interface NSManagedObject (MagicalRequestsShortHand)

+ (NSUInteger) defaultBatchSize;
+ (void) setDefaultBatchSize:(NSUInteger)newBatchSize;
+ (NSFetchRequest *) requestAll;
+ (NSFetchRequest *) requestAllWithPredicate:(NSPredicate *)searchTerm;
+ (NSFetchRequest *) requestAllWhere:(NSString *)property isEqualTo:(id)value;
+ (NSFetchRequest *) requestFirstWithPredicate:(NSPredicate *)searchTerm;
+ (NSFetchRequest *) requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;

@end


@interface NSManagedObjectContext (MagicalObservingShortHand)

- (void) observeContext:(NSManagedObjectContext *)otherContext;
- (void) stopObservingContext:(NSManagedObjectContext *)otherContext;
- (void) observeContextOnMainThread:(NSManagedObjectContext *)otherContext;
- (void) observeiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator;
- (void) stopObservingiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator;

@end


@interface NSManagedObjectContext (MagicalRecordShortHand)

- (void) obtainPermanentIDsForObjects:(NSArray *)objects;
+ (NSManagedObjectContext *) context NS_RETURNS_RETAINED;
+ (NSManagedObjectContext *) mainQueueContext;
+ (NSManagedObjectContext *) privateQueueContext;
+ (NSManagedObjectContext *) confinementContext;
+ (NSManagedObjectContext *) confinementContextWithParent:(NSManagedObjectContext *)parentContext;
+ (NSManagedObjectContext *) privateQueueContextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator NS_RETURNS_RETAINED;
- (NSString *) parentChain;
- (void) setWorkingName:(NSString *)workingName;
- (NSString *) workingName;

@end


@interface NSManagedObjectContext (MagicalSavesShortHand)

- (void) saveOnlySelfWithCompletion:(MRSaveCompletionHandler)completion;
- (void) saveToPersistentStoreWithCompletion:(MRSaveCompletionHandler)completion;
- (BOOL) saveOnlySelfAndWait;
- (BOOL) saveOnlySelfAndWaitWithError:(NSError **)error;
- (BOOL) saveToPersistentStoreAndWait;
- (BOOL) saveToPersistentStoreAndWaitWithError:(NSError **)error;

@end


@interface NSManagedObjectModel (MagicalRecordShortHand)

+ (NSManagedObjectModel *) managedObjectModelAtURL:(NSURL *)url;
+ (NSManagedObjectModel *) mergedObjectModelFromMainBundle;
+ (NSManagedObjectModel *) managedObjectModelNamed:(NSString *)modelFileName;
+ (NSManagedObjectModel *) newModelNamed:(NSString *) modelName inBundleNamed:(NSString *) bundleName NS_RETURNS_RETAINED;

@end


@interface NSPersistentStoreCoordinator (MagicalAutoMigrationsShortHand)

- (NSPersistentStore *) addAutoMigratingSqliteStoreNamed:(NSString *)storeFileName;
- (NSPersistentStore *) addAutoMigratingSqliteStoreNamed:(NSString *)storeFileName withOptions:(NSDictionary *)options;
- (NSPersistentStore *) addAutoMigratingSqliteStoreAtURL:(NSURL *)url;
- (NSPersistentStore *) addAutoMigratingSqliteStoreAtURL:(NSURL *)url withOptions:(NSDictionary *)options;
+ (NSPersistentStoreCoordinator *) coordinatorWithAutoMigratingSqliteStoreNamed:(NSString *)storeFileName;
+ (NSPersistentStoreCoordinator *) coordinatorWithAutoMigratingSqliteStoreAtURL:(NSURL *)url;

@end


@interface NSPersistentStoreCoordinator (MagicalInMemoryStoreAdditionsShortHand)

+ (NSPersistentStoreCoordinator *) coordinatorWithInMemoryStore;
+ (NSPersistentStoreCoordinator *) coordinatorWithInMemoryStoreWithModel:(NSManagedObjectModel *)model;
+ (NSPersistentStoreCoordinator *) coordinatorWithInMemoryStoreWithModel:(NSManagedObjectModel *)model withOptions:(NSDictionary *)options;
- (NSPersistentStore *) addInMemoryStore;
- (NSPersistentStore *) addInMemoryStoreWithOptions:(NSDictionary *)options;

@end


@interface NSPersistentStoreCoordinator (MagicalManualMigrationsShortHand)

- (NSPersistentStore *) addManuallyMigratingSqliteStoreAtURL:(NSURL *)url;
- (NSPersistentStore *) addManuallyMigratingSqliteStoreNamed:(NSString *)storeFileName;
+ (NSPersistentStoreCoordinator *) coordinatorWithManuallyMigratingSqliteStoreNamed:(NSString *)storeFileName;
+ (NSPersistentStoreCoordinator *) coordinatorWithManuallyMigratingSqliteStoreAtURL:(NSURL *)url;

@end


@interface NSPersistentStoreCoordinator (MagicalRecordShortHand)

+ (NSPersistentStoreCoordinator *) newPersistentStoreCoordinator NS_RETURNS_RETAINED;
+ (NSPersistentStoreCoordinator *) coordinatorWithPersistentStore:(NSPersistentStore *)persistentStore;
+ (NSPersistentStoreCoordinator *) coordinatorWithPersistentStore:(NSPersistentStore *)persistentStore andModel:(NSManagedObjectModel *)model;
+ (NSPersistentStoreCoordinator *) coordinatorWithPersistentStore:(NSPersistentStore *)persistentStore andModel:(NSManagedObjectModel *)model withOptions:(NSDictionary *)options;
+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreNamed:(NSString *)storeFileName;
+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreNamed:(NSString *)storeFileName withOptions:(NSDictionary *)options;
+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreNamed:(NSString *)storeFileName andModel:(NSManagedObjectModel *)model withOptions:(NSDictionary *)options;
+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreAtURL:(NSURL *)url;
+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreAtURL:(NSURL *)url andModel:(NSManagedObjectModel *)model;
+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreAtURL:(NSURL *)url andModel:(NSManagedObjectModel *)model withOptions:(NSDictionary *)options;
- (NSPersistentStore *) addSqliteStoreAtURL:(NSURL *)url withOptions:(NSDictionary *__autoreleasing)options;
- (NSPersistentStore *) addSqliteStoreNamed:(id)storeFileName withOptions:(__autoreleasing NSDictionary *)options;

@end

#endif
