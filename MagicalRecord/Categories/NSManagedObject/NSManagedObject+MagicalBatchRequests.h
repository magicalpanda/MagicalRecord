//
//  NSManagedObject+MagicalBatchRequests.h
//  Magical Record
//
//  Created by Andrej Mihajlov on 10/9/15.
//  Copyright (c) 2015 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (MagicalBatchRequests)

+ (NSBatchUpdateRequest *)MR_createBatchUpdateRequest;

+ (NSBatchUpdateResult *)MR_executeBatchUpdateRequest:(NSBatchUpdateRequest *)request;
+ (NSBatchUpdateResult *)MR_executeBatchUpdateRequest:(NSBatchUpdateRequest *)request inContext:(NSManagedObjectContext *)context;

+ (NSBatchUpdateRequest *)MR_batchUpdateRequestForAllMatchingPredicate:(NSPredicate *)predicate withPropertiesForUpdate:(NSDictionary *)properties;
+ (NSBatchUpdateRequest *)MR_batchUpdateRequestForAllWhere:(NSString *)key isEqualTo:(id)value withPropertiesForUpdate:(NSDictionary *)properties;

+ (void)MR_batchUpdateAllMatchingPredicate:(NSPredicate *)predicate withPropertiesForUpdate:(NSDictionary *)properties;
+ (void)MR_batchUpdateAllMatchingPredicate:(NSPredicate *)predicate withPropertiesForUpdate:(NSDictionary *)properties inContext:(NSManagedObjectContext *)context;

+ (void)MR_batchUpdateAllWhere:(NSString *)key isEqualTo:(id)value withPropertiesForUpdate:(NSDictionary *)properties;
+ (void)MR_batchUpdateAllWhere:(NSString *)key isEqualTo:(id)value withPropertiesForUpdate:(NSDictionary *)properties inContext:(NSManagedObjectContext *)context;

@end
