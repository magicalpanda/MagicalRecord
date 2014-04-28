//
//  MagicalRecord+Options.m
//  Magical Record
//
//  Created by Saul Mora on 3/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord+Options.h"

static MagicalRecordLoggingMask kMagicalRecordLoggingMask = MagicalRecordLoggingMaskVerbose;

@implementation MagicalRecord (Options)

+ (MagicalRecordLoggingMask) loggingMask;
{
    return kMagicalRecordLoggingMask;
}

+ (void) setLoggingMask:(MagicalRecordLoggingMask)mask;
{
    kMagicalRecordLoggingMask = mask;
}

@end
