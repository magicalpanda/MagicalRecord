#ifdef MR_SHORTHAND

#import "MagicalRecordShorthand.h"
#import "MagicalRecord.h"


@implementation NSManagedObject (MagicalAggregationShortHand)

+ (NSNumber *) numberOfEntities;
{
    return [self MR_numberOfEntities];
}

+ (NSNumber *) numberOfEntitiesWithContext:(NSManagedObjectContext *)context;
{
    return [self MR_numberOfEntitiesWithContext:context];
}

+ (NSNumber *) numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm;
{
    return [self MR_numberOfEntitiesWithPredicate:searchTerm];
}

+ (NSNumber *) numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
{
    return [self MR_numberOfEntitiesWithPredicate:searchTerm inContext:context];
}

+ (NSUInteger) countOfEntities;
{
    return [self MR_countOfEntities];
}

+ (NSUInteger) countOfEntitiesWithContext:(NSManagedObjectContext *)context;
{
    return [self MR_countOfEntitiesWithContext:context];
}

+ (NSUInteger) countOfEntitiesWithPredicate:(NSPredicate *)searchFilter;
{
    return [self MR_countOfEntitiesWithPredicate:searchFilter];
}

+ (NSUInteger) countOfEntitiesWithPredicate:(NSPredicate *)searchFilter inContext:(NSManagedObjectContext *)context;
{
    return [self MR_countOfEntitiesWithPredicate:searchFilter inContext:context];
}

+ (BOOL) hasAtLeastOneEntity;
{
    return [self MR_hasAtLeastOneEntity];
}

+ (BOOL) hasAtLeastOneEntityInContext:(NSManagedObjectContext *)context;
{
    return [self MR_hasAtLeastOneEntityInContext:context];
}

+ (NSNumber *)aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
{
    return [self MR_aggregateOperation:function onAttribute:attributeName withPredicate:predicate inContext:context];
}

+ (NSNumber *)aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate;
{
    return [self MR_aggregateOperation:function onAttribute:attributeName withPredicate:predicate];
}

- (id) objectWithMinValueFor:(NSString *)property;
{
    return [self MR_objectWithMinValueFor:property];
}

- (id) objectWithMinValueFor:(NSString *)property inContext:(NSManagedObjectContext *)context;
{
    return [self MR_objectWithMinValueFor:property inContext:context];
}

@end


@implementation NSManagedObject (MagicalFetchingShortHand)

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate;
{
    return [self MR_fetchAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm groupBy:groupingKeyPath delegate:delegate];
}

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context;
{
    return [self MR_fetchAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm groupBy:groupingKeyPath delegate:delegate inContext:context];
}

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
{
    return [self MR_fetchAllGroupedBy:group withPredicate:searchTerm sortedBy:sortTerm ascending:ascending];
}

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
{
    return [self MR_fetchAllGroupedBy:group withPredicate:searchTerm sortedBy:sortTerm ascending:ascending inContext:context];
}

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id<NSFetchedResultsControllerDelegate>)delegate;
{
    return [self MR_fetchAllGroupedBy:group withPredicate:searchTerm sortedBy:sortTerm ascending:ascending delegate:delegate];
}

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context;
{
    return [self MR_fetchAllGroupedBy:group withPredicate:searchTerm sortedBy:sortTerm ascending:ascending delegate:delegate inContext:context];
}

#endif /* TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR */

@end


@implementation NSManagedObject (MagicalRecordShortHand)

+ (NSArray *) executeFetchRequest:(NSFetchRequest *)request;
{
    return [self MR_executeFetchRequest:request];
}

+ (NSArray *) executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;
{
    return [self MR_executeFetchRequest:request inContext:context];
}

+ (id) executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request;
{
    return [self MR_executeFetchRequestAndReturnFirstObject:request];
}

