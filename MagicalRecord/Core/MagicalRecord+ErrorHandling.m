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
}

+ (id) errorHandlerTarget
{
    return nil;
}

+ (SEL) errorHandlerAction
{
    return nil;
}

+ (void) setErrorHandlerTarget:(id)target action:(SEL)action
{
}

+ (void) handleErrors:(NSError *)error
{
    [[error MR_coreDataDescription] MR_logToConsole];
}

- (void) handleErrors:(NSError *)error
{
    [[error MR_coreDataDescription] MR_logToConsole];
}

@end
