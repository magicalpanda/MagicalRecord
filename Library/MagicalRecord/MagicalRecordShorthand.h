#ifdef MR_SHORTHAND

#import "MagicalRecordDeprecated.h"
#import "NSManagedObjectContext+MagicalSaves.h"


@interface NSManagedObject (MagicalAggregationShortHand)

+ (NSNumber *) numberOfEntities MRDeprecated("Use +MR_numberOfEntities instead");
+ (NSNumber *) numberOfEntitiesWithContext:(NSManagedObjectContext *)context MRDeprecated("Use +MR_numberOfEntitiesWithContext: instead");
+ (NSNumber *) numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm MRDeprecated("Use +MR_numberOfEntitiesWithPredicate: instead");
+ (NSNumber *) numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context MRDeprecated("Use +MR_numberOfEntitiesWithPredicate:inContext: instead");
+ (NSUInteger) countOfEntities MRDeprecated("Use +MR_countOfEntities instead");
+ (NSUInteger) countOfEntitiesWithContext:(NSManagedObjectContext *)context MRDeprecated("Use +MR_countOfEntitiesWithContext: instead");
+ (NSUInteger) countOfEntitiesWithPredicate:(NSPredicate *)searchFilter MRDeprecated("Use +MR_countOfEntitiesWithPredicate: instead");
+ (NSUInteger) countOfEntitiesWithPredicate:(NSPredicate *)searchFilter inContext:(NSManagedObjectContext *)context MRDeprecated("Use +MR_countOfEntitiesWithPredicate:inContext: instead");
+ (BOOL) hasAtLeastOneEntity MRDeprecated("Use +MR_hasAtLeastOneEntity instead");
+ (BOOL) hasAtLeastOneEntityInContext:(NSManagedObjectContext *)context MRDeprecated("Use +MR_hasAtLeastOneEntityInContext: instead");
+ (NSNumber *)aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context MRDeprecated("Use +MR_aggregateOperation:onAttribute:withPredicate:inContext: instead");
+ (NSNumber *)aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate MRDeprecated("Use +MR_aggregateOperation:onAttribute:withPredicate: instead");
- (id) objectWithMinValueFor:(NSString *)property MRDeprecated("Use -MR_objectWithMinValueFor: instead");
- (id) objectWithMinValueFor:(NSString *)property inContext:(NSManagedObjectContext *)context MRDeprecated("Use -MR_objectWithMinValueFor:inContext: instead");

@end


@interface NSManagedObject (MagicalFetchingShortHand)


#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate MRDeprecated("Use +MR_fetchAllSortedBy:ascending:withPredicate:groupBy:delegate: instead");

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context MRDeprecated("Use +MR_fetchAllSortedBy:ascending:withPredicate:groupBy:delegate:inContext: instead");

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending MRDeprecated("Use +MR_fetchAllGroupedBy:withPredicate:sortedBy:ascending: instead");

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context MRDeprecated("Use +MR_fetchAllGroupedBy:withPredicate:sortedBy:ascending:inContext: instead");

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id<NSFetchedResultsControllerDelegate>)delegate MRDeprecated("Use +MR_fetchAllGroupedBy:withPredicate:sortedBy:ascending:delegate: instead");

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context MRDeprecated("Use +MR_fetchAllGroupedBy:withPredicate:sortedBy:ascending:delegate:inContext: instead");

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

@end


@interface NSManagedObject (MagicalRecordShortHand)