+ (id) executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;
{
    return [self MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (NSEntityDescription *) entityDescription;
{
    return [self MR_entityDescription];
}

+ (NSEntityDescription *) entityDescriptionInContext:(NSManagedObjectContext *)context;
{
    return [self MR_entityDescriptionInContext:context];
}

+ (NSArray *) propertiesNamed:(NSArray *)properties;
{
    return [self MR_propertiesNamed:properties];
}

+ (instancetype) createEntity;
{
    return [self MR_createEntity];
}

+ (instancetype) createEntityInContext:(NSManagedObjectContext *)context;
{
    return [self MR_createEntityInContext:context];
}

+ (instancetype) createEntityWithDescription:(NSEntityDescription *)entityDescription inContext:(NSManagedObjectContext *)context;
{
    return [self MR_createEntityWithDescription:entityDescription inContext:context];
}

- (BOOL) isEntityDeleted;
{
    return [self MR_isEntityDeleted];
}

- (BOOL) deleteEntity;
{
    return [self MR_deleteEntity];
}

- (BOOL) deleteEntityInContext:(NSManagedObjectContext *)context;
{
    return [self MR_deleteEntityInContext:context];
}

+ (BOOL) deleteAllMatchingPredicate:(NSPredicate *)predicate;
{
    return [self MR_deleteAllMatchingPredicate:predicate];
}

+ (BOOL) deleteAllMatchingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
{
    return [self MR_deleteAllMatchingPredicate:predicate inContext:context];
}

+ (BOOL) truncateAll;
{
    return [self MR_truncateAll];
}

+ (BOOL) truncateAllInContext:(NSManagedObjectContext *)context;
{
    return [self MR_truncateAllInContext:context];
}

+ (NSArray *) ascendingSortDescriptors:(NSArray *)attributesToSortBy;
{
    return [self MR_ascendingSortDescriptors:attributesToSortBy];
}

+ (NSArray *) descendingSortDescriptors:(NSArray *)attributesToSortBy;
{
    return [self MR_descendingSortDescriptors:attributesToSortBy];
}

- (void) obtainPermanentObjectID;
{
    return [self MR_obtainPermanentObjectID];
}

- (void) refresh;
{
    return [self MR_refresh];
}

- (instancetype) inContext:(NSManagedObjectContext *)otherContext;
{
    return [self MR_inContext:otherContext];
}

- (instancetype) inContextIfTemporaryObject:(NSManagedObjectContext *)otherContext;
{
    return [self MR_inContextIfTemporaryObject:otherContext];
}

- (BOOL) isValidForInsert;
{
    return [self MR_isValidForInsert];
}

- (BOOL) isValidForUpdate;
{
    return [self MR_isValidForUpdate];
}

@end


@implementation NSManagedObject (MagicalRecordOptionalShortHand)

- (void) awakeFromCreation;
{
    return [self MR_awakeFromCreation];
}

@end


@implementation NSManagedObject (MagicalRecordDeprecatedShortHand)

+ (instancetype) createInContext:(NSManagedObjectContext *)context
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self MR_createInContext:context];
#pragma clang diagnostic pop
}

- (BOOL) deleteInContext:(NSManagedObjectContext *)context
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self MR_deleteInContext:context];
#pragma clang diagnostic pop
}

- (instancetype) inContextIfTempObject:(NSManagedObjectContext *)otherContext
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self MR_inContextIfTempObject:otherContext];
#pragma clang diagnostic pop
}

@end


@implementation NSManagedObject (MagicalRequestsShortHand)

+ (NSUInteger) defaultBatchSize;
{
    return [self MR_defaultBatchSize];
}

+ (void) setDefaultBatchSize:(NSUInteger)newBatchSize;
{
    return [self MR_setDefaultBatchSize:newBatchSize];
}

+ (NSFetchRequest *) requestAll;
{
    return [self MR_requestAll];
}

+ (NSFetchRequest *) requestAllWithPredicate:(NSPredicate *)searchTerm;
{
    return [self MR_requestAllWithPredicate:searchTerm];
}

+ (NSFetchRequest *) requestAllWhere:(NSString *)property isEqualTo:(id)value;
{
    return [self MR_requestAllWhere:property isEqualTo:value];
}

+ (NSFetchRequest *) requestFirstWithPredicate:(NSPredicate *)searchTerm;
{
    return [self MR_requestFirstWithPredicate:searchTerm];
}

+ (NSFetchRequest *) requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
{
    return [self MR_requestFirstByAttribute:attribute withValue:searchValue];
}

+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
{
    return [self MR_requestAllSortedBy:sortTerm ascending:ascending];
}

+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
{
    return [self MR_requestAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm];
}

@end


@implementation NSManagedObjectContext (MagicalObservingShortHand)

- (void) observeContext:(NSManagedObjectContext *)otherContext;
{
    return [self MR_observeContextDidSave:otherContext];
}

- (void) stopObservingContext:(NSManagedObjectContext *)otherContext;
{
    return [self MR_stopObservingContextDidSave:otherContext];
}

- (void) observeContextOnMainThread:(NSManagedObjectContext *)otherContext;
{
    return [self MR_observeContextOnMainThread:otherContext];
}

