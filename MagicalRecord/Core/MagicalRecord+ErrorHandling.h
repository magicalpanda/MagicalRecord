//
//  MagicalRecord+ErrorHandling.h
//  Magical Record
//
//  Created by Saul Mora on 3/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"

@interface MagicalRecord (ErrorHandling)

+ (void) handleErrors:(NSError *)error __deprecated;
- (void) handleErrors:(NSError *)error __deprecated;

+ (void) setErrorHandlerTarget:(id)target action:(SEL)action __deprecated;
+ (SEL) errorHandlerAction __deprecated;
+ (id) errorHandlerTarget __deprecated;

@end
