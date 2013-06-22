//
//  NSManagedObject+MagicalRequests.m
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObject+MagicalRequests.h"
#import "NSManagedObject+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalThreading.h"

@implementation NSManagedObject (MagicalRequests)


+ (NSFetchRequest *)MR_createFetchRequestInContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[self MR_entityDescriptionInContext:context]];
    
    return request;
}

+ (NSFetchRequest *) MR_createFetchRequest
{
	return [self MR_createFetchRequestInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}


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
    return [self MR_requestAllSortedBy:sortTerm
                             ascending:ascending
                         withPredicate:nil
                             inContext:context];
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
	if (searchTerm)
    {
        [request setPredicate:searchTerm];
    }
	[request setFetchBatchSize:[self MR_defaultBatchSize]];
	
    NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
    NSArray* sortKeys = [sortTerm componentsSeparatedByString:@","];
    for (NSString* sortKey in sortKeys) 
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
        [sortDescriptors addObject:sortDescriptor];
    }
    
	[request setSortDescriptors:sortDescriptors];
    
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


@end