- (void) observeiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
    return [self MR_observeiCloudChangesInCoordinator:coordinator];
}

- (void) stopObservingiCloudChangesInCoordinator:(NSPersistentStoreCoordinator *)coordinator;
{
    return [self MR_stopObservingiCloudChangesInCoordinator:coordinator];
}

@end


@implementation NSManagedObjectContext (MagicalRecordShortHand)

- (void) obtainPermanentIDsForObjects:(NSArray *)objects;
{
    return [self MR_obtainPermanentIDsForObjects:objects];
}

+ (NSManagedObjectContext *) context
{
    return [self MR_context];
}

+ (NSManagedObjectContext *) mainQueueContext;
{
    return [self MR_mainQueueContext];
}

+ (NSManagedObjectContext *) privateQueueContext;
{
    return [self MR_privateQueueContext];
}

+ (NSManagedObjectContext *) confinementContext;
{
    return [self MR_confinementContext];
}

+ (NSManagedObjectContext *) confinementContextWithParent:(NSManagedObjectContext *)parentContext;
{
    return [self MR_confinementContextWithParent:parentContext];
}

+ (NSManagedObjectContext *) privateQueueContextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
    return [self MR_privateQueueContextWithStoreCoordinator:coordinator];
}

- (NSString *) parentChain;
{
    return [self MR_parentChain];
}

- (void) setWorkingName:(NSString *)workingName;
{
    return [self MR_setWorkingName:workingName];
}

- (NSString *) workingName;
{
    return [self MR_workingName];
}

@end


@implementation NSManagedObjectContext (MagicalSavesShortHand)

- (void) saveOnlySelfWithCompletion:(MRSaveCompletionHandler)completion;
{
    return [self MR_saveOnlySelfWithCompletion:completion];
}

- (void) saveToPersistentStoreWithCompletion:(MRSaveCompletionHandler)completion;
{
    return [self MR_saveToPersistentStoreWithCompletion:completion];
}

- (BOOL) saveOnlySelfAndWait;
{
    return [self MR_saveOnlySelfAndWait];
}

- (BOOL) saveOnlySelfAndWaitWithError:(NSError **)error;
{
    return [self MR_saveOnlySelfAndWaitWithError:error];
}

- (BOOL) saveToPersistentStoreAndWait;
{
    return [self MR_saveToPersistentStoreAndWait];
}

- (BOOL) saveToPersistentStoreAndWaitWithError:(NSError **)error;
{
    return [self MR_saveToPersistentStoreAndWaitWithError:error];
}

@end


@implementation NSManagedObjectModel (MagicalRecordShortHand)

+ (NSManagedObjectModel *) managedObjectModelAtURL:(NSURL *)url;
{
    return [self MR_managedObjectModelAtURL:url];
}

+ (NSManagedObjectModel *) mergedObjectModelFromMainBundle;
{
    return [self MR_mergedObjectModelFromMainBundle];
}

+ (NSManagedObjectModel *) managedObjectModelNamed:(NSString *)modelFileName;
{
    return [self MR_managedObjectModelNamed:modelFileName];
}

+ (NSManagedObjectModel *) newModelNamed:(NSString *) modelName inBundleNamed:(NSString *) bundleName
{
    return [self MR_newModelNamed: modelName inBundleNamed: bundleName];
}

@end


@implementation NSPersistentStoreCoordinator (MagicalAutoMigrationsShortHand)

- (NSPersistentStore *) addAutoMigratingSqliteStoreNamed:(NSString *)storeFileName;
{
    return [self MR_addAutoMigratingSqliteStoreNamed:storeFileName];
}

- (NSPersistentStore *) addAutoMigratingSqliteStoreNamed:(NSString *)storeFileName withOptions:(NSDictionary *)options;
{
    return [self MR_addAutoMigratingSqliteStoreNamed:storeFileName withOptions:options];
}

- (NSPersistentStore *) addAutoMigratingSqliteStoreAtURL:(NSURL *)url;
{
    return [self MR_addAutoMigratingSqliteStoreAtURL:url];
}

