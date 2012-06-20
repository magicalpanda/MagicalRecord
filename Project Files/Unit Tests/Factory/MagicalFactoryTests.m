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

- (void) tearDown;
{
    [MagicalFactory resetAll];
}

- (void) testDefineAFactoryWithAnEmptyDefinitionBlock;
{
    [MagicalFactory define:[User class] do:^(id<MRFactoryObject> factoryObj){
        
    }];
    assertThat([MagicalFactory factories], hasCountOf(1));
}


- (void) testCannotDefineSameFactoryMoreThanOnce;
{
    [MagicalFactory define:[User class] do:nil];
    [MagicalFactory define:[User class] do:nil];
    
    assertThat([MagicalFactory factories], hasCountOf(1));
}

- (void) testCanDefineSameFactoryTypeTwiceWithAnAlias;
{
    [MagicalFactory define:[User class] do:nil];
    [MagicalFactory define:[User class] as:@"Admin" do:nil];
    
    assertThat([MagicalFactory factories], hasCountOf(2));
}

- (void) testDefineAFactoryWithAStaticValueBlock;
{
    [MagicalFactory define:[User class] do:^(id<MRFactoryObject> factoryObj){
        
        [[[factoryObj setValue:@"Test"] forProperty] firstName];
        
    }];
    
    id factory = [[MagicalFactory factories] anyObject];
    assertThat([factory firstName], is(equalTo(@"Test")));
}

- (void) testDefineAFactoryWithASequenceBlock;
{
    STFail(@"Not Implemented");
    [MagicalFactory define:[User class] do:^(id<MRFactoryObject> factoryObj){

        //        [[[factoryObj setSequence:sequence] forProperty] lastName];
        
    }];
}

- (void) testDefineAFactoryWithAStringIdentifier;
{
    STFail(@"Not Implemented");
}

- (void) testDefineAFactoryWithAnAlias;
{
    STFail(@"Not Implemented");
}

- (void) testDefineAFactoryWithAnAssociationToAnExistingFactory;
{
    STFail(@"Not Implemented");
}

- (void) testDefineAFactoryWithAnAssociationToANonExistantFactory;
{
    STFail(@"Not Implemented");
}


////

- (void) testCreatingObjectInstancesFromDefinedFactory;
{
    STFail(@"Not Implemented");
}

@end