+ (NSString *) internalEntityName;
+ (NSArray *) executeFetchRequest:(NSFetchRequest *)request MRDeprecated("Use +MR_executeFetchRequest: instead");
+ (NSArray *) executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context MRDeprecated("Use +MR_executeFetchRequest:inContext: instead");
+ (id) executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request MRDeprecated("Use +MR_executeFetchRequestAndReturnFirstObject: instead");
+ (id) executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context MRDeprecated("Use +MR_executeFetchRequestAndReturnFirstObject:inContext: instead");
+ (NSEntityDescription *) entityDescription MRDeprecated("Use +MR_entityDescription instead");
+ (NSEntityDescription *) entityDescriptionInContext:(NSManagedObjectContext *)context MRDeprecated("Use +MR_entityDescriptionInContext: instead");
+ (NSArray *) propertiesNamed:(NSArray *)properties MRDeprecated("Use +MR_propertiesNamed: instead");
+ (instancetype) createEntity MRDeprecated("Use +MR_createEntity instead");
+ (instancetype) createEntityInContext:(NSManagedObjectContext *)context MRDeprecated("Use +MR_createEntityInContext: instead");
+ (instancetype) createEntityWithDescription:(NSEntityDescription *)entityDescription inContext:(NSManagedObjectContext *)context MRDeprecated("Use +MR_createEntityWithDescription:inContext: instead");
- (BOOL) isEntityDeleted MRDeprecated("Use -MR_isEntityDeleted instead");
- (BOOL) deleteEntity MRDeprecated("Use -MR_deleteEntity instead");
- (BOOL) deleteEntityInContext:(NSManagedObjectContext *)context MRDeprecated("Use -MR_deleteEntityInContext: instead");
+ (BOOL) deleteAllMatchingPredicate:(NSPredicate *)predicate MRDeprecated("Use +MR_deleteAllMatchingPredicate: instead");
+ (BOOL) deleteAllMatchingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context MRDeprecated("Use +MR_deleteAllMatchingPredicate:inContext: instead");
+ (BOOL) truncateAll MRDeprecated("Use +MR_truncateAll instead");
+ (BOOL) truncateAllInContext:(NSManagedObjectContext *)context MRDeprecated("Use +MR_truncateAllInContext: instead");
+ (NSArray *) ascendingSortDescriptors:(NSArray *)attributesToSortBy MRDeprecated("Use +MR_ascendingSortDescriptors: instead");
+ (NSArray *) descendingSortDescriptors:(NSArray *)attributesToSortBy MRDeprecated("Use +MR_descendingSortDescriptors: instead");
- (void) obtainPermanentObjectID MRDeprecated("Use -MR_obtainPermanentObjectID instead");
- (void) refresh MRDeprecated("Use -MR_refresh instead");
- (instancetype) inContext:(NSManagedObjectContext *)otherContext MRDeprecated("Use -MR_inContext: instead");
- (instancetype) inContextIfTemporaryObject:(NSManagedObjectContext *)otherContext MRDeprecated("Use -MR_inContextIfTemporaryObject: instead");
- (BOOL) isValidForInsert MRDeprecated("Use -MR_isValidForInsert instead");
- (BOOL) isValidForUpdate MRDeprecated("Use -MR_isValidForUpdate instead");

@end


@interface NSManagedObject (MagicalRecordOptionalShortHand)

- (void) awakeFromCreation MRDeprecated("Use -MR_awakeFromCreation instead");

@end


@interface NSManagedObject (MagicalRecordDeprecatedShortHand)

+ (instancetype) createInContext:(NSManagedObjectContext *)context MRDeprecated("Please use +MR_createEntityInContext:");
- (BOOL) deleteInContext:(NSManagedObjectContext *)context MRDeprecated("Please use +MR_deleteEntityInContext:");
- (instancetype) inContextIfTempObject:(NSManagedObjectContext *)otherContext MRDeprecated("Please use +MR_inContextIfTemporaryObject:");

@end


@interface NSManagedObject (MagicalRequestsShortHand)

+ (NSUInteger) defaultBatchSize MRDeprecated("Use +MR_defaultBatchSize instead");
+ (void) setDefaultBatchSize:(NSUInteger)newBatchSize MRDeprecated("Use +MR_setDefaultBatchSize: instead");
+ (NSFetchRequest *) requestAll MRDeprecated("Use +MR_requestAll instead");
+ (NSFetchRequest *) requestAllWithPredicate:(NSPredicate *)searchTerm MRDeprecated("Use +MR_requestAllWithPredicate: instead");
+ (NSFetchRequest *) requestAllWhere:(NSString *)property isEqualTo:(id)value MRDeprecated("Use +MR_requestAllWhere:isEqualTo: instead");
+ (NSFetchRequest *) requestFirstWithPredicate:(NSPredicate *)searchTerm MRDeprecated("Use +MR_requestFirstWithPredicate: instead");
+ (NSFetchRequest *) requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue MRDeprecated("Use +MR_requestFirstByAttribute:withValue: instead");
+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending MRDeprecated("Use +MR_requestAllSortedBy:ascending: instead");
+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm MRDeprecated("Use +MR_requestAllSortedBy:ascending:withPredicate: instead");

@end


@interface NSManagedObjectContext (MagicalObservingShortHand)

- (void) observeContext:(NSManagedObjectContext *)otherContext MRDeprecated("Use -MR_observeContext: instead");
- (void) stopObservingContext:(NSManagedObjectContext *)otherContext MRDeprecated("Use -MR_stopObservingContext: instead");
- (void) observeContextOnMainThread:(NSManagedObjectContext *)otherContext MRDeprecated("Use -MR_observeContextOnMainThread: instead");
- (void) observeiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator MRDeprecated("Use -MR_observeiCloudChangesInCoordinator: instead");
- (void) stopObservingiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator MRDeprecated("Use -MR_stopObservingiCloudChangesInCoordinator: instead");

