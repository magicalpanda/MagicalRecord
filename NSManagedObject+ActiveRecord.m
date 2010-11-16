
//  Created by Saul Mora on 11/15/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NSManagedObject+ActiveRecord.h"
#import "NSManagedObjectContext+ActiveRecord.h"
#import "NSNumberAdditions.h"

static NSNumber *defaultBatchSize = nil;

@implementation NSManagedObject (ActiveRecord)


+ (void) setDefaultBatchSize:(NSUInteger)newBatchSize
{
	@synchronized(defaultBatchSize)
	{
		defaultBatchSize = [[NSNumber numberWithInt:newBatchSize] retain];
	}
}

+ (NSInteger) defaultBatchSize
{
	if (defaultBatchSize == nil)
	{
		[self setDefaultBatchSize:kActiveRecordDefaultBatchSize];
	}
	return [defaultBatchSize integerValue];
}

+ (void) handleErrors:(NSError *)error
{
	if (error)
	{
		DDLogError(@"Error Requesting Data: %@", [error userInfo]);
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
	return [self executeFetchRequest:request inContext:[NSManagedObjectContext defaultContext]];
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
	return [self executeFetchRequestAndReturnFirstObject:request inContext:[NSManagedObjectContext defaultContext]];
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
	return [self entityDescriptionInContext:[NSManagedObjectContext defaultContext]];
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
				DDLogWarn(@"Property '%@' not found in %@ properties for %@", propertyName, [propDict count], NSStringFromClass(self));
			}
		}
	}
	return propertiesWanted;
}

+ (NSArray *) sortAscending:(BOOL)ascending attributes:(id)attributesToSortBy, ...
{
	NSMutableArray *attributes = [NSMutableArray array];

	if ([attributesToSortBy isKindOfClass:[NSArray class]])
	{
		id attributeName;
		va_list variadicArguments;
		va_start(variadicArguments, attributesToSortBy);
		while ((attributeName = va_arg(variadicArguments, id)) != nil)
		{
			NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attributeName ascending:ascending];
			[attributes addObject:sortDescriptor];
			[sortDescriptor release];
		}
		va_end(variadicArguments);

	}
	else if ([attributesToSortBy isKindOfClass:[NSString class]])
	{
		va_list variadicArguments;
		va_start(variadicArguments, attributesToSortBy);
		[attributes addObject:[[[NSSortDescriptor alloc] initWithKey:attributesToSortBy ascending:ascending] autorelease] ];
		va_end(variadicArguments);
	}

	return attributes;
}

+ (NSArray *) ascendingSortDescriptors:(id)attributesToSortBy, ...
{
	return [self sortAscending:YES attributes:attributesToSortBy];
}

+ (NSArray *) descendingSortDescriptors:(id)attributesToSortyBy, ...
{
	return [self sortAscending:NO attributes:attributesToSortyBy];
}

+ (NSFetchRequest *)createFetchRequestInContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[self entityDescriptionInContext:context]];

	return request;
}

+ (NSFetchRequest *)createFetchRequest
{
	return [self createFetchRequestInContext:[NSManagedObjectContext defaultContext]];
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
	return [self numberOfEntitiesWithContext:[NSManagedObjectContext defaultContext]];
}

+ (NSNumber *) numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
	NSError *error = nil;
	NSFetchRequest *request = [self createFetchRequestInContext:context];
	[request setPredicate:searchTerm];

	NSUInteger count = [context countForFetchRequest:request error:&error];
	[ActiveRecordHelpers handleErrors:error];

	return [NSNumber numberWithUnsignedInt:count];
}

+ (NSNumber *) numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm;
{
	return [self numberOfEntitiesWithPredicate:searchTerm
									 inContext:[NSManagedObjectContext defaultContext]];
}

+ (BOOL) hasAtLeastOneEntity
{
    return [self hasAtLeastOneEntityInContext:[NSManagedObjectContext defaultContext]];
}

+ (BOOL) hasAtLeastOneEntityInContext:(NSManagedObjectContext *)context
{
    return [[self numberOfEntitiesWithContext:context] intValue] > 0;
}

#pragma mark -
#pragma mark Reqest Helpers
+ (NSFetchRequest *) requestAll
{
	return [self createFetchRequestInContext:[NSManagedObjectContext defaultContext]];
}

+ (NSFetchRequest *) requestAllInContext:(NSManagedObjectContext *)context
{
	return [self createFetchRequestInContext:context];
}

+ (NSFetchRequest *) requestAllWhere:(NSString *)property isEqualTo:(id)value
{
    return [self requestAllWhere:property isEqualTo:value inContext:[NSManagedObjectContext defaultContext]];
}

+ (NSFetchRequest *) requestAllWhere:(NSString *)property isEqualTo:(id)value inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", property, value]];

    return request;
}

