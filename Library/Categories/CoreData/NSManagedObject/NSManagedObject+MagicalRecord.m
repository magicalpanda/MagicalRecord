
//  Created by Saul Mora on 11/15/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "MagicalRecord.h"
#import "MagicalRecordStack.h"
#import "MagicalRecordLogging.h"

@implementation NSManagedObject (MagicalRecord)

#pragma mark - Entity Information

+ (NSString *) MR_entityName;
{
    NSString *entityName;

    if ([self respondsToSelector:@selector(entityName)])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wselector"
        entityName = [self performSelector:@selector(entityName)];
#pragma clang diagnostic pop
    }

    if ([entityName length] == 0)
    {
        entityName = NSStringFromClass(self);
    }

    return entityName;
}

+ (NSEntityDescription *) MR_entityDescription
{
	return [self MR_entityDescriptionInContext:[[MagicalRecordStack defaultStack] context]];
}

+ (NSEntityDescription *) MR_entityDescriptionInContext:(NSManagedObjectContext *)context
{
    NSString *entityName = [self MR_entityName];
    return [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
}

+ (NSArray *) MR_propertiesNamed:(NSArray *)properties
{
    return [self MR_propertiesNamed:properties inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (NSArray *) MR_propertiesNamed:(NSArray *)properties inContext:(NSManagedObjectContext *)context
{
	NSEntityDescription *description = [self MR_entityDescriptionInContext:context];
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
				MRLogWarn(@"Property '%@' not found in %tu properties for %@", propertyName, [propDict count], NSStringFromClass(self));
			}
		}
	}
	return propertiesWanted;
}

#pragma mark - Fetch Requests

+ (NSArray *) MR_executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
    __block NSArray *results = nil;
    void (^requestBlock)(void) = ^{

        NSError *error = nil;
        results = [context executeFetchRequest:request error:&error];

        if (results == nil)
        {
            [[error MR_coreDataDescription] MR_logToConsole];
        }
    };

    if ([context concurrencyType] == NSConfinementConcurrencyType)
    {
        requestBlock();
    }
    else
    {
        [context performBlockAndWait:requestBlock];
    }
	return results;
}

+ (NSArray *) MR_executeFetchRequest:(NSFetchRequest *)request
{
	return [self MR_executeFetchRequest:request inContext:[[MagicalRecordStack defaultStack] context]];
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
	return [self MR_executeFetchRequestAndReturnFirstObject:request inContext:[[MagicalRecordStack defaultStack] context]];
}

#pragma mark - Creating Entities

+ (instancetype) MR_createEntity
{
	return [self MR_createEntityInContext:[[MagicalRecordStack defaultStack] context]];
}

+ (instancetype) MR_createEntityInContext:(NSManagedObjectContext *)context
{
    return [self MR_createEntityWithDescription:nil inContext:context];
}

+ (instancetype) MR_createEntityWithDescription:(NSEntityDescription *)entityDescription inContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = entityDescription;

    if (!entity)
    {
        entity = [self MR_entityDescriptionInContext:context];
    }

//    [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    NSManagedObject *managedObject = [[self alloc] initWithEntity:entity insertIntoManagedObjectContext:context];

    if ([managedObject respondsToSelector:@selector(MR_awakeFromCreation)])
    {
        [managedObject MR_awakeFromCreation];
    }

    return managedObject;
}

- (BOOL) MR_isTemporaryObject;
{
    return [[self objectID] isTemporaryID];
}

#pragma mark - Deleting Entities

- (BOOL) MR_isEntityDeleted
{
    return [self isDeleted] || [self managedObjectContext] == nil;
}

- (BOOL) MR_deleteEntity
{
	return [self MR_deleteEntityInContext:[self managedObjectContext]];
}

- (BOOL) MR_deleteEntityInContext:(NSManagedObjectContext *)context
{
    NSError *retrieveExistingObjectError;
    NSManagedObject *objectInContext = [context existingObjectWithID:[self objectID] error:&retrieveExistingObjectError];

    [[retrieveExistingObjectError MR_coreDataDescription] MR_logToConsole];

    [context deleteObject:objectInContext];

    return [objectInContext MR_isEntityDeleted];
}

