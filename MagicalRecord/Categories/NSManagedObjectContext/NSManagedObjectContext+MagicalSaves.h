//
//  NSManagedObjectContext+MagicalSaves.h
//  Magical Record
//
//  Created by Saul Mora on 3/9/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef NS_OPTIONS(NSUInteger, MRSaveContextOptions) {
    MRSaveParentContexts = 1,
    MRSaveSynchronously = 2
};

typedef void (^MRSaveCompletionHandler)(BOOL success, NSError *error);

@interface NSManagedObjectContext (MagicalSaves)

// Asynchronous saving
- (void) MR_saveOnlySelfWithCompletion:(MRSaveCompletionHandler)completion;
- (void) MR_saveToPersistentStoreWithCompletion:(MRSaveCompletionHandler)completion;

// Synchronous saving
- (void) MR_saveOnlySelfAndWait;
- (void) MR_saveToPersistentStoreAndWait;

// Save with options
- (void) MR_saveWithOptions:(MRSaveContextOptions)mask completion:(MRSaveCompletionHandler)completion;

/* DEPRECATION NOTICE:
 * The following methods are deprecated, but remain in place for backwards compatibility until the next major version (3.x)
 */
- (void) MR_save __attribute__((deprecated));
- (void) MR_saveWithErrorCallback:(void(^)(NSError *error))errorCallback __attribute__((deprecated));

- (void) MR_saveInBackgroundCompletion:(void (^)(void))completion __attribute__((deprecated));
- (void) MR_saveInBackgroundErrorHandler:(void (^)(NSError *error))errorCallback __attribute__((deprecated));
- (void) MR_saveInBackgroundErrorHandler:(void (^)(NSError *error))errorCallback completion:(void (^)(void))completion __attribute__((deprecated));

- (void) MR_saveNestedContexts __attribute__((deprecated));
- (void) MR_saveNestedContextsErrorHandler:(void (^)(NSError *error))errorCallback __attribute__((deprecated));
- (void) MR_saveNestedContextsErrorHandler:(void (^)(NSError *error))errorCallback completion:(void (^)(void))completion __attribute__((deprecated));

@end
