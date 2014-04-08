//
//  MagicalRecord+Options.m
//  Magical Record
//
//  Created by Saul Mora on 3/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord+Options.h"
#import "MagicalRecordStack.h"

static MagicalRecordLogLevel kMagicalRecordLogLevel = MagicalRecordLogLevelVerbose;

@implementation MagicalRecord (Options)

+ (MagicalRecordLogLevel) logLevel;
{
    return kMagicalRecordLogLevel;
}

+ (void) setLogLevel:(MagicalRecordLogLevel)logLevel;
{
    kMagicalRecordLogLevel = logLevel;
}

@end
