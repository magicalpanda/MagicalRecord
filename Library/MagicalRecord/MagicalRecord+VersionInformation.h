//
//  Created by Tony Arnold on 8/04/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"

#define MagicalRecordVersionNumber2_2 220
#define MagicalRecordVersionNumber2_3 230
#define MagicalRecordVersionNumber3_0 300

extern const double MagicalRecordVersionNumber;

/**
 Provides an way for developers to retrieve the version of MagicalRecord they are currently using within their apps.

 @since Available in v2.3 and later.
 */
@interface MagicalRecord (VersionInformation)

///---------------------------
/// @name Version Information
///---------------------------

/**
 Use this class method to retrieve the current library version. See the `MagicalRecordVersionNumber` for more information and valid values.

 @return Double value representing the current library version.
 
 @since Available in v2.3 and later.
 */
+ (double) version;

@end
