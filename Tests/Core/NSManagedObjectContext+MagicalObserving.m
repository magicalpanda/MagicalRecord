//
//  Created by Tony Arnold on 8/04/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordTestBase.h"
#import "SingleEntityWithNoRelationships.h"

@interface NSManagedObjectContextMagicalObserving : MagicalRecordTestBase

@end

@implementation NSManagedObjectContextMagicalObserving

- (void)testCanObserveContextAndSaveChanges
{
    NSManagedObjectContext *stackContext = self.stack.context;
    NSManagedObjectContext *otherContext = [NSManagedObjectContext MR_privateQueueContextWithStoreCoordinator:self.stack.coordinator];

    NSManagedObject *testEntity = [SingleEntityWithNoRelationships MR_createEntityInContext:otherContext];
    XCTAssertNotNil(testEntity);

    [otherContext performBlockAndWait:^{
        XCTAssertTrue(otherContext.hasChanges);
    }];

    [stackContext performBlockAndWait:^{
        XCTAssertFalse(stackContext.hasChanges);
    }];

    [stackContext MR_observeContextDidSaveAndSaveChangesToSelf:otherContext];

    [otherContext MR_saveOnlySelfAndWait];

    [otherContext performBlockAndWait:^{
        XCTAssertFalse(otherContext.hasChanges);
    }];

    [stackContext performBlockAndWait:^{
        XCTAssertFalse(stackContext.hasChanges);
    }];
}

@end
