//
//  NSManagedObjectContext+MagicalSaves.h
//  Magical Record
//
//  Created by Saul Mora on 3/9/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (MagicalSaves)

- (BOOL) MR_save;

#ifdef NS_BLOCKS_AVAILABLE
- (BOOL) MR_saveWithErrorHandler:(void (^)(NSError *))errorCallback;
#endif

- (BOOL) MR_saveOnMainThread;
- (BOOL) MR_saveOnBackgroundThread;


@end
