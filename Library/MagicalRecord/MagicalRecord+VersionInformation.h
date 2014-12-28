//
//  Created by Tony Arnold on 8/04/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"

/**
 Defines current and historical version numbers of MagicalRecord.

 @since Available in v2.3 and later.
 */
typedef NS_ENUM(NSUInteger, MagicalRecordVersionTag)
{
    /** Version 2.2.0 */
    MagicalRecordVersionTag2_2 = 220,

    /** Version 2.3.0 */
    MagicalRecordVersionTag2_3 = 230,

    /** Version 3.0.0 */
    MagicalRecordVersionTag3_0 = 300,
};

/**
 Provides an way for developers to retrieve the version of MagicalRecord they are currently using within their apps.

 @since Available in v2.3 and later.
 */
@interface MagicalRecord (VersionInformation)

///---------------------------
/// @name Version Information
///---------------------------

/**
 Returns the current version of MagicalRecord. See the MagicalRecordVersionTag enumeration for valid current and historical values.

 @return The current version as a double.

 @since Available in v2.3 and later
 */
+ (MagicalRecordVersionTag)version;

@end
