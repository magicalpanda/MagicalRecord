//
//  NSError+MagicalRecordErrorHandling.m
//  Sidekick
//
//  Created by Saul Mora on 5/7/13.
//  Copyright (c) 2013 Medallion Media. All rights reserved.
//

#import "NSError+MagicalRecordErrorHandling.h"


static id _errorHandlerTarget = nil;
static SEL _errorHandlerAction = nil;


@implementation NSError (MagicalRecordErrorHandling)

+ (void) MR_cleanUp;
{
    _errorHandlerAction = nil;
    _errorHandlerTarget = nil;
}

+ (id) MR_handlerTarget;
{
    return _errorHandlerTarget;
}

+ (void) MR_setHandlerTarget:(id)target;
{
    _errorHandlerTarget = target;
}

+ (SEL) MR_handlerAction;
{
    return _errorHandlerAction;
}

+ (void) MR_setHandlerAction:(SEL)action;
{
    _errorHandlerAction = action;
}

- (void) MR_log;
{
    [self MR_logTo:_errorHandlerTarget action:_errorHandlerAction];
}

- (void) MR_logTo:(id)target action:(SEL)selector;
{
    if (target != nil && selector != nil)
    {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
        [invocation setTarget:target];
        [invocation setSelector:selector];
        __weak id weakSelf = self;
        [invocation setArgument:&weakSelf atIndex:2];
        [invocation invoke];
    }
    else
    {
        [self MR_defaultLogHandler];
    }
}

- (void) MR_defaultLogHandler;
{
    NSDictionary *userInfo = [self userInfo];
    for (NSArray *detailedError in [userInfo allValues])
    {
        if ([detailedError isKindOfClass:[NSArray class]])
        {
            for (NSError *e in detailedError)
            {
                if ([e respondsToSelector:@selector(userInfo)])
                {
                    MRLog(@"Error Details: %@", [e userInfo]);
                }
                else
                {
                    MRLog(@"Error Details: %@", e);
                }
            }
        }
        else
        {
            MRLog(@"Error: %@", detailedError);
        }
    }
    MRLog(@"Error Message: %@", [self localizedDescription]);
    MRLog(@"Error Domain: %@", [self domain]);
    MRLog(@"Recovery Suggestion: %@", [self localizedRecoverySuggestion]);
}

@end
