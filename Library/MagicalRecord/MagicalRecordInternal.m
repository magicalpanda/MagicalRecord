//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "MagicalRecordInternal.h"
#import "MagicalRecordStack.h"

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
        defaultName = @"CoreDataStore.sqlite";
    }

    if (![defaultName hasSuffix:@"sqlite"])
    {
        defaultName = [defaultName stringByAppendingPathExtension:@"sqlite"];
    }

    return defaultName;
}

@end
