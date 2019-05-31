//
//  Created by Tony Arnold on 28/01/2016.
//  Copyright © 2016 Magical Panda Software LLC. All rights reserved.

#import "MagicalRecordTestBase.h"
#import "NSManagedObject+MagicalRecord.h"
#import "MagicalRecord+ShorthandMethods.h"
#import "MagicalRecordShorthandMethodAliases.h"

@interface MagicalRecordShorthandTests : MagicalRecordTestBase

@end

@implementation MagicalRecordShorthandTests

- (void)setUp
{
    [super setUp];
    [MagicalRecord enableShorthandMethods];
}

- (void)testLongFormMethodsAreStillAvailableWhenShorthandIsEnabled
{
    XCTAssertTrue([[NSManagedObjectContext class] respondsToSelector:@selector(MR_rootSavingContext)]);
    XCTAssertTrue([[NSManagedObjectContext MR_rootSavingContext] respondsToSelector:@selector(MR_saveWithBlock:)]);
}

- (void)testShorthandMethodsAreAvailableWhenEnabled
{
    XCTAssertTrue([[NSManagedObjectContext class] respondsToSelector:@selector(rootSavingContext)]);
    XCTAssertNotNil([NSManagedObjectContext rootSavingContext]);
    XCTAssertTrue([[NSManagedObjectContext rootSavingContext] respondsToSelector:@selector(saveWithBlock:)]);
}

@end
