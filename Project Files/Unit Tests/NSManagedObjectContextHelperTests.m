//
//  NSManagedObjectContextHelperTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObjectContextHelperTests.h"
#import "SingleRelatedEntity.h"

@implementation NSManagedObjectContextHelperTests

- (void) setUpClass
{
    [NSManagedObjectModel MR_setDefaultManagedObjectModel:[NSManagedObjectModel MR_managedObjectModelNamed:@"TestModel.momd"]];
}

- (void) setUp
{
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
}

- (void) tearDown
{
    //[MagicalRecord cleanUp];
}

- (void) testCanCreateContextForCurrentThread
{
    NSManagedObjectContext *firstContext = [NSManagedObjectContext MR_contextForCurrentThread];
    NSManagedObjectContext *secondContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    assertThat(firstContext, is(equalTo(secondContext)));
}

- (void) testCanNotifyDefaultContextOnSave
{
    NSManagedObjectContext *testContext = [NSManagedObjectContext MR_contextThatPushesChangesToDefaultContext];
    
    assertThat([testContext parentContext], is(equalTo([NSManagedObjectContext MR_defaultContext])));
}

- (void)testBustedNestedContextLookup
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        assertThat([NSManagedObjectContext MR_defaultContext], is(notNilValue()));
        
        NSManagedObjectContext *mainContext = [NSManagedObjectContext MR_defaultContext];
        // Create a new object
        SingleRelatedEntity *entity = [SingleRelatedEntity createInContext:[NSManagedObjectContext MR_defaultContext]];
        entity.mappedStringAttribute = @"test";
        assertThat(entity, isIn([mainContext insertedObjects]));
        
        // Find it in the background, to do stuff to it or something
        [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
            SingleRelatedEntity *localEntity = [entity MR_inContext:localContext];
            assertThat(localEntity, is(notNilValue()));
            localEntity.mappedStringAttribute = @"Test";
            
        } completion:^{
            dispatch_semaphore_signal(semaphore);
            NSLog(@"Got ehre");
        }];
        
    });
    
    dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_FOREVER, 0));
    NSLog(@"Done");
    
    
}


@end
