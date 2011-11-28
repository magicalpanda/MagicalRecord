#ifdef MR_SHORTHAND






@interface NSManagedObject (NSManagedObject_DataImportShortHand)
- (void) importValuesForKeysWithDictionary:(id)objectData;
- (void) updateValuesForKeysWithDictionary:(id)objectData;
+ (id) importFromDictionary:(NSDictionary *)data;
+ (id) importFromDictionary:(NSDictionary *)data inContext:(NSManagedObjectContext *)context;
+ (NSArray *) importFromArray:(NSArray *)listOfObjectData;
+ (NSArray *) importFromArray:(NSArray *)listOfObjectData inContext:(NSManagedObjectContext *)context;
+ (id) updateFromDictionary:(NSDictionary *)objectData;
+ (id) updateFromDictionary:(NSDictionary *)objectData inContext:(NSManagedObjectContext *)context;
@end
@interface NSManagedObject (MagicalRecordShortHand)
+ (NSUInteger) defaultBatchSize;
+ (void) setDefaultBatchSize:(NSUInteger)newBatchSize;
+ (NSArray *) executeFetchRequest:(NSFetchRequest *)request;
+ (NSArray *) executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;
+ (id) executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request;
+ (id) executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) createFetchRequest;
+ (NSFetchRequest *) createFetchRequestInContext:(NSManagedObjectContext *)context;
+ (NSEntityDescription *) entityDescription;
+ (NSEntityDescription *) entityDescriptionInContext:(NSManagedObjectContext *)context;
+ (NSArray *) propertiesNamed:(NSArray *)properties;
+ (id) createEntity;
+ (id) createInContext:(NSManagedObjectContext *)context;
- (BOOL) deleteEntity;
- (BOOL) deleteInContext:(NSManagedObjectContext *)context;
+ (BOOL) deleteAllMatchingPredicate:(NSPredicate *)predicate;
+ (BOOL) deleteAllMatchingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (BOOL) truncateAll;
+ (BOOL) truncateAllInContext:(NSManagedObjectContext *)context;
+ (NSArray *) ascendingSortDescriptors:(NSArray *)attributesToSortBy;
+ (NSArray *) descendingSortDescriptors:(NSArray *)attributesToSortBy;
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
+ (NSArray *) findAll;
+ (NSArray *) findAllInContext:(NSManagedObjectContext *)context;
+ (NSArray *) findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSArray *) findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSArray *) findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
+ (NSArray *) findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (NSArray *) findAllWithPredicate:(NSPredicate *)searchTerm;
+ (NSArray *) findAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
- (id) objectWithMinValueFor:(NSString *)property;
- (id) objectWithMinValueFor:(NSString *)property inContext:(NSManagedObjectContext *)context;
+ (id) findFirst;
+ (id) findFirstInContext:(NSManagedObjectContext *)context;
+ (id) findFirstWithPredicate:(NSPredicate *)searchTerm;
+ (id) findFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (id) findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending;
+ (id) findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (id) findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes;
+ (id) findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes inContext:(NSManagedObjectContext *)context;
+ (id) findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending andRetrieveAttributes:(id)attributes, ...;
+ (id) findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context andRetrieveAttributes:(id)attributes, ...;
+ (id) findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (id) findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
+ (NSArray *) findByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (NSArray *) findByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
+ (NSArray *) findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSArray *) findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
- (id) inContext:(NSManagedObjectContext *)otherContext;
- (id) inThreadContext;
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
+ (void) performFetch:(NSFetchedResultsController *)controller;
+ (NSFetchedResultsController *) fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate;
+ (NSFetchedResultsController *) fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context;
+ (NSFetchedResultsController *) fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSFetchedResultsController *) fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSFetchedResultsController *) fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id<NSFetchedResultsControllerDelegate>)delegate;
+ (NSFetchedResultsController *) fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context;
#endif
@end
@interface NSManagedObjectContext (MagicalRecordShortHand)
- (void) observeContext:(NSManagedObjectContext *)otherContext;
- (void) stopObservingContext:(NSManagedObjectContext *)otherContext;
- (void) observeContextOnMainThread:(NSManagedObjectContext *)otherContext;
- (BOOL) save;
- (BOOL) saveWithErrorHandler:(void (^)(NSError *))errorCallback;
- (BOOL) saveOnMainThread;
- (BOOL) saveOnBackgroundThread;
+ (void) resetDefaultContext;
+ (NSManagedObjectContext *)defaultContext;
+ (void) setDefaultContext:(NSManagedObjectContext *)moc;
+ (void) resetContextForCurrentThread;
+ (NSManagedObjectContext *) context;
+ (NSManagedObjectContext *) contextForCurrentThread;
+ (NSManagedObjectContext *) contextThatNotifiesDefaultContextOnMainThread;
+ (NSManagedObjectContext *) contextThatNotifiesDefaultContextOnMainThreadWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;
+ (NSManagedObjectContext *) contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;
@end
@interface NSManagedObjectModel (MagicalRecordShortHand)
+ (NSManagedObjectModel *) defaultManagedObjectModel;
+ (void) setDefaultManagedObjectModel:(NSManagedObjectModel *)newDefaultModel;
+ (NSManagedObjectModel *) newManagedObjectModel NS_RETURNS_RETAINED;
+ (NSManagedObjectModel *) newManagedObjectModelNamed:(NSString *)modelFileName NS_RETURNS_RETAINED;
+ (NSManagedObjectModel *) managedObjectModelNamed:(NSString *)modelFileName;
+ (NSManagedObjectModel *) newModelNamed:(NSString *) modelName inBundleNamed:(NSString *) bundleName NS_RETURNS_RETAINED;
+ (NSManagedObjectModel *) mergedObjectModelFromMainBundle;
@end
@interface NSPersistentStore (MagicalRecordShortHand)
+ (NSURL *) defaultLocalStoreUrl;
+ (NSPersistentStore *) defaultPersistentStore;
+ (void) setDefaultPersistentStore:(NSPersistentStore *) store;
+ (NSURL *) urlForStoreName:(NSString *)storeFileName;
@end
@interface NSPersistentStoreCoordinator (MagicalRecordShortHand)
+ (NSPersistentStoreCoordinator *) defaultStoreCoordinator;
+ (void) setDefaultStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;
+ (NSPersistentStoreCoordinator *) coordinatorWithInMemoryStore;
+ (NSPersistentStoreCoordinator *) newPersistentStoreCoordinator NS_RETURNS_RETAINED;
+ (NSPersistentStoreCoordinator *) coordinatorWithSqliteStoreNamed:(NSString *)storeFileName;
+ (NSPersistentStoreCoordinator *) coordinatorWithAutoMigratingSqliteStoreNamed:(NSString *) storeFileName;
+ (NSPersistentStoreCoordinator *) coordinatorWithPersitentStore:(NSPersistentStore *)persistentStore;
- (NSPersistentStore *) addInMemoryStore;
@end
#endif

