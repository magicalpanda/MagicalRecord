//
//  NSError+MagicalRecordErrorHandling.h
//  Sidekick
//
//  Created by Saul Mora on 5/7/13.
//  Copyright (c) 2013 Medallion Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MagicalRecordLogging)

- (void) MR_logToConsole;

@end


@interface NSError (MagicalRecordErrorHandling)

- (NSString *) MR_coreDataDescription;

@end

BOOL MR_errorCodeIsValidationErrorCode(NSInteger errorCode);
BOOL MR_errorCodeIsPersistentStoreErrorCode(NSInteger errorCode);
BOOL MR_errorCodeIsMigrationErrorCode(NSInteger errorCode);
BOOL MR_errorCodeIsObjectGraphErrorCode(NSInteger errorCode);

NSString *MR_errorSummaryFromErrorCode(NSInteger errorCode);
