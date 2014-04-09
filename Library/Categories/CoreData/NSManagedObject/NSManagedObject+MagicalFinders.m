//
//  NSManagedObject+MagicalFinders.m
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObject+MagicalFinders.h"
#import "NSManagedObject+MagicalRequests.h"
#import "NSManagedObject+MagicalRecord.h"
#import "MagicalRecordStack.h"

@implementation NSManagedObject (MagicalFinders)

+ (NSArray *) MR_findAllInContext:(NSManagedObjectContext *)context
{
	return [self MR_executeFetchRequest:[self MR_requestAll] inContext:context];
}

+ (NSArray *) MR_findAll
{
	return [self MR_findAllInContext:[[MagicalRecordStack defaultStack] context]];
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self MR_requestAllSortedBy:sortTerm ascending:ascending];

	return [self MR_executeFetchRequest:request inContext:context];
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending
{
	return [self MR_findAllSortedBy:sortTerm
                          ascending:ascending
                          inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self MR_requestAllSortedBy:sortTerm
                                                ascending:ascending
                                            withPredicate:searchTerm];

	return [self MR_executeFetchRequest:request inContext:context];
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm
{
	return [self MR_findAllSortedBy:sortTerm
                          ascending:ascending
                      withPredicate:searchTerm
                          inContext:[[MagicalRecordStack defaultStack] context]];
}


+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self MR_requestAll];
	[request setPredicate:searchTerm];

	return [self MR_executeFetchRequest:request
                              inContext:context];
}

