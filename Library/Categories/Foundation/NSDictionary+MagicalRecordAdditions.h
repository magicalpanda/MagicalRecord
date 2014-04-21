//
//  NSDictionary+MagicalRecordAdditions.h
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 NSDictionary category methods to support various aspects of MagicalRecord.

 @since Available in v3.0 and later.
 */
@interface NSDictionary (MagicalRecordAdditions)

/**
 Adds the entries from another dictionary into this dictionary.

 @param dictionary Another dictionary instance

 @return Dictionary containing entries from both dictionaries.
 */
- (NSMutableDictionary *) MR_dictionaryByMergingDictionary:(NSDictionary *)dictionary;

/**
 Default SQLite store options for setting up a persistent store.

 @return Dictionary containing default options for a SQLite-based store.
 */
+ (NSDictionary *) MR_defaultSqliteStoreOptions;

/**
 Setup options for a persistent store that specify that the store should be automatically migrated if possible.

 @return Dictionary containing options for a persistent store.
 */
+ (NSDictionary *) MR_autoMigrationOptions;

/**
 Setup options for a persistent store that specify that the store should not be automatically migrated.

 @return Dictionary containing options for a persistent store.
 */
+ (NSDictionary *) MR_manualMigrationOptions;

/**
 Convenience method to read the value for the `MagicalRecordShouldDeletePersistentStoreOnModelMismatchKey` key from self and return the value as a BOOL.

 @return BOOL value for key.
 */
- (BOOL) MR_shouldDeletePersistentStoreOnModelMismatch;

@end
