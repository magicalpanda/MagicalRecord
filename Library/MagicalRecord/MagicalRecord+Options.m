//
//  MagicalRecord+Options.m
//  Magical Record
//
//  Created by Saul Mora on 3/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord+Options.h"

static MagicalRecordLogMask kMagicalRecordLogMask = MagicalRecordLogMaskVerbose;

@implementation MagicalRecord (Options)

+ (MagicalRecordLogMask) loggingMask;
{
    return kMagicalRecordLogMask;
}

+ (void) setLoggingMask:(MagicalRecordLogMask)mask;
{
    kMagicalRecordLogMask = mask;
}

@end
