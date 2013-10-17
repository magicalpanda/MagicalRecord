//
//  MagicalRecord+Options.h
//  Magical Record
//
//  Created by Saul Mora on 3/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"

@interface MagicalRecord (Options)

+ (void) setLogLevel:(MagicalRecordLogLevel)level;
+ (MagicalRecordLogLevel) logLevel;

@end
