//
//  NSManagedObjectContext+MagicalSaves.h
//  Magical Record
//
//  Created by Saul Mora on 3/9/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (MagicalSaves)

- (void) MR_save;
- (void) MR_saveErrorHandler:(void (^)(NSError *))errorCallback;

- (void) MR_saveInBackground;
- (void) MR_saveInBackgroundErrorHandler:(void (^)(NSError *))errorCallback;

- (void) MR_saveNestedContexts;
- (void) MR_saveNestedContextsErrorHandler:(void (^)(NSError *))errorCallback;

@end
