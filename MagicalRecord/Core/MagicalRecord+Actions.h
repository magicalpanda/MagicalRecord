//
//  ARCoreDataAction.h
//  Freshpod
//
//  Created by Saul Mora on 2/24/11.
//  Copyright 2011 Magical Panda Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSManagedObjectContext+MagicalRecord.h"

@interface MagicalRecord (Actions)

+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;

+ (void) saveInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block;
+ (void) saveInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(void(^)(void))callback;

@end
