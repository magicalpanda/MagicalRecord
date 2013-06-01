//
//  NSError+MagicalRecordErrorHandling.h
//  Sidekick
//
//  Created by Saul Mora on 5/7/13.
//  Copyright (c) 2013 Medallion Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (MagicalRecordErrorHandling)

+ (void) MR_setHandlerTarget:(id)target;
+ (id) MR_handlerTarget;
+ (void) MR_setHandlerAction:(SEL)action;
+ (SEL) MR_handlerAction;

- (void) MR_log;

+ (void) MR_cleanUp;

@end
