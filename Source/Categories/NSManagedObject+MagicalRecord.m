
//  Created by Saul Mora on 11/15/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

//#import "NSManagedObject+MagicalRecord.h"
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
	[MagicalRecordHelpers handleErrors:error];
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

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED

+ (void) MR_performFetch:(NSFetchedResultsController *)controller
{
	NSError *error = nil;
	if (![controller performFetch:&error])
	{
		[MagicalRecordHelpers handleErrors:error];
	}
}

#endif

+ (NSEntityDescription *) MR_entityDescriptionInContext:(NSManagedObjectContext *)context
{
    if ([self respondsToSelector:@selector(entityInManagedObjectContext:)]) 
    {
        NSEntityDescription *entity = [self performSelector:@selector(entityInManagedObjectContext:) withObject:context];
        return entity;
    }
    else
    {
        NSString *entityName = NSStringFromClass([self class]);
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
				ARLog(@"Property '%@' not found in %@ properties for %@", propertyName, [propDict count], NSStringFromClass(self));
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
        NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:attributeName ascending:ascending] autorelease];
        [attributes addObject:sortDescriptor];
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

+ (NSFetchRequest *) MR_createFetchRequestInContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[self MR_entityDescriptionInContext:context]];
	
	return [request autorelease];	
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

#pragma mark -
#pragma mark Reqest Helpers
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
    NSFetchRequest *request = [self MR_createFetchRequestInContext:context];
    [request setFetchLimit:1];
    [request setPropertiesToFetch:[NSArray arrayWithObject:attribute]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", attribute, searchValue]];
    
    return request;
}

+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self MR_requestAllInContext:context];
	
	NSSortDescriptor *sortBy = [[[NSSortDescriptor alloc] initWithKey:sortTerm ascending:ascending] autorelease];
	[request setSortDescriptors:[NSArray arrayWithObject:sortBy]];
	
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
	[request setIncludesSubentities:NO];
	[request setFetchBatchSize:[self MR_defaultBatchSize]];
	
	NSSortDescriptor *sortBy = [[[NSSortDescriptor alloc] initWithKey:sortTerm ascending:ascending] autorelease];
	[request setSortDescriptors:[NSArray arrayWithObject:sortBy]];
	
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

#pragma mark Finding Data
#pragma mark -

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

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED

+ (NSFetchedResultsController *) MR_fetchRequestAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
	NSString *cacheName = nil;
	#ifdef STORE_USE_CACHE
	cacheName = [NSString stringWithFormat:@"MagicalRecord-Cache-%@", NSStringFromClass(self)];
	#endif
	
	NSFetchRequest *request = [self MR_requestAllSortedBy:sortTerm 
											 ascending:ascending 
										 withPredicate:searchTerm
											 inContext:context];
	
	NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
																				 managedObjectContext:context
																				   sectionNameKeyPath:group
																							cacheName:cacheName];
	return [controller autorelease];
}

+ (NSFetchedResultsController *) MR_fetchRequestAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending 
{
	return [self MR_fetchRequestAllGroupedBy:group
							   withPredicate:searchTerm
									sortedBy:sortTerm
								   ascending:ascending
								   inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (NSFetchedResultsController *) MR_fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath inContext:(NSManagedObjectContext *)context
{
	NSFetchedResultsController *controller = [self MR_fetchRequestAllGroupedBy:groupingKeyPath
																 withPredicate:searchTerm
																	  sortedBy:sortTerm
																	 ascending:ascending
																	 inContext:context];
	
	[self MR_performFetch:controller];
	return controller;
}

+ (NSFetchedResultsController *) MR_fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath
{
	return [self MR_fetchAllSortedBy:sortTerm
						   ascending:ascending
					   withPredicate:searchTerm
							 groupBy:groupingKeyPath
						   inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (NSFetchedResultsController *) MR_fetchRequest:(NSFetchRequest *)request groupedBy:(NSString *)group inContext:(NSManagedObjectContext *)context
{
	NSString *cacheName = nil;
	#ifdef STORE_USE_CACHE
	cacheName = [NSString stringWithFormat:@"MagicalRecord-Cache-%@", NSStringFromClass([self class])];
	#endif
	NSFetchedResultsController *controller =
		[[NSFetchedResultsController alloc] initWithFetchRequest:request
											managedObjectContext:context
											  sectionNameKeyPath:group
													   cacheName:cacheName];
    [self MR_performFetch:controller];
	return [controller autorelease];
}

+ (NSFetchedResultsController *) MR_fetchRequest:(NSFetchRequest *)request groupedBy:(NSString *)group
{
	return [self MR_fetchRequest:request
					   groupedBy:group
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
    [request setPropertiesToFetch:[NSArray arrayWithObject:attribute]];
    
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
	NSFetchRequest *request = [self MR_createFetchRequestInContext:context];
	
	[request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", attribute, searchValue]];
	
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
        NSString *entityName = NSStringFromClass([self class]);
        return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
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

+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate
{
    return [self MR_deleteAllMatchingPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
}

+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self MR_requestAllWithPredicate:predicate inContext:context];
	[request setIncludesSubentities:NO];
	[request setIncludesPropertyValues:NO];
    
	NSArray *objectsToTruncate = [self MR_executeFetchRequest:request inContext:context];
    
	for (id objectToTruncate in objectsToTruncate) 
    {
		[objectToTruncate MR_deleteInContext:context];
	}
    
	return YES;
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

- (id) MR_inContext:(NSManagedObjectContext*)context 
{
    NSError *error = nil;
    NSManagedObject *inContext = [context existingObjectWithID:[self objectID] error:&error];
    [MagicalRecordHelpers handleErrors:error];
    
    return inContext;
}

- (id) MR_inThreadContext 
{
    NSManagedObject *weakSelf = self;
    return [weakSelf MR_inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

@end