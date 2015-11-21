//
//  Copyright © 2013 Magical Panda Software LLC. All rights reserved.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MagicalRecordStack : NSObject

@property (readwrite, nonnull, nonatomic, copy) NSString *stackName;

@property (readwrite, nonnull, nonatomic, strong) NSManagedObjectContext *context;
@property (readwrite, nonnull, nonatomic, strong) NSManagedObjectModel *model;
@property (readwrite, nonnull, nonatomic, strong) NSPersistentStoreCoordinator *coordinator;
@property (readwrite, nullable, nonatomic, strong) NSPersistentStore *store;

@property (readwrite, nonatomic, assign) BOOL loggingEnabled;
@property (readwrite, nonatomic, assign) BOOL saveOnApplicationWillTerminate;
@property (readwrite, nonatomic, assign) BOOL saveOnApplicationWillResignActive;

+ (nonnull instancetype)defaultStack;
+ (void)setDefaultStack:(nullable MagicalRecordStack *)stack;

+ (nonnull instancetype)stack;

- (void)reset;

- (nonnull NSManagedObjectContext *)newConfinementContext;

- (void)setModelFromClass:(nonnull Class)modelClass;
- (void)setModelNamed:(nonnull NSString *)modelName;

@end
