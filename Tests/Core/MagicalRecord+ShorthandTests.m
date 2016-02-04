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
    expect([NSManagedObjectContext class]).to.respondTo(@selector(MR_rootSavingContext));
    expect([NSManagedObjectContext MR_rootSavingContext]).to.respondTo(@selector(MR_saveWithBlock:));
}

- (void)testShorthandMethodsAreAvailableWhenEnabled
{
    expect([NSManagedObjectContext class]).to.respondTo(@selector(rootSavingContext));
    expect([NSManagedObjectContext rootSavingContext]).toNot.beNil();
    expect([NSManagedObjectContext rootSavingContext]).to.respondTo(@selector(saveWithBlock:));
}

@end
