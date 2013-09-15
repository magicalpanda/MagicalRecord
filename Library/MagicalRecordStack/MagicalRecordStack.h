//
//  MagicalRecordStack.h
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MagicalRecordStack : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, strong) NSPersistentStore *store;

+ (instancetype) defaultStack;
+ (void) setDefaultStack:(MagicalRecordStack *)stack;

+ (instancetype) stack;

- (void) reset;

- (NSPersistentStoreCoordinator *) createCoordinator;
- (void) setModelFromClass:(Class)klass;
- (void) setModelNamed:(NSString *)modelName;

@end
