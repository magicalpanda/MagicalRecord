//
//  Created by Sérgio Estêvão on 09/01/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordDataImportTestCase.h"
#import <XCTest/XCTest.h>
#import "FixtureHelpers.h"
#import "SingleEntityWithNoRelationships.h"

@interface ImportMultipleEntitiesWithNoPrimaryKeyTests : MagicalRecordDataImportTestCase

@property (readwrite, nonatomic, retain) NSArray *arrayOfTestEntity;

@end

@implementation ImportMultipleEntitiesWithNoPrimaryKeyTests

- (void)setUp
{
    [super setUp];

    NSManagedObjectContext *currentStackContext = self.stack.context;

    self.arrayOfTestEntity = [SingleEntityWithNoRelationships MR_importFromArray:self.testEntityData inContext:currentStackContext];
}

- (void)tearDown
{
    self.arrayOfTestEntity = nil;

    [super tearDown];
}

- (void)testImportOfMultipleEntities
{
    XCTAssertNotNil(self.arrayOfTestEntity, @"arrayOfTestEntity should not be nil");
    XCTAssertEqual([self.arrayOfTestEntity count], (NSUInteger)4, @"arrayOfTestEntity should have 4 entities");
}

@end
