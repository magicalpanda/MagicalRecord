//
//  Created by Tony Arnold on 8/04/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordTestBase.h"
#import "NSManagedObjectContext+MagicalObserving.h"
#import "SingleEntityWithNoRelationships.h"

@interface NSManagedObjectContextMagicalObserving : MagicalRecordTestBase

@end

@implementation NSManagedObjectContextMagicalObserving

- (void)testCanObserveContextAndSaveChanges
{
    NSManagedObjectContext *stackContext = self.stack.context;
    NSManagedObjectContext *otherContext = [NSManagedObjectContext MR_privateQueueContextWithStoreCoordinator:self.stack.coordinator];

    NSManagedObject *testEntity = [SingleEntityWithNoRelationships MR_createEntityInContext:otherContext];

    expect(testEntity).toNot.beNil();
    expect([otherContext hasChanges]).to.beTruthy();
    expect([stackContext hasChanges]).to.beFalsy();

    [stackContext MR_observeContextDidSaveAndSaveChangesToSelf:otherContext];

    [otherContext MR_saveOnlySelfAndWait];

    expect([otherContext hasChanges]).to.beFalsy();
    expect([stackContext hasChanges]).to.beFalsy();
}

@end
