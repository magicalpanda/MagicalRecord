//
//  Created by Tony Arnold on 8/04/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord+VersionInformation.h"

const double MagicalRecordVersionNumber = MagicalRecordVersionNumber3_0;

@implementation MagicalRecord (VersionInformation)

+ (double) version;
{
    return MagicalRecordVersionNumber;
}

@end
