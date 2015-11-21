//
//  Copyright © 2013 Magical Panda Software, LLC. All rights reserved.

#import <Foundation/Foundation.h>

@interface MagicalMigrationManager : NSObject

@property (readwrite, nonnull, nonatomic, copy) NSString *sourceModelName;
@property (readwrite, nonnull, nonatomic, copy) NSString *targetModelName;
@property (readwrite, nonnull, nonatomic, copy) NSString *versionedModelName;

- (nonnull instancetype)initWithSourceModelName:(nonnull NSString *)sourceName targetModelName:(nonnull NSString *)targetName;

- (BOOL)migrateStoreAtURL:(nonnull NSURL *)sourceStoreURL toStoreAtURL:(nonnull NSURL *)targetStoreURL;
- (BOOL)migrateStoreAtURL:(nonnull NSURL *)sourceStoreURL toStoreAtURL:(nonnull NSURL *)targetStoreURL mappingModelURL:(nullable NSURL *)mappingModelURL;

@end
