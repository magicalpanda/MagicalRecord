//
//  SQLiteMagicalRecordStack.h
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordStack.h"

@interface SQLiteMagicalRecordStack : MagicalRecordStack

/*!
 @property shouldDeletePersistentStoreOnModelMistmatch
 @abstract If true, when configuring the persistant store coordinator, and Magical Record encounters a store that does not match the model, it will attempt to remove it and re-create a new store.
 This is extremely useful during development where every model change could potentially require a delete/reinstall of the app.
 */

@property (nonatomic, assign) BOOL shouldDeletePersistentStoreOnModelMismatch;

@property (nonatomic, copy, readwrite) NSDictionary *storeOptions;
@property (nonatomic, copy, readonly) NSURL *storeURL;

+ (instancetype) stackWithStoreNamed:(NSString *)name model:(NSManagedObjectModel *)model;
+ (instancetype) stackWithStoreAtURL:(NSURL *)url model:(NSManagedObjectModel *)model;
+ (instancetype) stackWithStoreAtPath:(NSString *)path model:(NSManagedObjectModel *)model;

+ (instancetype) stackWithStoreNamed:(NSString *)name;
+ (instancetype) stackWithStoreAtURL:(NSURL *)url;
+ (instancetype) stackWithStoreAtPath:(NSString *)path;

- (instancetype) initWithStoreNamed:(NSString *)name model:(NSManagedObjectModel *)model;
- (instancetype) initWithStoreAtURL:(NSURL *)url model:(NSManagedObjectModel *)model;
- (instancetype) initWithStoreAtPath:(NSString *)path model:(NSManagedObjectModel *)model;

- (instancetype) initWithStoreNamed:(NSString *)name;
- (instancetype) initWithStoreAtURL:(NSURL *)url;
- (instancetype) initWithStoreAtPath:(NSString *)path;

- (NSDictionary *) defaultStoreOptions;

@end
