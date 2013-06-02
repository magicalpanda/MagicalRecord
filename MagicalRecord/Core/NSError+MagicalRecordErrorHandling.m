//
//  NSError+MagicalRecordErrorHandling.m
//  Sidekick
//
//  Created by Saul Mora on 5/7/13.
//  Copyright (c) 2013 Medallion Media. All rights reserved.
//

#import "NSError+MagicalRecordErrorHandling.h"


@implementation NSString (MagicalRecordLogging)

- (void) MR_logToConsole;
{
    MRLog(@"%@", self);
}

//- (void) MR_logTo:(id)target action:(SEL)selector;
//{
//    if (target != nil && selector != nil)
//    {
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
//        [invocation setTarget:target];
//        [invocation setSelector:selector];
//        __weak id weakSelf = self;
//        [invocation setArgument:&weakSelf atIndex:2];
//        [invocation invoke];
//    }
//    else
//    {
//        NSLog(@"%@", self);
//    }
//}

@end


@implementation NSError (MagicalRecordErrorHandling)

- (NSString *) MR_coreDataDescription;
{
    NSMutableString *descriptionBuffer = [NSMutableString string];
    NSDictionary *userInfo = [self userInfo];
    for (NSArray *detailedError in [userInfo allValues])
    {
        if ([detailedError isKindOfClass:[NSArray class]])
        {
            for (NSError *e in detailedError)
            {
                if ([e respondsToSelector:@selector(userInfo)])
                {
                     [descriptionBuffer appendFormat:@"Error Details: %@", [e userInfo]];
                }
                else
                {
                    [descriptionBuffer appendFormat:@"Error Details: %@", e];
                }
            }
        }
        else
        {
            [descriptionBuffer appendFormat:@"Error: %@", detailedError];
        }
    }
    [descriptionBuffer appendFormat:@"Error Message: %@", [self localizedDescription]];
    [descriptionBuffer appendFormat:@"Error Domain: %@", [self domain]];
    [descriptionBuffer appendFormat:@"Recovery Suggestion: %@", [self localizedRecoverySuggestion]];

    return [NSString stringWithString:descriptionBuffer];
}

@end
