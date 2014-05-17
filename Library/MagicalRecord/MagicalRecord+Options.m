//
//  MagicalRecord+Options.m
//  Magical Record
//
//  Created by Saul Mora on 3/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord+Options.h"

static MagicalRecordLoggingLevel magicalRecordLoggingLevel = MagicalRecordLoggingLevelVerbose;

@implementation MagicalRecord (Options)

+ (MagicalRecordLoggingLevel) loggingLevel;
{
    return magicalRecordLoggingLevel;
}

+ (void) setLoggingLevel:(MagicalRecordLoggingLevel)level;
{
    magicalRecordLoggingLevel = level;
}

@end
