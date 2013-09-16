//
//  NSManagedObjectContext+MagicalSaves.h
//  Magical Record
//
//  Created by Saul Mora on 3/9/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef NS_OPTIONS(NSUInteger, MRSaveContextOptions) {
    MRSaveParentContexts = 1 << 0,   ///< When saving, continue saving parent contexts until the changes are present in the persistent store
    MRSaveSynchronously = 1 << 1     ///< Peform saves synchronously, blocking execution on the current thread until the save is complete
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

@end
