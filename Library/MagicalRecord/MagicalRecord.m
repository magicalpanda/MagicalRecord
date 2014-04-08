//
//  MagicalRecord.m
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "CoreData+MagicalRecord.h"
#import "MagicalRecordStack.h"

const double MagicalRecordVersionNumber = MagicalRecordVersionNumber3_0;

@implementation MagicalRecord

+ (void) cleanUp
{
    [MagicalRecordStack setDefaultStack:nil];
}

+ (NSString *) defaultStoreName;
{
    NSString *defaultName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(id)kCFBundleNameKey];
    if (defaultName == nil)
    {
        defaultName = kMagicalRecordDefaultStoreFileName;
    }
    if (![defaultName hasSuffix:@"sqlite"]) 
    {
        defaultName = [defaultName stringByAppendingPathExtension:@"sqlite"];
    }

    return defaultName;
}

+ (double) version;
{
    return MagicalRecordVersionNumber;
}

@end


