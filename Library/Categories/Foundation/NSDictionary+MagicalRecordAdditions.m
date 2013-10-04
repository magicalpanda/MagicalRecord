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

- (NSMutableDictionary *) MR_dictionaryByMergingDictionary:(NSDictionary *)d;
{
    NSMutableDictionary *mutDict = [self mutableCopy];
    [mutDict addEntriesFromDictionary:d];
    return mutDict;
}

+ (NSDictionary *) MR_defaultSqliteStoreOptions;
{
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:@"WAL" forKey:@"journal_mode"];

    return options;
}

+ (NSDictionary *) MR_autoMigrationOptions;
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];
    return options;
}

+ (NSDictionary *) MR_manualMigrationOptions;
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:NO], NSInferMappingModelAutomaticallyOption,
                             nil];
    return options;
}

- (BOOL) MR_shouldDeletePersistentStoreOnModelMismatch;
{
    id value = [self valueForKey:MagicalRecordShouldDeletePersistentStoreOnModelMismatchKey];
    return [value boolValue];
}

@end
