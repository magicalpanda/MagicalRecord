//
//  NSError+MagicalRecordErrorHandling.h
//  Sidekick
//
//  Created by Saul Mora on 5/7/13.
//  Copyright (c) 2013 Medallion Media. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Category method to make logging to the console easier.

 @since Available in v3.0 and later.
 */
@interface NSString (MagicalRecordLogging)

/**
 Logs self to the console.

 @since Available in v3.0 and later.
 */
- (void) MR_logToConsole;

@end

/**
 Category method to make dealing with errors returned by Core Data easier.

 @since Available in v3.0 and later.
 */
@interface NSError (MagicalRecordErrorHandling)

/**
 Generates a descriptive string based upon self.

 @return String description of the error.

 @since Available in v3.0 and later.
 */
- (NSString *) MR_coreDataDescription;

@end

/**
 Checks if the supplied error code represents a validation error.

 @param errorCode Error code

 @return `YES` if the code is a validation error, otherwise `NO`.

 @since Available in v3.0 and later.
 */
BOOL MR_errorCodeIsValidationErrorCode(NSInteger errorCode);

/**
 Checks if the supplied error code represents a persistent store error.

 @param errorCode Error code

 @return `YES` if the code is a persistent store error, otherwise `NO`.

 @since Available in v3.0 and later.
 */
BOOL MR_errorCodeIsPersistentStoreErrorCode(NSInteger errorCode);

/**
 Checks if the supplied error code represents a migration error.

 @param errorCode Error code

 @return `YES` if the code is a migration error, otherwise `NO`.

 @since Available in v3.0 and later.
 */
BOOL MR_errorCodeIsMigrationErrorCode(NSInteger errorCode);

/**
 Checks if the supplied error code represents an object graph error.

 @param errorCode Error code

 @return `YES` if the code is an object graph error, otherwise `NO`.

 @since Available in v3.0 and later.
 */
BOOL MR_errorCodeIsObjectGraphErrorCode(NSInteger errorCode);

/**
 Generates a string summary from the supplied error code.

 @param errorCode Error code

 @return Summary of the supplied error code.

 @since Available in v3.0 and later.
 */
NSString *MR_errorSummaryFromErrorCode(NSInteger errorCode);
