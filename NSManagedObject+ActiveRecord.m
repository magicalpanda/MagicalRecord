
//  Created by Saul Mora on 11/15/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NSManagedObject+ActiveRecord.h"
#import "NSManagedObjectContext+ActiveRecord.h"


static NSUInteger defaultBatchSize = kActiveRecordDefaultBatchSize;

@implementation NSManagedObject (ActiveRecord)


+ (void) setDefaultBatchSize:(NSUInteger)newBatchSize
{
	@synchronized(self)
	{
		defaultBatchSize = newBatchSize;
	}
}

+ (NSUInteger) defaultBatchSize
{
	return defaultBatchSize;
}

+ (void) handleErrors:(NSError *)error
{
	if (error)
	{
		ARLog(@"Error Requesting Data: %@", [error userInfo]);
		//TODO: maybe call a delegate to handle the error? subclass/hook method for error?
	}
}

+ (NSArray *) executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
	NSError *error = nil;
	
	NSArray *results = [context executeFetchRequest:request error:&error];
	[ActiveRecordHelpers handleErrors:error];
	return results;	
}

+ (NSArray *) executeFetchRequest:(NSFetchRequest *)request 
{
	return [self executeFetchRequest:request inContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (id) executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
	[request setFetchLimit:1];
	
	NSArray *results = [self executeFetchRequest:request inContext:context];
	if ([results count] == 0)
	{
		return nil;
	}
	return [results objectAtIndex:0];
}

+ (id) executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request
{
	return [self executeFetchRequestAndReturnFirstObject:request inContext:[NSManagedObjectContext contextForCurrentThread]];
}

#if TARGET_OS_IPHONE
+ (void) performFetch:(NSFetchedResultsController *)controller
{
	NSError *error = nil;
	if (![controller performFetch:&error])
	{
		[ActiveRecordHelpers handleErrors:error];
	}
}
#endif

+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context
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

+ (NSEntityDescription *)entityDescription
{
	return [self entityDescriptionInContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (NSArray *)propertiesNamed:(NSArray *)properties
{
	NSEntityDescription *description = [self entityDescription];
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

+ (NSArray *) sortAscending:(BOOL)ascending attributes:(NSArray *)attributesToSortBy
{
	NSMutableArray *attributes = [NSMutableArray array];
    
    for (NSString *attributeName in attributesToSortBy) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attributeName ascending:ascending];
        [attributes addObject:sortDescriptor];
        [sortDescriptor release];
    }
    
	return attributes;
}

+ (NSArray *) ascendingSortDescriptors:(NSArray *)attributesToSortBy
{
	return [self sortAscending:YES attributes:attributesToSortBy];
}

+ (NSArray *) descendingSortDescriptors:(NSArray *)attributesToSortBy
{
	return [self sortAscending:NO attributes:attributesToSortBy];
}

+ (NSFetchRequest *)createFetchRequestInContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[self entityDescriptionInContext:context]];
	
	return request;	
}

+ (NSFetchRequest *)createFetchRequest
{
	return [self createFetchRequestInContext:[NSManagedObjectContext contextForCurrentThread]];
}

#pragma mark -
#pragma mark Number of Entities

+ (NSNumber *) numberOfEntitiesWithContext:(NSManagedObjectContext *)context
{
	NSError *error = nil;
	NSUInteger count = [context countForFetchRequest:[self createFetchRequestInContext:context] error:&error];
	[ActiveRecordHelpers handleErrors:error];
	
	return [NSNumber numberWithUnsignedInteger:count];	
}

