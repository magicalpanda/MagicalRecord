//
//  NSManagedObject+MagicalAggregation.m
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordStack.h"
#import "NSManagedObject+MagicalAggregation.h"
#import "NSEntityDescription+MagicalDataImport.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSManagedObject+MagicalRequests.h"
#import "NSManagedObject+MagicalRecord.h"
#import "NSManagedObject+MagicalFinders.h"
#import "NSError+MagicalRecordErrorHandling.h"


@implementation NSManagedObject (MagicalAggregation)

#pragma mark -
#pragma mark Number of Entities

+ (NSNumber *) MR_numberOfEntitiesWithContext:(NSManagedObjectContext *)context
{
	return [NSNumber numberWithUnsignedInteger:[self MR_countOfEntitiesWithContext:context]];
}

+ (NSNumber *) MR_numberOfEntities
{
	return [self MR_numberOfEntitiesWithContext:[[MagicalRecordStack defaultStack] context]];
}

+ (NSNumber *) MR_numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    
	return [NSNumber numberWithUnsignedInteger:[self MR_countOfEntitiesWithPredicate:searchTerm inContext:context]];
}

+ (NSNumber *) MR_numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm;
{
	return [self MR_numberOfEntitiesWithPredicate:searchTerm
                                        inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (NSUInteger) MR_countOfEntities;
{
    return [self MR_countOfEntitiesWithContext:[[MagicalRecordStack defaultStack] context]];
}

+ (NSUInteger) MR_countOfEntitiesWithContext:(NSManagedObjectContext *)context;
{
	NSError *error = nil;
	NSUInteger count = [context countForFetchRequest:[self MR_requestAll] error:&error];
    [[error MR_coreDataDescription] MR_logToConsole];

    return count;
}

+ (NSUInteger) MR_countOfEntitiesWithPredicate:(NSPredicate *)searchFilter;
{
    return [self MR_countOfEntitiesWithPredicate:searchFilter inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (NSUInteger) MR_countOfEntitiesWithPredicate:(NSPredicate *)searchFilter inContext:(NSManagedObjectContext *)context;
{
	NSError *error = nil;
	NSFetchRequest *request = [self MR_requestAll];
	[request setPredicate:searchFilter];
	
	NSUInteger count = [context countForFetchRequest:request error:&error];
    [[error MR_coreDataDescription] MR_logToConsole];

    return count;
}

+ (BOOL) MR_hasAtLeastOneEntity
{
    return [self MR_hasAtLeastOneEntityInContext:[[MagicalRecordStack defaultStack] context]];
}

+ (BOOL) MR_hasAtLeastOneEntityInContext:(NSManagedObjectContext *)context
{
    return [[self MR_numberOfEntitiesWithContext:context] intValue] > 0;
}

- (NSNumber *) MR_maxValueFor:(NSString *)property
{
	NSManagedObject *obj = [[self class] MR_findFirstByAttribute:property
                                                       withValue:[NSString stringWithFormat:@"max(%@)", property]];
	
	return [obj valueForKey:property];
}

- (id) MR_objectWithMinValueFor:(NSString *)property inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [[self class] MR_requestAll];
    
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
    NSAttributeDescription *attributeDescription = [[self MR_entityDescription] MR_attributeDescriptionForName:attributeName];
    [ed setExpressionResultType:[attributeDescription attributeType]];    
    NSArray *properties = [NSArray arrayWithObject:ed];
    
    NSFetchRequest *request = [self MR_requestAllWithPredicate:predicate];
    [request setPropertiesToFetch:properties];
    [request setResultType:NSDictionaryResultType];    
    
    NSDictionary *resultsDictionary = [self MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
    NSNumber *resultValue = [resultsDictionary objectForKey:@"result"];
    
    return resultValue;    
}

+ (NSNumber *) MR_aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate 
{
    return [self MR_aggregateOperation:function 
                           onAttribute:attributeName 
                         withPredicate:predicate
                             inContext:[[MagicalRecordStack defaultStack] context]];
}

@end
