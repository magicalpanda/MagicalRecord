//
//  MagicalMigrationManager.h
//  Photobucket Next
//
//  Created by Saul Mora on 8/6/13.
//  Copyright (c) 2013 Photobucket. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MagicalMigrationManager : NSObject

@property (nonatomic, copy) NSString *sourceModelName;
@property (nonatomic, copy) NSString *targetModelName;
@property (nonatomic, copy) NSString *versionedModelName;

- (instancetype) initWithSourceModelName:(NSString *)sourceName targetModelName:(NSString *)targetName;

- (BOOL) migrateStoreAtURL:(NSURL *)sourceStoreURL toStoreAtURL:(NSURL *)targetStoreURL;
- (BOOL) migrateStoreAtURL:(NSURL *)sourceStoreURL toStoreAtURL:(NSURL *)targetStoreURL mappingModelURL:(NSURL *)mappingModelURL;
- (BOOL) migrateStoreAtURL:(NSURL *)sourceStoreURL toStoreAtURL:(NSURL *)targetStoreURL mappingModelURL:(NSURL *)mappingModelURL progressiveMigration:(BOOL)progressiveMigration;

@end


