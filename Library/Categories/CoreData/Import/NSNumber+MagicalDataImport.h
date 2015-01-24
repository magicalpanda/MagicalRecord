//
//  NSNumber+MagicalDataImport.h
//  Magical Record
//
//  Created by Saul Mora on 9/4/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSNumber (MagicalRecordDataImport)

- (NSString *) MR_lookupKeyForProperty:(NSPropertyDescription *)propertyDescription;
- (id) MR_relatedValueForRelationship:(NSRelationshipDescription *)relationshipInfo;

/**
 If possible, converts the current number into a data using the specified format string.
 See http://en.wikipedia.org/wiki/Date_(Unix) for usable date format specifiers.

 @param dateFormat String containing a UNIX date format string.

 @return The current number as a date.

 @since Available in v3.0 and later.
 */
- (NSDate *) MR_dateWithFormat:(NSString *)dateFormat;

@end
