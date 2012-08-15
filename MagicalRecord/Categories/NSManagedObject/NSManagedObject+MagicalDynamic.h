//
//  NSManagedObject+MagicalDynamic.h
//  MagicalRecord
//
//  Created by Evan Cordell on 6/23/12.
//  Copyright (c) 2012 Evan Cordell. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "JRSwizzle.h"

@interface NSManagedObject (Dynamic)

+ (id)create:(NSDictionary *)params;
+ (id)createWithBlock:(void (^) (id newObject))creationBlock;
- (BOOL)save:(NSError **)error;
+ (id)find:(NSDictionary *)params;
+ (NSArray *)findAll:(NSDictionary *)params;

@end
