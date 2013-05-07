//
//  MagicalRecord+ErrorHandling.m
//  Magical Record
//
//  Created by Saul Mora on 3/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord+ErrorHandling.h"
#import "NSError+MagicalRecordErrorHandling.h"


static id errorHandlerTarget = nil;
static SEL errorHandlerAction = nil;


@implementation MagicalRecord (ErrorHandling)

+ (void) cleanUpErrorHanding;
{
    errorHandlerTarget = nil;
    errorHandlerAction = nil;
    [NSError MR_cleanUp];
}

+ (id) errorHandlerTarget
{
    return [NSError MR_handlerTarget];
}

+ (SEL) errorHandlerAction
{
    return [NSError MR_handlerAction];
}

+ (void) setErrorHandlerTarget:(id)target action:(SEL)action
{
    [NSError MR_setHandlerTarget:target];
    [NSError MR_setHandlerAction:action];
}

+ (void) handleErrors:(NSError *)error
{
    [error MR_log];
}

- (void) handleErrors:(NSError *)error
{
    [error MR_log];
}

@end
