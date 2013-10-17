//
//  NSDictionary+MagicalRecordAdditions.h
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MagicalRecordAdditions)

- (NSMutableDictionary *) MR_dictionaryByMergingDictionary:(NSDictionary *)other;
+ (NSDictionary *) MR_defaultSqliteStoreOptions;
+ (NSDictionary *) MR_manualMigrationOptions;
+ (NSDictionary *) MR_autoMigrationOptions;

- (BOOL) MR_shouldDeletePersistentStoreOnModelMismatch;

@end
