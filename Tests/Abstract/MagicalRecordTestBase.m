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
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelVerbose];

    // Setup a usable stack
    MagicalRecordStack *testStack = [InMemoryMagicalRecordStack stack];
    [testStack setModelFromClass:[self class]];
    self.stack = testStack;
}

- (void)tearDown
{
    [super tearDown];
    
    self.stack = nil;
}

@end
