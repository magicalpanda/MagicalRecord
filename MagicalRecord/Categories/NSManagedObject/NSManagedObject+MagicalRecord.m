
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
    __block NSArray *results = nil;
    [context performBlockAndWait:^{

        NSError *error = nil;
        
        results = [context executeFetchRequest:request error:&error];
        
        if (results == nil) 
        {
            [MagicalRecord handleErrors:error];
        }

    }];
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
		[MagicalRecord handleErrors:error];
	}
}

#endif

+ (NSString *) MR_bestGuessAtAnEntityName
{
    if ([self respondsToSelector:@selector(entityName)])
    {
        return [self performSelector:@selector(entityName)];
    }
    return NSStringFromClass(self);
}

+ (NSEntityDescription *) MR_entityDescriptionInContext:(NSManagedObjectContext *)context
{
    NSString *entityName = [self MR_bestGuessAtAnEntityName];
    return [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
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
				MRLog(@"Property '%@' not found in %lx properties for %@", propertyName, (unsigned long)[propDict count], NSStringFromClass(self));
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

#pragma mark -

+ (id) MR_createInContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self MR_bestGuessAtAnEntityName] inManagedObjectContext:context];
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
    NSFetchRequest *request = [self MR_requestAllInContext:context];
    [request setReturnsObjectsAsFaults:YES];
    [request setIncludesPropertyValues:NO];

    NSArray *objectsToDelete = [self MR_executeFetchRequest:request inContext:context];
    for (NSManagedObject *objectToDelete in objectsToDelete)
    {
        [objectToDelete MR_deleteInContext:context];
    }
    return YES;
}

+ (BOOL) MR_truncateAll
{
    [self MR_truncateAllInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    return YES;
}

- (id) MR_inContext:(NSManagedObjectContext *)otherContext
{
    NSError *error = nil;
    
    if ([[self objectID] isTemporaryID])
    {
        BOOL success = [[self managedObjectContext] obtainPermanentIDsForObjects:@[self] error:&error];
        if (!success)
        {
            [MagicalRecord handleErrors:error];
            return nil;
        }
    }
    
    error = nil;
    
    NSManagedObject *inContext = [otherContext existingObjectWithID:[self objectID] error:&error];
    [MagicalRecord handleErrors:error];
    
    return inContext;
}

- (id) MR_inThreadContext
{
    NSManagedObject *weakSelf = self;
    return [weakSelf MR_inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

@end
