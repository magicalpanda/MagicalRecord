
//  Created by Saul Mora on 11/15/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "CoreData+MagicalRecord.h"

static NSUInteger defaultBatchSize = kMagicalRecordDefaultBatchSize;


@implementation NSManagedObject (MagicalRecord)

+ (void) MR_setDefaultBatchSize:(NSUInteger)newBatchSize
{
	@synchronized(self)
	{
		defaultBatchSize = newBatchSize;
	}
}

+ (NSUInteger) MR_defaultBatchSize
{
	return defaultBatchSize;
}

+ (NSArray *) MR_executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
	NSError *error = nil;
	
	NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (results == nil) 
    {
        [MagicalRecordHelpers handleErrors:error];
    }
	return results;	
}

+ (NSArray *) MR_executeFetchRequest:(NSFetchRequest *)request
{
	return [self MR_executeFetchRequest:request inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (id) MR_executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
	[request setFetchLimit:1];
	
	NSArray *results = [self MR_executeFetchRequest:request inContext:context];
	if ([results count] == 0)
	{
		return nil;
	}
	return [results objectAtIndex:0];
}

+ (id) MR_executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request
{
	return [self MR_executeFetchRequestAndReturnFirstObject:request inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

#if TARGET_OS_IPHONE

+ (void) MR_performFetch:(NSFetchedResultsController *)controller
{
	NSError *error = nil;
	if (![controller performFetch:&error])
	{
		[MagicalRecordHelpers handleErrors:error];
	}
}

#endif

+ (NSString *) MR_entityName
{
    return NSStringFromClass(self);
}

+ (NSEntityDescription *) MR_entityDescriptionInContext:(NSManagedObjectContext *)context
{
    if ([self respondsToSelector:@selector(entityInManagedObjectContext:)]) 
    {
        NSEntityDescription *entity = [self performSelector:@selector(entityInManagedObjectContext:) withObject:context];
        return entity;
    }
    else
    {
        NSString *entityName = [self MR_entityName];
        return [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    }
}

+ (NSEntityDescription *) MR_entityDescription
{
	return [self MR_entityDescriptionInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (NSArray *) MR_propertiesNamed:(NSArray *)properties
{
	NSEntityDescription *description = [self MR_entityDescription];
	NSMutableArray *propertiesWanted = [NSMutableArray array];
	
	if (properties)
	{
		NSDictionary *propDict = [description propertiesByName];
		
		for (NSString *propertyName in properties)
		{
			NSPropertyDescription *property = [propDict objectForKey:propertyName];
			if (property)
			{
				[propertiesWanted addObject:property];
			}
			else
			{
				MRLog(@"Property '%@' not found in %d properties for %@", propertyName, [propDict count], NSStringFromClass(self));
			}
		}
	}
	return propertiesWanted;
}

+ (NSArray *) MR_sortAscending:(BOOL)ascending attributes:(NSArray *)attributesToSortBy
{
	NSMutableArray *attributes = [NSMutableArray array];
    
    for (NSString *attributeName in attributesToSortBy) 
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attributeName ascending:ascending];
        [attributes addObject:sortDescriptor];
        MR_RELEASE(sortDescriptor);
    }
    
	return attributes;
}

+ (NSArray *) MR_ascendingSortDescriptors:(NSArray *)attributesToSortBy
{
	return [self MR_sortAscending:YES attributes:attributesToSortBy];
}

+ (NSArray *) MR_descendingSortDescriptors:(NSArray *)attributesToSortBy
{
	return [self MR_sortAscending:NO attributes:attributesToSortBy];
}

+ (NSFetchRequest *)MR_createFetchRequestInContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[self MR_entityDescriptionInContext:context]];
    MR_AUTORELEASE(request);

    return request;
}

+ (NSFetchRequest *) MR_createFetchRequest
{
	return [self MR_createFetchRequestInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

#pragma mark -
#pragma mark Number of Entities

+ (NSNumber *) MR_numberOfEntitiesWithContext:(NSManagedObjectContext *)context
{
	return [NSNumber numberWithUnsignedInteger:[self MR_countOfEntitiesWithContext:context]];
}

+ (NSNumber *) MR_numberOfEntities
{
	return [self MR_numberOfEntitiesWithContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (NSNumber *) MR_numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    
	return [NSNumber numberWithUnsignedInteger:[self MR_countOfEntitiesWithPredicate:searchTerm inContext:context]];
}

+ (NSNumber *) MR_numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm;
{
	return [self MR_numberOfEntitiesWithPredicate:searchTerm
									 inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (NSUInteger) MR_countOfEntities;
{
    return [self MR_countOfEntitiesWithContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (NSUInteger) MR_countOfEntitiesWithContext:(NSManagedObjectContext *)context;
{
	NSError *error = nil;
	NSUInteger count = [context countForFetchRequest:[self MR_createFetchRequestInContext:context] error:&error];
	[MagicalRecordHelpers handleErrors:error];
	
    return count;
}

+ (NSUInteger) MR_countOfEntitiesWithPredicate:(NSPredicate *)searchFilter;
{
    return [self MR_countOfEntitiesWithPredicate:searchFilter inContext:[NSManagedObjectContext MR_defaultContext]];
}

+ (NSUInteger) MR_countOfEntitiesWithPredicate:(NSPredicate *)searchFilter inContext:(NSManagedObjectContext *)context;
{
	NSError *error = nil;
	NSFetchRequest *request = [self MR_createFetchRequestInContext:context];
	[request setPredicate:searchFilter];
	
	NSUInteger count = [context countForFetchRequest:request error:&error];
	[MagicalRecordHelpers handleErrors:error];
 
    return count;
}

+ (BOOL) MR_hasAtLeastOneEntity
{
    return [self MR_hasAtLeastOneEntityInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (BOOL) MR_hasAtLeastOneEntityInContext:(NSManagedObjectContext *)context
{
    return [[self MR_numberOfEntitiesWithContext:context] intValue] > 0;
}

#pragma mark - Reqest Helpers

+ (NSFetchRequest *) MR_requestAll
{
	return [self MR_createFetchRequestInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (NSFetchRequest *) MR_requestAllInContext:(NSManagedObjectContext *)context
{
	return [self MR_createFetchRequestInContext:context];
}

+ (NSFetchRequest *) MR_requestAllWithPredicate:(NSPredicate *)searchTerm;
{
    return [self MR_requestAllWithPredicate:searchTerm inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (NSFetchRequest *) MR_requestAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [self MR_createFetchRequestInContext:context];
    [request setPredicate:searchTerm];
    
    return request;
}

+ (NSFetchRequest *) MR_requestAllWhere:(NSString *)property isEqualTo:(id)value
{
    return [self MR_requestAllWhere:property isEqualTo:value inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (NSFetchRequest *) MR_requestAllWhere:(NSString *)property isEqualTo:(id)value inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self MR_createFetchRequestInContext:context];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", property, value]];

    return request;
}

+ (NSFetchRequest *) MR_requestFirstWithPredicate:(NSPredicate *)searchTerm
{
    return [self MR_requestFirstWithPredicate:searchTerm inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (NSFetchRequest *) MR_requestFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self MR_createFetchRequestInContext:context];
    [request setPredicate:searchTerm];
    [request setFetchLimit:1];
    
    return request;
}

+ (NSFetchRequest *) MR_requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
{
    return [self MR_requestFirstByAttribute:attribute withValue:searchValue inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (NSFetchRequest *) MR_requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [self MR_requestAllWhere:attribute isEqualTo:searchValue inContext:context]; 
    [request setFetchLimit:1];
    
    return request;
}

+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self MR_requestAllInContext:context];
	
	NSSortDescriptor *sortBy = [[NSSortDescriptor alloc] initWithKey:sortTerm ascending:ascending];
	[request setSortDescriptors:[NSArray arrayWithObject:sortBy]];
    MR_AUTORELEASE(sortBy);
	
	return request;
}

+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending
{
	return [self MR_requestAllSortedBy:sortTerm
						  ascending:ascending
						  inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self MR_requestAllInContext:context];
	[request setPredicate:searchTerm];
	[request setFetchBatchSize:[self MR_defaultBatchSize]];
	
    NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
    NSArray* sortKeys = [sortTerm componentsSeparatedByString:@","];
    for (NSString* sortKey in sortKeys) 
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
        [sortDescriptors addObject:sortDescriptor];
        MR_AUTORELEASE(sortDescriptor);
    }
    
	[request setSortDescriptors:sortDescriptors];
    MR_AUTORELEASE(sortDescriptors);
    
	return request;
}

+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
{
	NSFetchRequest *request = [self MR_requestAllSortedBy:sortTerm
											 ascending:ascending
										 withPredicate:searchTerm 
											 inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
	return request;
}


#pragma mark - Finding Data


+ (NSArray *) MR_findAllInContext:(NSManagedObjectContext *)context
{
	return [self MR_executeFetchRequest:[self MR_requestAllInContext:context] inContext:context];
}

+ (NSArray *) MR_findAll
{
	return [self MR_findAllInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self MR_requestAllSortedBy:sortTerm ascending:ascending inContext:context];
	
	return [self MR_executeFetchRequest:request inContext:context];
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending
{
	return [self MR_findAllSortedBy:sortTerm
					   ascending:ascending 
					   inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self MR_requestAllSortedBy:sortTerm
											 ascending:ascending
										 withPredicate:searchTerm
											 inContext:context];
	
	return [self MR_executeFetchRequest:request inContext:context];
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm
{
	return [self MR_findAllSortedBy:sortTerm
					   ascending:ascending
				   withPredicate:searchTerm 
					   inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

#pragma mark -
#pragma mark NSFetchedResultsController helpers

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *) MR_fetchController:(NSFetchRequest *)request delegate:(id<NSFetchedResultsControllerDelegate>)delegate useFileCache:(BOOL)useFileCache groupedBy:(NSString *)groupKeyPath inContext:(NSManagedObjectContext *)context
{
    NSString *cacheName = useFileCache ? [NSString stringWithFormat:@"MagicalRecord-Cache-%@", NSStringFromClass([self class])] : nil;
    
	NSFetchedResultsController *controller =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                        managedObjectContext:context
                                          sectionNameKeyPath:groupKeyPath
                                                   cacheName:cacheName];
    controller.delegate = delegate;
    MR_AUTORELEASE(controller);
    
    return controller;
}

+ (NSFetchedResultsController *) MR_fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self MR_requestAllSortedBy:sortTerm 
                                                ascending:ascending 
                                            withPredicate:searchTerm
                                                inContext:context];

    NSFetchedResultsController *controller = [self MR_fetchController:request 
                                                             delegate:delegate
                                                         useFileCache:NO
                                                            groupedBy:group
                                                            inContext:context];
    
    [self MR_performFetch:controller];
    return controller;
}

+ (NSFetchedResultsController *) MR_fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id)delegate
{
	return [self MR_fetchAllGroupedBy:group
                        withPredicate:searchTerm
                             sortedBy:sortTerm
                            ascending:ascending
                                 delegate:delegate
                            inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (NSFetchedResultsController *) MR_fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
{
    return [self MR_fetchAllGroupedBy:group 
                        withPredicate:searchTerm
                             sortedBy:sortTerm
                            ascending:ascending
                             delegate:nil
                            inContext:context];
}

+ (NSFetchedResultsController *) MR_fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending 
{
    return [self MR_fetchAllGroupedBy:group 
                        withPredicate:searchTerm
                             sortedBy:sortTerm
                            ascending:ascending
                            inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}


+ (NSFetchedResultsController *) MR_fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self MR_requestAllSortedBy:sortTerm
                                                ascending:ascending
                                            withPredicate:searchTerm
                                                inContext:context];

	NSFetchedResultsController *controller = [self MR_fetchController:request 
                                                               delegate:nil
                                                           useFileCache:NO
                                                              groupedBy:groupingKeyPath
                                                              inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    
    [self MR_performFetch:controller];
    return controller;
}

+ (NSFetchedResultsController *) MR_fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath;
{
    return [self MR_fetchAllSortedBy:sortTerm
                        ascending:ascending
                    withPredicate:searchTerm
                          groupBy:groupingKeyPath
                        inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (NSFetchedResultsController *) MR_fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context
{
	NSFetchedResultsController *controller = [self MR_fetchAllGroupedBy:groupingKeyPath 
															  withPredicate:searchTerm
																   sortedBy:sortTerm 
																  ascending:ascending
                                                                   delegate:delegate
																  inContext:context];
	
	[self MR_performFetch:controller];
	return controller;
}

+ (NSFetchedResultsController *) MR_fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate
{
	return [self MR_fetchAllSortedBy:sortTerm 
						ascending:ascending
					withPredicate:searchTerm 
						  groupBy:groupingKeyPath 
                         delegate:delegate
						inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

#endif

#pragma mark -

+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self MR_createFetchRequestInContext:context];
	[request setPredicate:searchTerm];
	
	return [self MR_executeFetchRequest:request
						   inContext:context];
}

+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchTerm
{
	return [self MR_findAllWithPredicate:searchTerm
							inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (id) MR_findFirstInContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self MR_createFetchRequestInContext:context];
	
	return [self MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id) MR_findFirst
{
	return [self MR_findFirstInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (id) MR_findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context
{	
	NSFetchRequest *request = [self MR_requestFirstByAttribute:attribute withValue:searchValue inContext:context];
    //    [request setPropertiesToFetch:[NSArray arrayWithObject:attribute]];
    
	return [self MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id) MR_findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue
{
	return [self MR_findFirstByAttribute:attribute
							withValue:searchValue 
							inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (id) MR_findFirstWithPredicate:(NSPredicate *)searchTerm
{
    return [self MR_findFirstWithPredicate:searchTerm inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (id) MR_findFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self MR_requestFirstWithPredicate:searchTerm inContext:context];
    
    return [self MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id) MR_findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self MR_requestAllSortedBy:property ascending:ascending withPredicate:searchterm inContext:context];

	return [self MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id) MR_findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending
{
	return [self MR_findFirstWithPredicate:searchterm
							   sortedBy:property 
							  ascending:ascending 
							  inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (id) MR_findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self MR_createFetchRequestInContext:context];
	[request setPredicate:searchTerm];
	[request setPropertiesToFetch:attributes];
	
	return [self MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id) MR_findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes
{
	return [self MR_findFirstWithPredicate:searchTerm
				  andRetrieveAttributes:attributes 
							  inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}


+ (id) MR_findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context andRetrieveAttributes:(id)attributes, ...
{
	NSFetchRequest *request = [self MR_requestAllSortedBy:sortBy
											 ascending:ascending
										 withPredicate:searchTerm
											 inContext:context];
	[request setPropertiesToFetch:[self MR_propertiesNamed:attributes]];
	
	return [self MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id) MR_findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending andRetrieveAttributes:(id)attributes, ...
{
	return [self MR_findFirstWithPredicate:searchTerm
							   sortedBy:sortBy 
							  ascending:ascending 
								inContext:[NSManagedObjectContext MR_contextForCurrentThread]
				  andRetrieveAttributes:attributes];
}

+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self MR_requestAllWhere:attribute isEqualTo:searchValue inContext:context];
	
	return [self MR_executeFetchRequest:request inContext:context];
}

+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue
{
	return [self MR_findByAttribute:attribute
					   withValue:searchValue 
					   inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
	NSPredicate *searchTerm = [NSPredicate predicateWithFormat:@"%K = %@", attribute, searchValue];
	NSFetchRequest *request = [self MR_requestAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm inContext:context];
	
	return [self MR_executeFetchRequest:request];
}

+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending
{
	return [self MR_findByAttribute:attribute
					   withValue:searchValue
					  andOrderBy:sortTerm 
					   ascending:ascending 
					   inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (id) MR_createInContext:(NSManagedObjectContext *)context
{
    if ([self respondsToSelector:@selector(insertInManagedObjectContext:)]) 
    {
        id entity = [self performSelector:@selector(insertInManagedObjectContext:) withObject:context];
        return entity;
    }
    else
    {
        return [NSEntityDescription insertNewObjectForEntityForName:[self MR_entityName] inManagedObjectContext:context];
    }
}

+ (id) MR_createEntity
{	
	NSManagedObject *newEntity = [self MR_createInContext:[NSManagedObjectContext MR_contextForCurrentThread]];

	return newEntity;
}

- (BOOL) MR_deleteInContext:(NSManagedObjectContext *)context
{
	[context deleteObject:self];
	return YES;
}

- (BOOL) MR_deleteEntity
{
	[self MR_deleteInContext:[self managedObjectContext]];
	return YES;
}

+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self MR_requestAllWithPredicate:predicate inContext:context];
    [request setReturnsObjectsAsFaults:YES];
	[request setIncludesPropertyValues:NO];
    
	NSArray *objectsToTruncate = [self MR_executeFetchRequest:request inContext:context];
    
	for (id objectToTruncate in objectsToTruncate) 
    {
		[objectToTruncate MR_deleteInContext:context];
	}
    
	return YES;
}

+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate
{
    return [self MR_deleteAllMatchingPredicate:predicate inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (BOOL) MR_truncateAllInContext:(NSManagedObjectContext *)context
{
    NSArray *allEntities = [self MR_findAllInContext:context];
    for (NSManagedObject *obj in allEntities)
    {
        [obj MR_deleteInContext:context];
    }
    return YES;
}

+ (BOOL) MR_truncateAll
{
    [self MR_truncateAllInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    return YES;
}

- (NSNumber *) MR_maxValueFor:(NSString *)property
{
	NSManagedObject *obj = [[self class] MR_findFirstByAttribute:property
													withValue:[NSString stringWithFormat:@"max(%@)", property]];
	
	return [obj valueForKey:property];
}

- (id) MR_objectWithMinValueFor:(NSString *)property inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [[self class] MR_createFetchRequestInContext:context];
							   
	NSPredicate *searchFor = [NSPredicate predicateWithFormat:@"SELF = %@ AND %K = min(%@)", self, property, property];
	[request setPredicate:searchFor];
	
	return [[self class] MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
}

- (id) MR_objectWithMinValueFor:(NSString *)property
{
	return [self MR_objectWithMinValueFor:property inContext:[self  managedObjectContext]];
}

+ (NSNumber *) MR_aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context 
{
    NSExpression *ex = [NSExpression expressionForFunction:function 
                                                 arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:attributeName]]];
    
    NSExpressionDescription *ed = [[NSExpressionDescription alloc] init];
    [ed setName:@"result"];
    [ed setExpression:ex];
    
    // determine the type of attribute, required to set the expression return type    
    NSAttributeDescription *attributeDescription = [[[self MR_entityDescription] attributesByName] objectForKey:attributeName];
    [ed setExpressionResultType:[attributeDescription attributeType]];    
    NSArray *properties = [NSArray arrayWithObject:ed];
    MR_RELEASE(ed);
    
    NSFetchRequest *request = [self MR_requestAllWithPredicate:predicate inContext:context];
    [request setPropertiesToFetch:properties];
    [request setResultType:NSDictionaryResultType];    
    
    NSDictionary *resultsDictionary = [self MR_executeFetchRequestAndReturnFirstObject:request];
    NSNumber *resultValue = [resultsDictionary objectForKey:@"result"];
    
    return resultValue;    
}

+ (NSNumber *) MR_aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate 
{
    return [self MR_aggregateOperation:function 
                        onAttribute:attributeName 
                      withPredicate:predicate
                          inContext:[NSManagedObjectContext MR_defaultContext]];    
}

- (id) MR_inContext:(NSManagedObjectContext *)otherContext
{
    NSError *error = nil;
    NSManagedObject *inContext = [otherContext existingObjectWithID:[self objectID] error:&error];
    [MagicalRecordHelpers handleErrors:error];
    
    return inContext;
}

- (id) MR_inThreadContext
{
    NSManagedObject *weakSelf = self;
    return [weakSelf MR_inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

@end