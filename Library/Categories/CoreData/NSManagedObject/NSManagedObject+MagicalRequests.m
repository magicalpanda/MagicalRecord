//
//  NSManagedObject+MagicalRequests.m
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObject+MagicalRequests.h"
#import "NSManagedObject+MagicalRecord.h"
#import "MagicalRecordStack.h"
#import "MagicalRecordLogging.h"

static NSUInteger defaultBatchSize = 20;

NSArray *MR_NSSortDescriptorsFromString(NSString *string, BOOL defaultAscendingValue);

@implementation NSManagedObject (MagicalRequests)

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

+ (NSFetchRequest *) MR_requestAll
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self MR_entityName]];
    return request;
}

+ (NSFetchRequest *) MR_requestAllWithPredicate:(NSPredicate *)searchTerm;
{
    NSFetchRequest *request = [self MR_requestAll];
    [request setPredicate:searchTerm];
    
    return request;
}

+ (NSFetchRequest *) MR_requestAllWhere:(NSString *)property isEqualTo:(id)value;
{
    NSFetchRequest *request = [self MR_requestAll];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", property, value]];
    
    return request;
}

+ (NSFetchRequest *) MR_requestFirstWithPredicate:(NSPredicate *)searchTerm;
{
    NSFetchRequest *request = [self MR_requestAll];
    [request setPredicate:searchTerm];
    [request setFetchLimit:1];
    
    return request;
}

+ (NSFetchRequest *) MR_requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
{
    NSFetchRequest *request = [self MR_requestAllWhere:attribute isEqualTo:searchValue];
    [request setFetchLimit:1];
    
    return request;
}

+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
{
    return [self MR_requestAllSortedBy:sortTerm
                             ascending:ascending
                         withPredicate:nil];
}

+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
{
	NSFetchRequest *request = [self MR_requestAll];
	if (searchTerm)
    {
        [request setPredicate:searchTerm];
    }
	[request setFetchBatchSize:[self MR_defaultBatchSize]];
	[request setSortDescriptors:MR_NSSortDescriptorsFromString(sortTerm, ascending)];
    
	return request;
}

@end

NSArray *MR_NSSortDescriptorsFromString(NSString *sortTerm, BOOL defaultAscendingValue)
{
    NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
    NSArray* sortKeys = [sortTerm componentsSeparatedByString:@","];

    for (__strong NSString* sortKey in sortKeys)
    {
        BOOL ascending = defaultAscendingValue;
        NSArray* sortComponents = [sortKey componentsSeparatedByString:@":"];

        sortKey = sortComponents[0];
        if ([sortComponents count] > 1)
        {
            NSNumber* customAscending = [sortComponents lastObject];
            ascending = [customAscending boolValue];
        }

        MRLogCVerbose(@"- Sorting %@ %@", sortKey, ascending ? @"Ascending": @"Descending");
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
        [sortDescriptors addObject:sortDescriptor];
    }

    return [NSArray arrayWithArray:sortDescriptors];
}
