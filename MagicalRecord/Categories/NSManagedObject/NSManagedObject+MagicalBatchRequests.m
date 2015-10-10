//
//  NSManagedObject+MagicalBatchRequests.m
//  Magical Record
//
//  Created by Andrej Mihajlov on 10/9/15.
//  Copyright (c) 2015 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObject+MagicalBatchRequests.h"
#import "NSManagedObject+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalThreading.h"
#import "MagicalRecord+ErrorHandling.h"

@implementation NSManagedObject (MagicalBatchRequests)

+ (NSBatchUpdateRequest *)MR_createBatchUpdateRequest {
    return [NSBatchUpdateRequest batchUpdateRequestWithEntityName:[self MR_entityName]];
}

+ (NSBatchUpdateResult *)MR_executeBatchUpdateRequest:(NSBatchUpdateRequest *)request {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self MR_executeBatchUpdateRequest:request inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
#pragma clang diagnostic pop
}

+ (NSBatchUpdateResult *)MR_executeBatchUpdateRequest:(NSBatchUpdateRequest *)request inContext:(NSManagedObjectContext *)context {
    NSError *error;
    NSBatchUpdateResult *result = (NSBatchUpdateResult *)[context executeRequest:request error:&error];
    
    [MagicalRecord handleErrors:error];
    
    return result;
}

+ (NSBatchUpdateRequest *)MR_batchUpdateRequestForAllMatchingPredicate:(NSPredicate *)predicate withPropertiesForUpdate:(NSDictionary *)properties {
    NSBatchUpdateRequest *request = [self MR_createBatchUpdateRequest];
    request.predicate = predicate;
    request.propertiesToUpdate = properties;
    
    return request;
}

+ (NSBatchUpdateRequest *)MR_batchUpdateRequestForAllWhere:(NSString *)key isEqualTo:(id)value withPropertiesForUpdate:(NSDictionary *)properties {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", key, value];
    
    return [self MR_batchUpdateRequestForAllMatchingPredicate:predicate withPropertiesForUpdate:properties];
}

+ (void)MR_batchUpdateAllMatchingPredicate:(NSPredicate *)predicate withPropertiesForUpdate:(NSDictionary *)properties {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [self MR_batchUpdateAllMatchingPredicate:predicate withPropertiesForUpdate:properties inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
#pragma clang diagnostic pop
}

+ (void)MR_batchUpdateAllMatchingPredicate:(NSPredicate *)predicate withPropertiesForUpdate:(NSDictionary *)properties inContext:(NSManagedObjectContext *)context {
    NSBatchUpdateRequest *request = [self MR_batchUpdateRequestForAllMatchingPredicate:predicate withPropertiesForUpdate:properties];
    
    [self MR_executeBatchUpdateRequest:request inContext:context];
}

+ (void)MR_batchUpdateAllWhere:(NSString *)key isEqualTo:(id)value withPropertiesForUpdate:(NSDictionary *)properties {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self MR_batchUpdateAllWhere:key isEqualTo:value withPropertiesForUpdate:properties inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    #pragma clang diagnostic pop
}

+ (void)MR_batchUpdateAllWhere:(NSString *)key isEqualTo:(id)value withPropertiesForUpdate:(NSDictionary *)properties inContext:(NSManagedObjectContext *)context {
    NSBatchUpdateRequest *request = [self MR_batchUpdateRequestForAllWhere:key isEqualTo:value withPropertiesForUpdate:properties];
    
    [self MR_executeBatchUpdateRequest:request inContext:context];
}

@end
