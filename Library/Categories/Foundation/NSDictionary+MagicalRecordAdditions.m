//
//  NSDictionary+MagicalRecordAdditions.m
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "NSDictionary+MagicalRecordAdditions.h"
#import "NSPersistentStoreCoordinator+MagicalRecord.h"

@implementation NSDictionary (MagicalRecordAdditions)

- (NSMutableDictionary *) MR_dictionaryByMergingDictionary:(NSDictionary *)dictionary;
{
    NSMutableDictionary *mutDict = [self mutableCopy];
    [mutDict addEntriesFromDictionary:dictionary];
    return mutDict;
}

+ (NSDictionary *) MR_defaultSqliteStoreOptions;
{
    return @{ @"journal_mode" : @"WAL" };
}

+ (NSDictionary *) MR_autoMigrationOptions;
{
    return @{ NSMigratePersistentStoresAutomaticallyOption : @YES,
              NSInferMappingModelAutomaticallyOption : @YES };
}

+ (NSDictionary *) MR_manualMigrationOptions;
{
    return @{ NSMigratePersistentStoresAutomaticallyOption : @YES,
              NSInferMappingModelAutomaticallyOption : @NO };
}

- (BOOL) MR_shouldDeletePersistentStoreOnModelMismatch;
{
    id value = [self valueForKey:MagicalRecordShouldDeletePersistentStoreOnModelMismatchKey];
    return [value boolValue];
}

@end
