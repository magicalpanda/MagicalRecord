//
//  MagicalFactory.h
//  MagicalRecord
//
//  Created by Saul Mora on 6/19/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRFactoryObject.h"

@interface MagicalFactory : NSObject

+ (void) resetAll;

+ (NSSet *) factories;

+ (void) define:(id)stringOrClass do:(void(^)(id<MRFactoryObject>))configurationBlock;
+ (void) define:(id)stringOrClass as:(NSString *)alias do:(void (^)(id<MRFactoryObject>))configurationBlock;

@end