+ (NSNumber *)numberOfEntities
{
	return [self numberOfEntitiesWithContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (NSNumber *) numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
	NSError *error = nil;
	NSFetchRequest *request = [self createFetchRequestInContext:context];
	[request setPredicate:searchTerm];
	
	NSUInteger count = [context countForFetchRequest:request error:&error];
	[ActiveRecordHelpers handleErrors:error];
	
	return [NSNumber numberWithUnsignedInteger:count];	
}
																				  
+ (NSNumber *) numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm;
{
	return [self numberOfEntitiesWithPredicate:searchTerm 
									 inContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (NSNumber *) numberOfUniqueEntitiesWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
	NSError *error = nil;
	NSFetchRequest *request = [self createFetchRequestInContext:context];
	[request setPredicate:searchTerm];
    [request setReturnsDistinctResults:YES];
	
	NSUInteger count = [context countForFetchRequest:request error:&error];
	[ActiveRecordHelpers handleErrors:error];
	
	return [NSNumber numberWithUnsignedInteger:count];	   
}

+ (NSNumber *) numberOfUniqueEntitiesWithPredicate:(NSPredicate *)searchTerm;
{
    return [self numberOfEntitiesWithPredicate:searchTerm 
                                     inContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (BOOL) hasAtLeastOneEntity
{
    return [self hasAtLeastOneEntityInContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (BOOL) hasAtLeastOneEntityInContext:(NSManagedObjectContext *)context
{
    return [[self numberOfEntitiesWithContext:context] intValue] > 0;
}

#pragma mark -
#pragma mark Reqest Helpers
+ (NSFetchRequest *) requestAll
{
	return [self createFetchRequestInContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (NSFetchRequest *) requestAllInContext:(NSManagedObjectContext *)context
{
	return [self createFetchRequestInContext:context];
}

+ (NSFetchRequest *) requestAllWithPredicate:(NSPredicate *)searchTerm;
{
    return [self requestAllWithPredicate:searchTerm inContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (NSFetchRequest *) requestAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setPredicate:searchTerm];
    
    return request;
}

+ (NSFetchRequest *) requestAllWhere:(NSString *)property isEqualTo:(id)value
{
    return [self requestAllWhere:property isEqualTo:value inContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (NSFetchRequest *) requestAllWhere:(NSString *)property isEqualTo:(id)value inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", property, value]];

    return request;
}

+ (NSFetchRequest *) requestFirstWithPredicate:(NSPredicate *)searchTerm
{
    return [self requestFirstWithPredicate:searchTerm inContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (NSFetchRequest *) requestFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setPredicate:searchTerm];
    [request setFetchLimit:1];
    
    return request;
}

+ (NSFetchRequest *) requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
{
    return [self requestFirstByAttribute:attribute withValue:searchValue inContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (NSFetchRequest *) requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setPropertiesToFetch:[NSArray arrayWithObject:attribute]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", attribute, searchValue]];
    
    return request;
}

+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self requestAllInContext:context];
	
	NSSortDescriptor *sortBy = [[NSSortDescriptor alloc] initWithKey:sortTerm ascending:ascending];
	[request setSortDescriptors:[NSArray arrayWithObject:sortBy]];
	[sortBy release];
	
	return request;
}

+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending
{
	return [self requestAllSortedBy:sortTerm 
						  ascending:ascending
						  inContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self requestAllInContext:context];
	[request setPredicate:searchTerm];
	[request setIncludesSubentities:NO];
	[request setFetchBatchSize:[self defaultBatchSize]];
	
	NSSortDescriptor *sortBy = [[NSSortDescriptor alloc] initWithKey:sortTerm ascending:ascending];
	[request setSortDescriptors:[NSArray arrayWithObject:sortBy]];
	[sortBy release];
	
	return request;
}

+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
{
	NSFetchRequest *request = [self requestAllSortedBy:sortTerm 
											 ascending:ascending
										 withPredicate:searchTerm 
											 inContext:[NSManagedObjectContext contextForCurrentThread]];
	return request;
}


#pragma mark Finding Data
#pragma mark -

+ (NSArray *)findAllInContext:(NSManagedObjectContext *)context
{
	return [self executeFetchRequest:[self requestAllInContext:context] inContext:context];	
}

+ (NSArray *)findAll
{
	return [self findAllInContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self requestAllSortedBy:sortTerm ascending:ascending inContext:context];
	
	return [self executeFetchRequest:request inContext:context];
}

+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending
{
	return [self findAllSortedBy:sortTerm 
					   ascending:ascending 
					   inContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self requestAllSortedBy:sortTerm 
											 ascending:ascending
										 withPredicate:searchTerm
											 inContext:context];
	
	return [self executeFetchRequest:request inContext:context];
}

+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm
{
	return [self findAllSortedBy:sortTerm 
					   ascending:ascending
				   withPredicate:searchTerm 
					   inContext:[NSManagedObjectContext contextForCurrentThread]];
}

#pragma mark -
#pragma mark NSFetchedResultsController helpers

#if TARGET_OS_IPHONE

+ (NSFetchedResultsController *) fetchRequestAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
	NSString *cacheName = nil;
	#ifdef STORE_USE_CACHE
	cacheName = [NSString stringWithFormat:@"ActiveRecord-Cache-%@", NSStringFromClass(self)];
	#endif
	
	NSFetchRequest *request = [self requestAllSortedBy:sortTerm 
											 ascending:ascending 
										 withPredicate:searchTerm
											 inContext:context];
	
	NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
																				 managedObjectContext:context
																				   sectionNameKeyPath:group
																							cacheName:cacheName];
	return [controller autorelease];
}

+ (NSFetchedResultsController *) fetchRequestAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending 
{
	return [self fetchRequestAllGroupedBy:group
							withPredicate:searchTerm
								 sortedBy:sortTerm
								ascending:ascending
								inContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (NSFetchedResultsController *) fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath inContext:(NSManagedObjectContext *)context
{
	NSFetchedResultsController *controller = [self fetchRequestAllGroupedBy:groupingKeyPath 
															  withPredicate:searchTerm
																   sortedBy:sortTerm 
																  ascending:ascending
																  inContext:context];
	
	[self performFetch:controller];
	return controller;
}

+ (NSFetchedResultsController *) fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath
{
	return [self fetchAllSortedBy:sortTerm 
						ascending:ascending
					withPredicate:searchTerm 
						  groupBy:groupingKeyPath 
						inContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (NSFetchedResultsController *) fetchRequest:(NSFetchRequest *)request groupedBy:(NSString *)group inContext:(NSManagedObjectContext *)context
{
	NSString *cacheName = nil;
	#ifdef STORE_USE_CACHE
	cacheName = [NSString stringWithFormat:@"ActiveRecord-Cache-%@", NSStringFromClass([self class])];
	#endif
	NSFetchedResultsController *controller =
		[[NSFetchedResultsController alloc] initWithFetchRequest:request
											managedObjectContext:context
											  sectionNameKeyPath:group
													   cacheName:cacheName];
    [self performFetch:controller];
	return [controller autorelease];
}

+ (NSFetchedResultsController *) fetchRequest:(NSFetchRequest *)request groupedBy:(NSString *)group
{
	return [self fetchRequest:request 
					groupedBy:group
					inContext:[NSManagedObjectContext contextForCurrentThread]];
}
#endif

#pragma mark -

+ (NSArray *)findAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self createFetchRequestInContext:context];
	[request setPredicate:searchTerm];
	
	return [self executeFetchRequest:request 
						   inContext:context];
}

+ (NSArray *)findAllWithPredicate:(NSPredicate *)searchTerm
{
	return [self findAllWithPredicate:searchTerm 
							inContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (id)findFirstInContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self createFetchRequestInContext:context];
	
	return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id)findFirst
{
	return [self findFirstInContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (id)findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context
{	
	NSFetchRequest *request = [self requestFirstByAttribute:attribute withValue:searchValue inContext:context];
    [request setPropertiesToFetch:[NSArray arrayWithObject:attribute]];
    
	return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id)findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue
{
	return [self findFirstByAttribute:attribute 
							withValue:searchValue 
							inContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (id)findFirstWithPredicate:(NSPredicate *)searchTerm
{
    return [self findFirstWithPredicate:searchTerm inContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (id)findFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestFirstWithPredicate:searchTerm inContext:context];
    
    return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id)findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self requestAllSortedBy:property ascending:ascending withPredicate:searchterm inContext:context];

	return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id)findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending
{
	return [self findFirstWithPredicate:searchterm 
							   sortedBy:property 
							  ascending:ascending 
							  inContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (id)findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self createFetchRequestInContext:context];
	[request setPredicate:searchTerm];
	[request setPropertiesToFetch:attributes];
	
	return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id)findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes
{
	return [self findFirstWithPredicate:searchTerm 
				  andRetrieveAttributes:attributes 
							  inContext:[NSManagedObjectContext contextForCurrentThread]];
}


+ (id) findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context andRetrieveAttributes:(id)attributes, ...
{
	NSFetchRequest *request = [self requestAllSortedBy:sortBy 
											 ascending:ascending
										 withPredicate:searchTerm
											 inContext:context];
	[request setPropertiesToFetch:[self propertiesNamed:attributes]];
	
	return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id) findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending andRetrieveAttributes:(id)attributes, ...
{
	return [self findFirstWithPredicate:searchTerm
							   sortedBy:sortBy 
							  ascending:ascending 
								inContext:[NSManagedObjectContext contextForCurrentThread]
				  andRetrieveAttributes:attributes];
}

+ (NSArray *)findByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self createFetchRequestInContext:context];
	
	[request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", attribute, searchValue]];
	
	return [self executeFetchRequest:request inContext:context];
}

+ (NSArray *)findByAttribute:(NSString *)attribute withValue:(id)searchValue
{
	return [self findByAttribute:attribute 
					   withValue:searchValue 
					   inContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (NSArray *)findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
	NSPredicate *searchTerm = [NSPredicate predicateWithFormat:@"%K = %@", attribute, searchValue];
	NSFetchRequest *request = [self requestAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm inContext:context];
	
	return [self executeFetchRequest:request];
}

+ (NSArray *)findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending
{
	return [self findByAttribute:attribute 
					   withValue:searchValue
					  andOrderBy:sortTerm 
					   ascending:ascending 
					   inContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (id) createInContext:(NSManagedObjectContext *)context
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

+ (id)createEntity
{	
	NSManagedObject *newEntity = [self createInContext:[NSManagedObjectContext contextForCurrentThread]];

	return newEntity;
}

- (BOOL) deleteInContext:(NSManagedObjectContext *)context
{
	[context deleteObject:self];
	return YES;
}

- (BOOL) deleteEntity
{
	[self deleteInContext:[self managedObjectContext]];
	return YES;
}

+ (BOOL) truncateAllInContext:(NSManagedObjectContext *)context
{
    NSArray *allEntities = [self findAllInContext:context];
    for (NSManagedObject *obj in allEntities)
    {
        [obj deleteInContext:context];
    }
    return YES;
}

+ (BOOL) truncateAll
{
    [self truncateAllInContext:[NSManagedObjectContext contextForCurrentThread]];
    return YES;
}

- (NSNumber *)maxValueFor:(NSString *)property
{
	NSManagedObject *obj = [[self class] findFirstByAttribute:property
													withValue:[NSString stringWithFormat:@"max(%@)", property]];
	
	return [obj valueForKey:property];
}

- (id) objectWithMinValueFor:(NSString *)property inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [[self class] createFetchRequestInContext:context];
							   
	NSPredicate *searchFor = [NSPredicate predicateWithFormat:@"SELF = %@ AND %K = min(%@)", self, property, property];
	[request setPredicate:searchFor];
	
	return [[self class] executeFetchRequestAndReturnFirstObject:request inContext:context];
}

- (id) objectWithMinValueFor:(NSString *)property 
{
	return [self objectWithMinValueFor:property inContext:[self  managedObjectContext]];
}


- (id) inContext:(NSManagedObjectContext*)context 
{
    NSError *error = nil;
    NSManagedObject *inContext = [[context existingObjectWithID:[self objectID] error:&error] retain];
    [ActiveRecordHelpers handleErrors:error];
    
    return [inContext autorelease];
}

- (id) inThreadContext 
{
    return [self inContext:[NSManagedObjectContext contextForCurrentThread]];
}

@end