- (NSPersistentStore *) addAutoMigratingSqliteStoreAtURL:(NSURL *)url withOptions:(NSDictionary *)options;
{
    return [self MR_addAutoMigratingSqliteStoreAtURL:url withOptions:options];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithAutoMigratingSqliteStoreNamed:(NSString *)storeFileName;
{
    return [self MR_coordinatorWithAutoMigratingSqliteStoreNamed:storeFileName];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithAutoMigratingSqliteStoreAtURL:(NSURL *)url;
{
    return [self MR_coordinatorWithAutoMigratingSqliteStoreAtURL:url];
}

@end


@implementation NSPersistentStoreCoordinator (MagicalInMemoryStoreAdditionsShortHand)

+ (NSPersistentStoreCoordinator *) coordinatorWithInMemoryStore;
{
    return [self MR_coordinatorWithInMemoryStore];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithInMemoryStoreWithModel:(NSManagedObjectModel *)model;
{
    return [self MR_coordinatorWithInMemoryStoreWithModel:model];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithInMemoryStoreWithModel:(NSManagedObjectModel *)model withOptions:(NSDictionary *)options;
{
    return [self MR_coordinatorWithInMemoryStoreWithModel:model withOptions:options];
}

- (NSPersistentStore *) addInMemoryStore;
{
    return [self MR_addInMemoryStore];
}

- (NSPersistentStore *) addInMemoryStoreWithOptions:(NSDictionary *)options;
{
    return [self MR_addInMemoryStoreWithOptions:options];
}

@end


@implementation NSPersistentStoreCoordinator (MagicalManualMigrationsShortHand)

- (NSPersistentStore *) addManuallyMigratingSqliteStoreAtURL:(NSURL *)url;
{
    return [self MR_addManuallyMigratingSqliteStoreAtURL:url];
}

- (NSPersistentStore *) addManuallyMigratingSqliteStoreNamed:(NSString *)storeFileName;
{
    return [self MR_addManuallyMigratingSqliteStoreNamed:storeFileName];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithManuallyMigratingSqliteStoreNamed:(NSString *)storeFileName;
{
    return [self MR_coordinatorWithManuallyMigratingSqliteStoreNamed:storeFileName];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithManuallyMigratingSqliteStoreAtURL:(NSURL *)url;
{
    return [self MR_coordinatorWithManuallyMigratingSqliteStoreAtURL:url];
}

@end


@implementation NSPersistentStoreCoordinator (MagicalRecordShortHand)

+ (NSPersistentStoreCoordinator *) newPersistentStoreCoordinator
{
    return [self MR_newPersistentStoreCoordinator];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithPersistentStore:(NSPersistentStore *)persistentStore;
{
    return [self MR_coordinatorWithPersistentStore:persistentStore];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithPersistentStore:(NSPersistentStore *)persistentStore andModel:(NSManagedObjectModel *)model;
{
    return [self MR_coordinatorWithPersistentStore:persistentStore andModel:model];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithPersistentStore:(NSPersistentStore *)persistentStore andModel:(NSManagedObjectModel *)model withOptions:(NSDictionary *)options;
{
    return [self MR_coordinatorWithPersistentStore:persistentStore andModel:model withOptions:options];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreNamed:(NSString *)storeFileName;
{
    return [self MR_coordinatorWithSqliteStoreNamed:storeFileName];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreNamed:(NSString *)storeFileName withOptions:(NSDictionary *)options;
{
    return [self MR_coordinatorWithSqliteStoreNamed:storeFileName withOptions:options];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreNamed:(NSString *)storeFileName andModel:(NSManagedObjectModel *)model withOptions:(NSDictionary *)options;
{
    return [self MR_coordinatorWithSqliteStoreNamed:storeFileName andModel:model withOptions:options];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreAtURL:(NSURL *)url;
{
    return [self MR_coordinatorWithSqliteStoreAtURL:url];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreAtURL:(NSURL *)url andModel:(NSManagedObjectModel *)model;
{
    return [self MR_coordinatorWithSqliteStoreAtURL:url andModel:model];
}

+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreAtURL:(NSURL *)url andModel:(NSManagedObjectModel *)model withOptions:(NSDictionary *)options;
{
    return [self MR_coordinatorWithSqliteStoreAtURL:url andModel:model withOptions:options];
}

- (NSPersistentStore *) addSqliteStoreAtURL:(NSURL *)url withOptions:(NSDictionary *__autoreleasing)options;
{
    return [self MR_addSqliteStoreAtURL:url withOptions:options];
}

- (NSPersistentStore *) addSqliteStoreNamed:(id)storeFileName withOptions:(__autoreleasing NSDictionary *)options;
{
    return [self MR_addSqliteStoreNamed:storeFileName withOptions:options];
}

@end

#endif
