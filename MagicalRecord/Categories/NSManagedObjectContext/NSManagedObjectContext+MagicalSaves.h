//
//  NSManagedObjectContext+MagicalSaves.h
//  Magical Record
//
//  Created by Saul Mora on 3/9/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MagicalRecordDeprecated.h"

typedef NS_OPTIONS(NSUInteger, MRSaveContextOptions) {
    MRSaveWithoutOptions                = 0,        ///< No options — used for cleanliness only
    MRSaveParentContexts                = 1 << 1,   ///< When saving, continue saving parent contexts until the changes are present in the persistent store
    MRSaveSynchronously                 = 1 << 2,   ///< Perform saves synchronously, blocking execution on the current thread until the save is complete
    MRSaveAllSynchronouslyExceptRoot    = 1 << 3    ///< Perform saves synchronously, blocking execution on the current thread until the save is complete; however, save root context asynchronously
};

typedef void (^MRSaveCompletionHandler)(BOOL success, NSError *error);

@interface NSManagedObjectContext (MagicalSaves)

/// \brief      Asynchronously save changes in the current context and it's parent
/// \param       completion  Completion block that is called after the save has completed. The block is passed a success state as a `BOOL` and an `NSError` instance if an error occurs. Always called on the main queue.
/// \discussion Executes a save on the current context's dispatch queue asynchronously. This method only saves the current context, and the parent of the current context if one is set. The completion block will always be called on the main queue.
- (void) MR_saveOnlySelfWithCompletion:(MRSaveCompletionHandler)completion;

/// \brief      Asynchronously save changes in the current context all the way back to the persistent store
/// \param       completion  Completion block that is called after the save has completed. The block is passed a success state as a `BOOL` and an `NSError` instance if an error occurs. Always called on the main queue.
/// \discussion Executes asynchronous saves on the current context, and any ancestors, until the changes have been persisted to the assigned persistent store. The completion block will always be called on the main queue.
- (void) MR_saveToPersistentStoreWithCompletion:(MRSaveCompletionHandler)completion;

/// \brief      Synchronously save changes in the current context and it's parent
/// \discussion Executes a save on the current context's dispatch queue. This method only saves the current context, and the parent of the current context if one is set. The method will not return until the save is complete.
- (void) MR_saveOnlySelfAndWait;

/// \brief      Synchronously save changes in the current context all the way back to the persistent store
/// \discussion Executes saves on the current context, and any ancestors, until the changes have been persisted to the assigned persistent store. The method will not return until the save is complete.
- (void) MR_saveToPersistentStoreAndWait;

/// \brief       Save the current context with options
/// \param       mask        bitmasked options for the save process
/// \param       completion  Completion block that is called after the save has completed. The block is passed a success state as a `BOOL` and an `NSError` instance if an error occurs. Always called on the main queue.
/// \discussion  All other save methods are conveniences to this method.
- (void) MR_saveWithOptions:(MRSaveContextOptions)mask completion:(MRSaveCompletionHandler)completion;


/* DEPRECATION NOTICE:
 * The following methods are deprecated, but remain in place for backwards compatibility until the next major version (3.x)
 */

/// \brief      Synchronously save changes in the current context all the way back to the persistent store
/// \discussion Replaced by \MR_saveToPersistentStoreAndWait
/// \deprecated
- (void) MR_save MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0_USE("Please use MR_saveToPersistentStoreAndWait instead.");

/// \brief      Synchronously save changes in the current context all the way back to the persistent store
/// \param      errorCallback Block that is called if an error is encountered while saving. Always called on the main thread.
/// \deprecated
- (void) MR_saveWithErrorCallback:(void(^)(NSError *error))errorCallback MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0;

/// \brief      Asynchronously save changes in the current context and it's parent
/// \param      completion  Completion block that is called after the save has completed. Always called on the main queue.
/// \deprecated
- (void) MR_saveInBackgroundCompletion:(void (^)(void))completion MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0;

/// \brief      Asynchronously save changes in the current context and it's parent
/// \param      errorCallback Block that is called if an error is encountered while saving. Always called on the main thread.
/// \deprecated
- (void) MR_saveInBackgroundErrorHandler:(void (^)(NSError *error))errorCallback MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0;

/// \brief      Asynchronously save changes in the current context and it's parent
/// \param      errorCallback Block that is called if an error is encountered while saving. Always called on the main thread.
/// \param      completion  Completion block that is called after the save has completed. Always called on the main queue.
/// \deprecated
- (void) MR_saveInBackgroundErrorHandler:(void (^)(NSError *error))errorCallback completion:(void (^)(void))completion MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0;

/// \brief      Asynchronously save changes in the current context all the way back to the persistent store
/// \discussion Replaced by \MR_saveToPersistentStoreWithCompletion:
/// \deprecated
- (void) MR_saveNestedContexts MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0_USE("Please use MR_saveToPersistentStoreWithCompletion: instead.");

/// \brief      Asynchronously save changes in the current context all the way back to the persistent store
/// \param      errorCallback Block that is called if an error is encountered while saving. Always called on the main thread.
/// \discussion Replaced by \MR_saveToPersistentStoreWithCompletion:
/// \deprecated
- (void) MR_saveNestedContextsErrorHandler:(void (^)(NSError *error))errorCallback MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0_USE("Please use MR_saveToPersistentStoreWithCompletion: instead.");

/// \brief      Asynchronously save changes in the current context all the way back to the persistent store
/// \param      errorCallback Block that is called if an error is encountered while saving. Always called on the main thread.
/// \param      completion  Completion block that is called after the save has completed. Always called on the main queue.
/// \discussion Replaced by \MR_saveToPersistentStoreWithCompletion:
/// \deprecated
- (void) MR_saveNestedContextsErrorHandler:(void (^)(NSError *error))errorCallback completion:(void (^)(void))completion MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0_USE("Please use MR_saveToPersistentStoreWithCompletion: instead.");

@end
