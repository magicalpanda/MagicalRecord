//
//  ARCoreDataAction.h
//  Freshpod
//
//  Created by Saul Mora on 2/24/11.
//  Copyright 2011 Magical Panda Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ARCoreDataAction : NSObject {}

#ifdef NS_BLOCKS_AVAILABLE

+ (void) saveDataWithBlock:(void(^)(NSManagedObjectContext *localContext))block;
+ (void) saveDataInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block;
+ (void) saveDataInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(void(^)(void))callback;

+ (void) lookupWithBlock:(void(^)(NSManagedObjectContext *localContext))block;

#endif


@end
