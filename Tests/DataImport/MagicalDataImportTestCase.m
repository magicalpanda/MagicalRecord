//
//  MagicalDataImportTestCase.m
//  Magical Record
//
//  Created by Saul Mora on 8/16/11.
//  Copyright (c) 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalDataImportTestCase.h"
#import "FixtureHelpers.h"

@implementation MagicalDataImportTestCase

@synthesize testEntityData = testEntityData__;
@synthesize testEntity = testEntity__;

- (void)setUp
{
    [super setUp];

    [MagicalRecord setDefaultModelFromClass:[self class]];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];

    [self setupTestData];

    self.testEntityData = [self dataFromJSONFixture];
}

- (void)tearDown
{
    [super tearDown];

    [MagicalRecord cleanUp];
}

- (Class)testEntityClass;
{
    return [NSManagedObject class];
}

- (void)setupTestData
{
    // Implement this in your subclasses
}

@end
