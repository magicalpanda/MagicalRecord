//
//  MagicalRecord+ErrorHandling.h
//  Magical Record
//
//  Created by Saul Mora on 3/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"

@interface MagicalRecord (ErrorHandling)

+ (void) handleErrors:(NSError *)error __attribute__((deprecated));
- (void) handleErrors:(NSError *)error __attribute__((deprecated));

+ (void) setErrorHandlerTarget:(id)target action:(SEL)action __attribute__((deprecated));
+ (SEL) errorHandlerAction __attribute__((deprecated));
+ (id) errorHandlerTarget __attribute__((deprecated));

@end
