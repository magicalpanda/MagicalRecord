//
//  Created by Tony Arnold on 25/03/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordTestBase.h"

@interface NSManagedObjectContextMagicalRecordTests : MagicalRecordTestBase

@end

@implementation NSManagedObjectContextMagicalRecordTests

- (void)testCanNotifyDefaultContextOnSave
{
    NSManagedObjectContext *stackContext = self.stack.context;
    NSManagedObjectContext *testContext = [NSManagedObjectContext MR_confinementContextWithParent:stackContext];

    expect([testContext parentContext]).to.equal(stackContext);
}

@end
