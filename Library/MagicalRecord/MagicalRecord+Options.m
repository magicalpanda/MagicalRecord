//
//  MagicalRecord+Options.m
//  Magical Record
//
//  Created by Saul Mora on 3/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord+Options.h"
#import "MagicalRecordStack.h"

static MagicalRecordLogLevel magicalRecordLogLevel = MagicalRecordLogLevelVerbose;

@implementation MagicalRecord (Options)

+ (MagicalRecordLogLevel) logLevel;
{
    return magicalRecordLogLevel;
}

+ (void) setLogLevel:(MagicalRecordLogLevel)logLevel;
{
    magicalRecordLogLevel = logLevel;
}

@end