+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchTerm
{
	return [self MR_findAllWithPredicate:searchTerm
                               inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (id) MR_selectAttribute:(NSString *)attribute ascending:(BOOL)ascending;
{
    return [self MR_selectAttribute:attribute ascending:ascending inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (id) MR_selectAttribute:(NSString *)attribute ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [self MR_requestAllSortedBy:attribute ascending:ascending];
    [request setResultType:NSDictionaryResultType];
    [request setPropertiesToFetch:[NSArray arrayWithObject:attribute]];
    NSArray *results = [self MR_executeFetchRequest:request inContext:context];

    return [results valueForKeyPath:[NSString stringWithFormat:@"@unionOfObjects.%@", attribute]];
}

+ (id) MR_selectAttribute:(NSString *)attribute ascending:(BOOL)ascending withPredicate:(NSPredicate *)predicate;
{
    return [self MR_selectAttribute:attribute ascending:ascending withPredicate:predicate inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (id) MR_selectAttribute:(NSString *)attribute ascending:(BOOL)ascending withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [self MR_requestAllSortedBy:attribute ascending:ascending withPredicate:predicate];
    [request setResultType:NSDictionaryResultType];
    [request setPropertiesToFetch:[NSArray arrayWithObject:attribute]];
    NSArray *results = [self MR_executeFetchRequest:request inContext:context];

    return [results valueForKeyPath:[NSString stringWithFormat:@"@unionOfObjects.%@", attribute]];
}

+ (instancetype) MR_findFirst;
{
	return [self MR_findFirstInContext:[[MagicalRecordStack defaultStack] context]];
}

+ (instancetype) MR_findFirstInContext:(NSManagedObjectContext *)context;
{
	NSFetchRequest *request = [self MR_requestAll];

	return [self MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (instancetype) MR_findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
{
	return [self MR_findFirstByAttribute:attribute
                               withValue:searchValue
                               inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (instancetype) MR_findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self MR_requestFirstByAttribute:attribute withValue:searchValue];

	return [self MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (instancetype) MR_findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue orderedBy:(NSString *)orderedBy ascending:(BOOL)ascending;
{
    return [self MR_findFirstByAttribute:attribute withValue:searchValue orderedBy:orderedBy ascending:ascending inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (instancetype) MR_findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue orderedBy:(NSString *)orderedBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [self MR_requestFirstByAttribute:attribute withValue:searchValue];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:orderedBy ascending:ascending];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    return [self MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (instancetype) MR_findFirstOrderedByAttribute:(NSString *)attribute ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [self MR_requestAllSortedBy:attribute ascending:ascending];
    [request setFetchLimit:1];

    return [self MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (instancetype) MR_findFirstOrderedByAttribute:(NSString *)attribute ascending:(BOOL)ascending;
{
    return [self MR_findFirstOrderedByAttribute:attribute
                                      ascending:ascending
                                      inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (instancetype) MR_findFirstOrCreateByAttribute:(NSString *)attribute withValue:(id)searchValue
{
    return [self MR_findFirstOrCreateByAttribute:attribute
                                       withValue:searchValue
                                       inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (instancetype) MR_findFirstOrCreateByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context
{
    id result = [self MR_findFirstByAttribute:attribute
                                    withValue:searchValue
                                    inContext:context];

    if (result != nil) {
        return result;
    }

    result = [self MR_createEntityInContext:context];
    [result setValue:searchValue forKey:attribute];

    return result;
}

+ (id) MR_findLargestValueForAttribute:(NSString *)attribute withPredicate:(NSPredicate *)predicate;
{
    return [self MR_findLargestValueForAttribute:attribute withPredicate:predicate inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (id) MR_findLargestValueForAttribute:(NSString *)attribute withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [self MR_requestAllSortedBy:attribute ascending:NO];
    [request setFetchLimit:1];
    [request setResultType:NSDictionaryResultType];
    [request setPropertiesToFetch:@[attribute]];
    [request setPredicate:predicate];

    NSDictionary *results = [self MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
    id value = [results valueForKey:attribute];

    return value;
}

+ (id) MR_findLargestValueForAttribute:(NSString *)attribute;
{
    return [self MR_findLargestValueForAttribute:attribute inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (id) MR_findLargestValueForAttribute:(NSString *)attribute inContext:(NSManagedObjectContext *)context;
{
    return [self MR_findLargestValueForAttribute:attribute withPredicate:nil inContext:context];
}

+ (id) MR_findSmallestValueForAttribute:(NSString *)attribute;
{
    return [self MR_findSmallestValueForAttribute:attribute inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (id) MR_findSmallestValueForAttribute:(NSString *)attribute inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [self MR_requestAllSortedBy:attribute ascending:YES];
    [request setFetchLimit:1];
    [request setResultType:NSDictionaryResultType];
    [request setPropertiesToFetch:@[attribute]];

    NSDictionary *results = [self MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
    id value = [results valueForKey:attribute];

    return value;
}

+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchTerm;
{
    return [self MR_findFirstWithPredicate:searchTerm inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self MR_requestFirstWithPredicate:searchTerm];

    return [self MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)property ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
{
	NSFetchRequest *request = [self MR_requestAllSortedBy:property ascending:ascending withPredicate:searchTerm];

	return [self MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending;
{
	return [self MR_findFirstWithPredicate:searchterm
                                  sortedBy:property
                                 ascending:ascending
                                 inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes inContext:(NSManagedObjectContext *)context;
{
	NSFetchRequest *request = [self MR_requestAll];
	[request setPredicate:searchTerm];
	[request setPropertiesToFetch:attributes];

	return [self MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes;
{
	return [self MR_findFirstWithPredicate:searchTerm
                     andRetrieveAttributes:attributes
                                 inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context andRetrieveAttributes:(id)attributes, ...
{
	NSFetchRequest *request = [self MR_requestAllSortedBy:sortBy
                                                ascending:ascending
                                            withPredicate:searchTerm];
	[request setPropertiesToFetch:[self MR_propertiesNamed:attributes]];

	return [self MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending andRetrieveAttributes:(id)attributes, ...
{
	return [self MR_findFirstWithPredicate:searchTerm
                                  sortedBy:sortBy
                                 ascending:ascending
                                 inContext:[[MagicalRecordStack defaultStack] context]
                     andRetrieveAttributes:attributes];
}

+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [self MR_requestAllWhere:attribute isEqualTo:searchValue];

	return [self MR_executeFetchRequest:request inContext:context];
}

+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue;
{
	return [self MR_findByAttribute:attribute
                          withValue:searchValue
                          inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
{
	NSPredicate *searchTerm = [NSPredicate predicateWithFormat:@"%K = %@", attribute, searchValue];
	NSFetchRequest *request = [self MR_requestAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm];

	return [self MR_executeFetchRequest:request inContext:context];
}

+ (NSArray *) MR_findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending;
{
	return [self MR_findByAttribute:attribute
                          withValue:searchValue
                         andOrderBy:sortTerm
                          ascending:ascending
                          inContext:[[MagicalRecordStack defaultStack] context]];
}

@end