@end


@interface NSManagedObjectContext (MagicalRecordShortHand)

- (void) obtainPermanentIDsForObjects:(NSArray *)objects MRDeprecated("Use -MR_obtainPermanentIDsForObjects: instead");
+ (NSManagedObjectContext *) context NS_RETURNS_RETAINED MRDeprecated("Use +MR_context instead");
+ (NSManagedObjectContext *) mainQueueContext MRDeprecated("Use +MR_mainQueueContext instead");
+ (NSManagedObjectContext *) privateQueueContext MRDeprecated("Use +MR_privateQueueContext instead");
+ (NSManagedObjectContext *) confinementContext MRDeprecated("Use +MR_confinementContext instead");
+ (NSManagedObjectContext *) confinementContextWithParent:(NSManagedObjectContext *)parentContext MRDeprecated("Use +MR_confinementContextWithParent: instead");
+ (NSManagedObjectContext *) privateQueueContextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator NS_RETURNS_RETAINED MRDeprecated("Use +MR_privateQueueContextWithStoreCoordinator:NS_RETURNS_RETAINED instead");
- (NSString *) parentChain MRDeprecated("Use -MR_parentChain instead");
- (void) setWorkingName:(NSString *)workingName MRDeprecated("Use -MR_setWorkingName: instead");
- (NSString *) workingName MRDeprecated("Use -MR_workingName instead");

@end


@interface NSManagedObjectContext (MagicalSavesShortHand)

- (void) saveOnlySelfWithCompletion:(MRSaveCompletionHandler)completion MRDeprecated("Use -MR_saveOnlySelfWithCompletion: instead");
- (void) saveToPersistentStoreWithCompletion:(MRSaveCompletionHandler)completion MRDeprecated("Use -MR_saveToPersistentStoreWithCompletion: instead");
- (void) saveOnlySelfAndWait MRDeprecated("Use -MR_saveOnlySelfAndWait instead");
- (void) saveToPersistentStoreAndWait MRDeprecated("Use -MR_saveToPersistentStoreAndWait instead");

@end


@interface NSManagedObjectModel (MagicalRecordShortHand)

+ (NSManagedObjectModel *) managedObjectModelAtURL:(NSURL *)url MRDeprecated("Use +MR_managedObjectModelAtURL: instead");
+ (NSManagedObjectModel *) mergedObjectModelFromMainBundle MRDeprecated("Use +MR_mergedObjectModelFromMainBundle instead");
+ (NSManagedObjectModel *) managedObjectModelNamed:(NSString *)modelFileName MRDeprecated("Use +MR_managedObjectModelNamed: instead");
+ (NSManagedObjectModel *) newModelNamed:(NSString *) modelName inBundleNamed:(NSString *) bundleName NS_RETURNS_RETAINED MRDeprecated("Use +MR_newModelNamed: instead");

@end


@interface NSPersistentStoreCoordinator (MagicalAutoMigrationsShortHand)

- (NSPersistentStore *) addAutoMigratingSqliteStoreNamed:(NSString *)storeFileName MRDeprecated("Use -MR_addAutoMigratingSqliteStoreNamed: instead");
- (NSPersistentStore *) addAutoMigratingSqliteStoreNamed:(NSString *)storeFileName withOptions:(NSDictionary *)options MRDeprecated("Use -MR_addAutoMigratingSqliteStoreNamed:withOptions: instead");
- (NSPersistentStore *) addAutoMigratingSqliteStoreAtURL:(NSURL *)url MRDeprecated("Use -MR_addAutoMigratingSqliteStoreAtURL: instead");
- (NSPersistentStore *) addAutoMigratingSqliteStoreAtURL:(NSURL *)url withOptions:(NSDictionary *)options MRDeprecated("Use -MR_addAutoMigratingSqliteStoreAtURL:withOptions: instead");
+ (NSPersistentStoreCoordinator *) coordinatorWithAutoMigratingSqliteStoreNamed:(NSString *)storeFileName MRDeprecated("Use +MR_coordinatorWithAutoMigratingSqliteStoreNamed: instead");
+ (NSPersistentStoreCoordinator *) coordinatorWithAutoMigratingSqliteStoreAtURL:(NSURL *)url MRDeprecated("Use +MR_coordinatorWithAutoMigratingSqliteStoreAtURL: instead");

@end


@interface NSPersistentStoreCoordinator (MagicalInMemoryStoreAdditionsShortHand)

