//
//  NSError+MagicalRecordErrorHandling.m
//  Sidekick
//
//  Created by Saul Mora on 5/7/13.
//  Copyright (c) 2013 Medallion Media. All rights reserved.
//

#import "NSError+MagicalRecordErrorHandling.h"
#import "MagicalRecord.h"


NSString *MR_errorSummaryFromErrorCode(NSInteger errorCode)
{
    switch (errorCode)
    {
        case NSManagedObjectValidationError:
        case NSValidationMultipleErrorsError:
            return @"General Validation Error";
            
        case NSValidationMissingMandatoryPropertyError:
            return @"Missing Mandiatory Property";
            
        case NSValidationRelationshipLacksMinimumCountError:
            return @"Relationship Lacks Minimum Count";
            
        case NSValidationRelationshipExceedsMaximumCountError:
            return @"Relationship Exceeds Maximum Count";
            
        case NSValidationRelationshipDeniedDeleteError:
            return @"Relationship Denied Delete";
            
        case NSValidationNumberTooLargeError:
            return @"Number too Large";
            
        case NSValidationNumberTooSmallError:
            return @"Number too Small";
            
        case NSValidationDateTooLateError:
            return @"Date too Late";
            
        case NSValidationDateTooSoonError:
            return @"Date too Soon";
            
        case NSValidationInvalidDateError:
            return @"Invalid Date";
            
        case NSValidationStringTooLongError:
            return @"String too Long";
            
        case NSValidationStringTooShortError:
            return @"String too Short";
            
        case NSValidationStringPatternMatchingError:
            return @"String Pattering Matching Error";
            
        default:
            return @"Unknown Core Data Error";
    }
}

BOOL MR_errorCodeIsValidationErrorCode(NSInteger errorCode)
{
    return
    errorCode == NSManagedObjectValidationError ||
    errorCode == NSValidationMultipleErrorsError ||
    errorCode == NSValidationMissingMandatoryPropertyError ||
    errorCode == NSValidationRelationshipDeniedDeleteError ||
    errorCode == NSValidationRelationshipExceedsMaximumCountError ||
    errorCode == NSValidationRelationshipLacksMinimumCountError ||
    errorCode == NSValidationNumberTooSmallError ||
    errorCode == NSValidationNumberTooLargeError ||
    errorCode == NSValidationDateTooSoonError ||
    errorCode == NSValidationDateTooLateError ||
    errorCode == NSValidationInvalidDateError ||
    errorCode == NSValidationStringPatternMatchingError ||
    errorCode == NSValidationStringTooLongError ||
    errorCode == NSValidationStringTooShortError;
}

@implementation NSString (MagicalRecordLogging)

- (void) MR_logToConsole;
{
    MRLog(@"%@", self);
}

@end


@implementation NSError (MagicalRecordErrorHandling)

- (NSArray *) MR_errorCollection;
{
    return [self code] == NSValidationMultipleErrorsError ? [[self userInfo] valueForKey:NSDetailedErrorsKey] : @[self];
}

- (NSDictionary *) MR_errorCollectionGroupedByObject;
{
    NSMutableDictionary *collatedObjects = [NSMutableDictionary dictionary];
    [[self MR_errorCollection] enumerateObjectsUsingBlock:^(id error, NSUInteger idx, BOOL *stop) {
        NSManagedObject *errorObject = [error MR_validationErrorObject];

        NSMutableArray *errorList = [collatedObjects objectForKey:[errorObject objectID]];
        if (errorList == nil)
        {
            errorList = [NSMutableArray array];
            [collatedObjects setObject:errorList forKey:[errorObject objectID]];
        }

        [errorList addObject:error];
        
    }];
    return [NSDictionary dictionaryWithDictionary:collatedObjects];
}

- (NSString *) MR_summaryDescription;
{
    if (MR_errorCodeIsValidationErrorCode([self code]))
    {
        return [NSString stringWithFormat:@"- [Validation] %@, Invalid Property: [%@], ManagedObject: [%@]",
                MR_errorSummaryFromErrorCode([self code]),
                [self MR_validationError],
                [self MR_validationErrorObject]];
    }
    return [NSString stringWithFormat:@"%@ [%@]", MR_errorSummaryFromErrorCode([self code]), [self MR_validationErrorObject]];
}

- (NSString *) MR_coreDataDescription;
{
    NSMutableString *descriptionBuffer = [NSMutableString string];
    
    if ([self code] == NSValidationMultipleErrorsError)
    {
        [descriptionBuffer appendString:@"Multiple Validation Errors --\n"];
        NSDictionary *groupedErrors = [self MR_errorCollectionGroupedByObject];
        [[groupedErrors allKeys] enumerateObjectsUsingBlock:^(id managedObject, NSUInteger idx, BOOL *stop) {
            
            [descriptionBuffer appendFormat:@" Object: %@ -", managedObject];
            NSArray *errors = [groupedErrors objectForKey:managedObject];
            [errors enumerateObjectsUsingBlock:^(id error, NSUInteger idx, BOOL *stop) {
                [descriptionBuffer appendFormat:@" %@ [%@],",[error MR_validationError], MR_errorSummaryFromErrorCode([error code])];
            }];
            [descriptionBuffer deleteCharactersInRange:NSMakeRange([descriptionBuffer length] - 1, 1)];
            [descriptionBuffer appendString:@"\n"];
        }];
    }
    else
    {
        [[self MR_errorCollection] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
            [descriptionBuffer appendFormat:@" %@\n", [obj MR_summaryDescription]];
        }];
    }
    
    return [NSString stringWithString:descriptionBuffer];
}

- (id) MR_validationError;
{
    return [[self userInfo] valueForKey:NSValidationKeyErrorKey];
}

- (NSManagedObject *) MR_validationErrorObject;
{
    return [[self userInfo] objectForKey:NSValidationObjectErrorKey];
}

@end
