//
//  MagicalRecord+iCloud.m
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord+iCloud.h"

static BOOL _iCloudEnabled = NO;

@implementation MagicalRecord (iCloud)

#pragma mark - iCloud Methods

+ (BOOL) isICloudEnabled;
{
    return _iCloudEnabled;
}

+ (void) setICloudEnabled:(BOOL)enabled;
{
    @synchronized(self)
    {
        _iCloudEnabled = enabled;
    }
}

@end
