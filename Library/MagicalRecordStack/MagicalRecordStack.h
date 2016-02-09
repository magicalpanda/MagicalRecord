//
//  Copyright © 2013 Magical Panda Software LLC. All rights reserved.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MagicalRecordDeprecated.h"

@interface MagicalRecordStack : NSObject

@property (readwrite, nonnull, nonatomic, copy) NSString *stackName;

@property (readwrite, null_resettable, nonatomic, strong) NSManagedObjectContext *context;
@property (readwrite, nonnull, nonatomic, strong) NSManagedObjectModel *model;
@property (readwrite, nonnull, nonatomic, strong) NSPersistentStoreCoordinator *coordinator;
@property (readwrite, nullable, nonatomic, strong) NSPersistentStore *store;

@property (readwrite, nonatomic, assign) BOOL loggingEnabled;
@property (readwrite, nonatomic, assign) BOOL saveOnApplicationWillTerminate;
@property (readwrite, nonatomic, assign) BOOL saveOnApplicationWillResignActive;

+ (nonnull instancetype)defaultStack;
+ (void)setDefaultStack:(nullable MagicalRecordStack *)stack;

+ (nonnull instancetype)stack;

- (nonnull NSManagedObjectContext *)newMainQueueContext;
- (nonnull NSManagedObjectContext *)newPrivateQueueContext;

- (void)setModelFromClass:(nonnull Class)modelClass;
- (void)setModelNamed:(nonnull NSString *)modelName;

@end

@interface MagicalRecordStack (MagicalRecordDeprecated)

/**
 Does nothing in MagicalRecord 3.
 
 @note Please deallocate the stack and create a new one rather than trying to reuse the existing instance.
 */
- (void)reset MR_DEPRECATED_WILL_BE_REMOVED_IN("4.0");
- (nonnull NSManagedObjectContext *)newConfinementContext MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "a context with a type of `NSPrivateQueueConcurrencyType` or `NSMainQueueConcurrencyType`");

@end