+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate
{
    return [self MR_deleteAllMatchingPredicate:predicate inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self MR_requestAllWithPredicate:predicate];
    [request setReturnsObjectsAsFaults:YES];
	[request setIncludesPropertyValues:NO];

	NSArray *objectsToTruncate = [self MR_executeFetchRequest:request inContext:context];

	for (NSManagedObject *objectToTruncate in objectsToTruncate)
    {
		[objectToTruncate MR_deleteEntityInContext:context];
	}

	return YES;
}

+ (BOOL) MR_truncateAll
{
    [self MR_truncateAllInContext:[[MagicalRecordStack defaultStack] context]];
    return YES;
}

+ (BOOL) MR_truncateAllInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self MR_requestAll];
    [request setReturnsObjectsAsFaults:YES];
    [request setIncludesPropertyValues:NO];

    NSArray *objectsToDelete = [self MR_executeFetchRequest:request inContext:context];
    for (NSManagedObject *objectToDelete in objectsToDelete)
    {
        [objectToDelete MR_deleteEntityInContext:context];
    }
    return YES;
}

#pragma mark - Sorting Entities

+ (NSArray *) MR_ascendingSortDescriptors:(NSArray *)attributesToSortBy
{
	return [self MR_sortAscending:YES attributes:attributesToSortBy];
}

+ (NSArray *) MR_descendingSortDescriptors:(NSArray *)attributesToSortBy
{
	return [self MR_sortAscending:NO attributes:attributesToSortBy];
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

#pragma mark - Working Across Contexts

- (void) MR_refresh;
{
    [[self managedObjectContext] refreshObject:self mergeChanges:YES];
}

- (void) MR_obtainPermanentObjectID;
{
    if ([[self objectID] isTemporaryID])
    {
        NSError *error = nil;

        BOOL success = [[self managedObjectContext] obtainPermanentIDsForObjects:[NSArray arrayWithObject:self] error:&error];
        if (!success)
        {
            [[error MR_coreDataDescription] MR_logToConsole];
        }
    }
}

- (instancetype) MR_inContext:(NSManagedObjectContext *)otherContext;
{
    NSManagedObject *inContext = nil;
    NSManagedObjectID *objectID = [self objectID];
    if (otherContext == [self managedObjectContext])
    {
        inContext = self;
    }
    else if ([objectID isTemporaryID])
    {
        NSString *reason = [NSString stringWithFormat:@"Cannot load a temporary object '%@' [%@] across managed object contexts. Please obtain a permanent ID for this object first.", self, [self objectID]];
        @throw [NSException exceptionWithName:NSObjectInaccessibleException reason:reason userInfo:@{@"object" : self}];
    }
    else
    {
        inContext = [otherContext objectRegisteredForID:objectID];  //see if its already there
        if (inContext == nil)
        {
            NSError *error = nil;
            inContext = [otherContext existingObjectWithID:objectID error:&error];

            if (inContext == nil)
            {
                MRLogWarn(@"Did not find object %@ in context '%@': %@", self, [otherContext MR_description], error);
            }
        }
    }
    return inContext;
}

- (instancetype) MR_inContextIfTemporaryObject:(NSManagedObjectContext *)otherContext
{
    NSManagedObjectID *objectID = [self objectID];
    if ([objectID isTemporaryID])
    {
        return self;
    }
    else
    {
        return [self MR_inContext:otherContext];
    }
}

#pragma mark - Validation

- (BOOL) MR_isValidForInsert;
{
    NSError *error = nil;
    BOOL isValid = [self validateForInsert:&error];
    if (!isValid)
    {
        [[error MR_coreDataDescription] MR_logToConsole];
    }
    
    return isValid;
}

- (BOOL) MR_isValidForUpdate;
{
    NSError *error = nil;
    BOOL isValid = [self validateForUpdate:&error];
    if (!isValid)
    {
        [[error MR_coreDataDescription] MR_logToConsole];
    }

    return isValid;
}

@end

#pragma mark - Deprecated Methods
@implementation NSManagedObject (MagicalRecordDeprecated)

+ (instancetype) MR_createInContext:(NSManagedObjectContext *)context
{
    return [self MR_createEntityInContext:context];
}

- (BOOL) MR_deleteInContext:(NSManagedObjectContext *)context
{
    return [self MR_deleteEntityInContext:context];
}

- (instancetype) MR_inContextIfTempObject:(NSManagedObjectContext *)otherContext;
{
    return [self MR_inContextIfTemporaryObject:otherContext];
}

@end

