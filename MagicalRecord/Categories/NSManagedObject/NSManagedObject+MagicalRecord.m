
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
				MRLog(@"Property '%@' not found in %u properties for %@", propertyName, [propDict count], NSStringFromClass(self));
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

+ (id) MR_createPermanentInContext:(NSManagedObjectContext *)context 
{
	return [[self MR_createInContext:context] MR_obtainPermanentID];
}

+ (id) MR_createPermanentEntity
{
	return [[self MR_createEntity] MR_obtainPermanentID];
}

+ (id) MR_createAndSaveEntityInContext:(NSManagedObjectContext *)context creationBlock:(void (^)(id object, NSManagedObjectContext* localContext))creationBlock 
{
	NSManagedObject* object = [self MR_createPermanentInContext:context];
	
	if (creationBlock) {
		creationBlock(object, context);
	}
	
	[context save];
	
	return object;
}

+ (NSArray*) MR_createAndSaveEntitiesInContext:(NSManagedObjectContext *)context count:(NSUInteger)count creationBlock:(void (^)(id, NSManagedObjectContext *, NSUInteger))creationBlock {
	NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:count];
	
	for (NSUInteger idx = 0; idx < count; ++idx) {
		[result addObject:[self MR_createInContext:context]];
	}
	
	NSError* error = nil;
	[context obtainPermanentIDsForObjects:result error:&error];
	
	if (creationBlock) {
		NSUInteger index = 0;
		for (NSManagedObject* object in result) {
			creationBlock(object, context, index);
		}
	}
	
	return result;
}

+ (id) MR_createAndSaveEntityWithBlock:(void (^)(id object, NSManagedObjectContext* localContext))creationBlock 
{
	return [self MR_createAndSaveEntityInContext:[NSManagedObjectContext contextForCurrentThread]
								   creationBlock:creationBlock];
}

+ (NSArray*) MR_createAndSaveEntities:(NSUInteger)count withBlock:(void (^)(id object, NSManagedObjectContext* localContext, NSUInteger))creationBlock {
	return [self MR_createAndSaveEntitiesInContext:[NSManagedObjectContext contextForCurrentThread]
											 count:count
									 creationBlock:creationBlock];
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

+ (id) MR_findWithObjectID:(NSManagedObjectID*)objectID inContext:(NSManagedObjectContext*)context;
{
	NSError *error = nil;
	NSManagedObject *object = [context existingObjectWithID:objectID error:&error];
	[MagicalRecord handleErrors:error];
	
	return object;
}

+ (id) MR_findWithObjectID:(NSManagedObjectID*)objectID
{
	NSManagedObjectContext* context = [NSManagedObjectContext MR_contextForCurrentThread];
	return [self MR_findWithObjectID:objectID inContext:context];
}

- (id) MR_inContext:(NSManagedObjectContext *)otherContext
{
    NSError *error = nil;
    NSManagedObject *inContext = [otherContext existingObjectWithID:[self objectID] error:&error];
    [MagicalRecord handleErrors:error];
    
    return inContext;
}

- (id) MR_inThreadContext
{
    NSManagedObject *weakSelf = self;
    return [weakSelf MR_inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

- (id) MR_obtainPermanentID {
	NSError* err = nil;
	NSArray* objects = [NSArray arrayWithObject:self];
	[self.managedObjectContext obtainPermanentIDsForObjects:objects error:&err];
	[MagicalRecord handleErrors:err];
	return self;
}



@end
