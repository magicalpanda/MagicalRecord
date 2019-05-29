//
//  MagicalRecord+ErrorHandling.h
//  Magical Record
//
//  Created by Saul Mora on 3/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <MagicalRecord/MagicalRecordInternal.h>
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>

@interface MagicalRecord (ErrorHandling)

+ (void) handleErrors:(MR_nonnull NSError *)error;

+ (void) setErrorHandlerTarget:(MR_nullable id)target action:(MR_nonnull SEL)action;
+ (MR_nonnull SEL) errorHandlerAction;
+ (MR_nullable id) errorHandlerTarget;

@end
