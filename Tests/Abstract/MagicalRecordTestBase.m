//
//  Created by Tony Arnold on 21/12/2013.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordTestBase.h"

@implementation MagicalRecordTestBase

- (void)setUp
{
    [super setUp];

    // Don't pollute the tests with logging
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelOff];

    // Setup a usable stack
    self.stack = [[self class] newMagicalRecordStack];
    [self.stack setModelFromClass:[self class]];
}

- (void)tearDown
{
    [super tearDown];

    [self.stack reset];
}

+ (MagicalRecordStack *)newMagicalRecordStack
{
    return [InMemoryMagicalRecordStack stack];
}

@end