+ (NSPersistentStoreCoordinator *) coordinatorWithInMemoryStore MRDeprecated("Use +MR_coordinatorWithInMemoryStore instead");
+ (NSPersistentStoreCoordinator *) coordinatorWithInMemoryStoreWithModel:(NSManagedObjectModel *)model MRDeprecated("Use +MR_coordinatorWithInMemoryStoreWithModel: instead");
+ (NSPersistentStoreCoordinator *) coordinatorWithInMemoryStoreWithModel:(NSManagedObjectModel *)model withOptions:(NSDictionary *)options MRDeprecated("Use +MR_coordinatorWithInMemoryStoreWithModel:withOptions: instead");
- (NSPersistentStore *) addInMemoryStore MRDeprecated("Use -MR_addInMemoryStore instead");
- (NSPersistentStore *) addInMemoryStoreWithOptions:(NSDictionary *)options MRDeprecated("Use -MR_addInMemoryStoreWithOptions: instead");

@end


@interface NSPersistentStoreCoordinator (MagicalManualMigrationsShortHand)

- (NSPersistentStore *) addManuallyMigratingSqliteStoreAtURL:(NSURL *)url MRDeprecated("Use -MR_addManuallyMigratingSqliteStoreAtURL: instead");
- (NSPersistentStore *) addManuallyMigratingSqliteStoreNamed:(NSString *)storeFileName MRDeprecated("Use -MR_addManuallyMigratingSqliteStoreNamed: instead");
+ (NSPersistentStoreCoordinator *) coordinatorWithManuallyMigratingSqliteStoreNamed:(NSString *)storeFileName MRDeprecated("Use +MR_coordinatorWithManuallyMigratingSqliteStoreNamed: instead");
+ (NSPersistentStoreCoordinator *) coordinatorWithManuallyMigratingSqliteStoreAtURL:(NSURL *)url MRDeprecated("Use +MR_coordinatorWithManuallyMigratingSqliteStoreAtURL: instead");

@end


@interface NSPersistentStoreCoordinator (MagicalRecordShortHand)

+ (NSPersistentStoreCoordinator *) newPersistentStoreCoordinator NS_RETURNS_RETAINED MRDeprecated("Use +MR_newPersistentStoreCoordinator instead");
+ (NSPersistentStoreCoordinator *) coordinatorWithPersistentStore:(NSPersistentStore *)persistentStore MRDeprecated("Use +MR_coordinatorWithPersistentStore: instead");
+ (NSPersistentStoreCoordinator *) coordinatorWithPersistentStore:(NSPersistentStore *)persistentStore andModel:(NSManagedObjectModel *)model MRDeprecated("Use +MR_coordinatorWithPersistentStore:andModel: instead");
+ (NSPersistentStoreCoordinator *) coordinatorWithPersistentStore:(NSPersistentStore *)persistentStore andModel:(NSManagedObjectModel *)model withOptions:(NSDictionary *)options MRDeprecated("Use +MR_coordinatorWithPersistentStore:andModel:withOptions: instead");
+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreNamed:(NSString *)storeFileName MRDeprecated("Use +MR_coordinatorWithSqliteStoreNamed: instead");
+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreNamed:(NSString *)storeFileName withOptions:(NSDictionary *)options MRDeprecated("Use +MR_coordinatorWithSqliteStoreNamed:withOptions: instead");
+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreNamed:(NSString *)storeFileName andModel:(NSManagedObjectModel *)model withOptions:(NSDictionary *)options MRDeprecated("Use +MR_coordinatorWithSqliteStoreNamed:andModel:withOptions: instead");
+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreAtURL:(NSURL *)url MRDeprecated("Use +MR_coordinatorWithSqliteStoreAtURL: instead");
+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreAtURL:(NSURL *)url andModel:(NSManagedObjectModel *)model MRDeprecated("Use +MR_coordinatorWithSqliteStoreAtURL:andModel: instead");
+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreAtURL:(NSURL *)url andModel:(NSManagedObjectModel *)model withOptions:(NSDictionary *)options MRDeprecated("Use +MR_coordinatorWithSqliteStoreAtURL:andModel:withOptions: instead");
- (NSPersistentStore *) addSqliteStoreAtURL:(NSURL *)url withOptions:(NSDictionary *__autoreleasing)options MRDeprecated("Use -MR_addSqliteStoreAtURL:withOptions: instead");
- (NSPersistentStore *) addSqliteStoreNamed:(id)storeFileName withOptions:(__autoreleasing NSDictionary *)options MRDeprecated("Use -MR_addSqliteStoreNamed:withOptions: instead");

@end

#endif
