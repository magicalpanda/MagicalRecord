//
//  NSManagedObjectContext+MagicalChainSave.h
//  Magical Record
//
//  Created by Lee on 8/27/14.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NSManagedObjectContext+MagicalSaves.h"
#import "MagicalRecordXcode7CompatibilityMacros.h"

@interface NSManagedObjectContext (MagicalRecordChainSave)
/**
 Creates a child context for the current context that you can make changes within, before saving up through all parent contexts to the main queue context, and finally to the saving context. This method will return immediately, and execute the save initially on a background thread, and then on the appropriate thread for each context it saves.

 @param block Block that is passed a managed object context.
*/
- (void)MR_saveWithBlock:(void (^ __MR_nonnull)(NSManagedObjectContext * __MR_nonnull localContext))block;

/**
 Creates a child context for the current context that you can make changes within, before saving up through all parent contexts to the main queue context, and finally to the saving context. This method will return immediately, and execute the save initially on a background thread, and then on the appropriate thread for each context it saves.

 @param block      Block that is passed a managed object context.
 @param completion Completion block that is called once all contexts have been saved, or if an error is encountered.
 */
- (void)MR_saveWithBlock:(void (^ __MR_nonnull)(NSManagedObjectContext * __MR_nonnull localContext))block completion:(MR_nullable MRSaveCompletionHandler)completion;

/**
 Creates a child context for the current context that you can make changes within, before saving up through all parent contexts to the main queue context, and finally to the saving context. This method will not return until the save has completed, blocking the thread it is called on.

 @param block Block that is passed a managed object context.
 */
- (void)MR_saveWithBlockAndWait:(void (^ __MR_nonnull)(NSManagedObjectContext * __MR_nonnull localContext))block;

@end
