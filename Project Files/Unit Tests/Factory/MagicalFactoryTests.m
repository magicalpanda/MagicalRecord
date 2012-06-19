//
// Test Case: MagicalFactoryTests
// Created by Saul Mora on 6/19/12
// Copyright © 2012 by Magical Panda Software LLC
//

#import <SenTestingKit/SenTestingKit.h>
#import "MagicalFactory.h"

@interface MagicalFactoryTests : SenTestCase
@end
	
	
@implementation MagicalFactoryTests

- (void) testCannotDefineSameFactoryMoreThanOnce;
{
    [MagicalFactory define:[User class] do:^(id<MRFactoryObject> factoryObj){
        
        [[[factoryObj setValue:@"Test"] forProperty] firstName];
        [[[factoryObj setSequence:sequence] forProperty] lastName];
    }];
}

@end
