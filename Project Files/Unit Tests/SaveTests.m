//
//  SaveTests.m
//  Magical Record
//
//  Created by Stephen J Vanterpool on 9/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#define EXP_SHORTHAND
#import "Expecta.h"
#import "SaveTests.h"
#import "SingleEntityWithNoRelationships.h"

@implementation SaveTests

- (void) setUpClass
{
    [NSManagedObjectModel MR_setDefaultManagedObjectModel:[NSManagedObjectModel MR_managedObjectModelNamed:@"TestModel.momd"]];
    
}

- (void) setUp
{
    NSLog(@"Creating stack");
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
}

- (void) tearDown
{
    [MagicalRecord cleanUp];
}

- (void)testBackgroundSaveCallsCompletionHandler
{
    __block BOOL didSave = NO;
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        [SingleEntityWithNoRelationships MR_createInContext:localContext];
    } completion:^{
        didSave = YES;
    }];
    
    expect(didSave).will.beTruthy();
}

@end
