//
//  MagicalFactory.h
//  MagicalRecord
//
//  Created by Saul Mora on 6/19/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRFactoryObjectDefinition.h"

@interface MagicalFactory : NSObject

+ (void) define:(Class)klass do:(void(^)(id<MRFactoryObject>))configurationBlock;

@end