+ (NSFetchRequest *) requestFirstWithPredicate:(NSPredicate *)searchTerm
{
    return [self requestFirstWithPredicate:searchTerm inContext:[NSManagedObjectContext defaultContext]];
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
    return [self requestFirstByAttribute:attribute withValue:searchValue inContext:[NSManagedObjectContext defaultContext]];
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
						  inContext:[NSManagedObjectContext defaultContext]];
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
											 inContext:[NSManagedObjectContext defaultContext]];
	return request;
}


#pragma mark Finding Data
#pragma mark -

+ (id) objectWithObjectID:(NSManagedObjectID *)objectID
{
  return [self objectWithObjectID:objectID inContext:[NSManagedObjectContext defaultContext]];
}

+ (id) objectWithObjectID:(NSManagedObjectID *)objectID inContext:(NSManagedObjectContext *)context
{
  NSManagedObject *fetchedObject = nil;
  NSError *error = nil;
  if (objectID) {
    fetchedObject = [context existingObjectWithID:objectID error:&error];
    if (!fetchedObject && error) {
      [self handleErrors:error];
    }
  }
  return fetchedObject;
}

- (id) objectWithObjectID:(NSManagedObjectID *)objectID
{
  return [[self class] objectWithObjectID:objectID inContext:[self managedObjectContext]];
}


+ (NSArray *)findAllInContext:(NSManagedObjectContext *)context
{
	return [self executeFetchRequest:[self requestAllInContext:context] inContext:context];
}

+ (NSArray *)findAll
{
	return [self findAllInContext:[NSManagedObjectContext defaultContext]];
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
					   inContext:[NSManagedObjectContext defaultContext]];
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
					   inContext:[NSManagedObjectContext defaultContext]];
}

#pragma mark -
#pragma mark NSFetchedResultsController helpers

#if TARGET_OS_IPHONE

+ (NSFetchedResultsController *) fetchRequestAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
	NSString *cacheName = nil;
	#ifdef STORE_USE_CACHE
	cacheName = [NSString stringWithFormat:@"cache-%@", NSStringFromClass(self)];
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
								inContext:[NSManagedObjectContext defaultContext]];
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
						inContext:[NSManagedObjectContext defaultContext]];
}

+ (NSFetchedResultsController *) fetchRequest:(NSFetchRequest *)request groupedBy:(NSString *)group inContext:(NSManagedObjectContext *)context
{
	NSString *cacheName = nil;
	#ifdef STORE_USE_CACHE
	cacheName = [NSString stringWithFormat:@"cache-%@", NSStringFromClass([self class])];
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
					inContext:[NSManagedObjectContext defaultContext]];
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
							inContext:[NSManagedObjectContext defaultContext]];
}

+ (id)findFirstByUID:(id)searchValue {
  return [self findFirstByUID:searchValue inContext:[NSManagedObjectContext defaultContext]]; 
}

+ (id)findFirstByUID:(id)searchValue inContext:(NSManagedObjectContext *)context {
  NSNumber *uidNum;
  if ([searchValue isKindOfClass:[NSNumber class]]) {
    uidNum = searchValue;
  }else if ([searchValue isKindOfClass:[NSString class]]) {
    uidNum = [NSNumber numberWithString:searchValue];
  }else {
    DDLogWarn(@"Wrong type for searchValue!");
    return nil;
  }
  return [self findFirstByAttribute:@"uid" withValue:uidNum];
}


+ (id)findFirstInContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self createFetchRequestInContext:context];

	return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id)findFirst
{
	return [self findFirstInContext:[NSManagedObjectContext defaultContext]];
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
							inContext:[NSManagedObjectContext defaultContext]];
}

+ (id)findFirstWithPredicate:(NSPredicate *)searchTerm
{
    return [self findFirstWithPredicate:searchTerm inContext:[NSManagedObjectContext defaultContext]];
}

+ (id)findFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestFirstWithPredicate:searchTerm];

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
							  inContext:[NSManagedObjectContext defaultContext]];
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
							  inContext:[NSManagedObjectContext defaultContext]];
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
								inContext:[NSManagedObjectContext defaultContext]
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
					   inContext:[NSManagedObjectContext defaultContext]];
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
					   inContext:[NSManagedObjectContext defaultContext]];
}

+ (id) createInContext:(NSManagedObjectContext *)context
{
	NSString *entityName = NSStringFromClass([self class]);
	return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
}

+ (id)createEntity
{
	NSManagedObject *newEntity = [self createInContext:[NSManagedObjectContext defaultContext]];

	return newEntity;
}

- (BOOL) deleteInContext:(NSManagedObjectContext *)context
{
	[context deleteObject:self];
	return YES;
}

- (BOOL) deleteEntity
{
	[self deleteInContext:[NSManagedObjectContext defaultContext]];
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
    [self truncateAllInContext:[NSManagedObjectContext defaultContext]];
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
	return [self objectWithMinValueFor:property inContext:[NSManagedObjectContext defaultContext]];
}

@end
