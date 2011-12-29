//
//  MagicalDataImportTestCase.m
//  Magical Record
//
//  Created by Saul Mora on 8/16/11.
//  Copyright (c) 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalDataImportTestCase.h"

@implementation MagicalDataImportTestCase

@synthesize testEntityData = testEntityData__;
@synthesize testEntity = testEntity__;

- (void) setUp
{
    [MagicalRecordHelpers setDefaultModelNamed:@"TestModel.momd"];
    [MagicalRecordHelpers setupCoreDataStackWithInMemoryStore];
    //[MagicalRecordHelpers setupCoreDataStack];
    
    if ([self respondsToSelector:@selector(setupTestData)])
    {
        [self performSelector:@selector(setupTestData)];
    }
    
    self.testEntityData = [self dataFromJSONFixture];
}

- (void) tearDown
{
    [MagicalRecordHelpers cleanUp];
}

- (Class) testEntityClass;
{
    return [NSManagedObject class];
}

-(BOOL)shouldRunOnMainThread
{
    return YES;
}

@end
