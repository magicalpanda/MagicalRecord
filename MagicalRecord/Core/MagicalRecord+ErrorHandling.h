//
//  MagicalRecord+ErrorHandling.h
//  Magical Record
//
//  Created by Saul Mora on 3/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#if __has_include(<MagicalRecord/MagicalRecord.h>)
#import <MagicalRecord/MagicalRecordInternal.h>
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>
#else
#import "MagicalRecordInternal.h"
#import "MagicalRecordXcode7CompatibilityMacros.h"
#endif

@interface MagicalRecord (ErrorHandling)

+ (void) handleErrors:(MR_nonnull NSError *)error;
- (void) handleErrors:(MR_nonnull NSError *)error;

+ (void) setErrorHandlerTarget:(MR_nullable id)target action:(MR_nonnull SEL)action;
+ (MR_nonnull SEL) errorHandlerAction;
+ (MR_nullable id) errorHandlerTarget;

@end
