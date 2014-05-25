//
//  NSString+MagicalRecord_MagicalDataImport.h
//  Magical Record
//
//  Created by Saul Mora on 12/10/11.
//  Copyright (c) 2011 Magical Panda Software LLC. All rights reserved.
//

@interface NSString (MagicalRecordDataImport)

/**
 Returns a modified copy of the current string with it's first letter capitalized, or the current string if the first character is already capitalized.

 @return The current string with it's first character capitalized.

 @since Available in v1.8.3 and later.
 */
- (NSString *) MR_capitalizedFirstCharacterString;

/**
 If possible, converts the current string into a data using the specified format string. 
 See http://en.wikipedia.org/wiki/Date_(Unix) for usable date format specifiers.

 @param dateFormat String containing a UNIX date format string. If nothing is provided, `yyyy-MM-dd'T'HH:mm:ss'Z'` will be used.

 @return The current string as a date.

 @since Available in v3.0 and later.
 */
- (NSDate *) MR_dateWithFormat:(NSString *)dateFormat;

@end
