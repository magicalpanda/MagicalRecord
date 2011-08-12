//
//  NSManagedObjectHelperTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObjectHelperTests.h"
#import "SingleRelatedEntity.h"

@implementation NSManagedObjectHelperTests

- (void) setUpClass
{
    [NSManagedObjectModel MR_setDefaultManagedObjectModel:[NSManagedObjectModel MR_managedObjectModelNamed:@"TestModel.momd"]];
    [MagicalRecordHelpers setupCoreDataStackWithInMemoryStore];
}

//Test Request Creation

- (void) testCreateFetchRequestForEntity
{
    NSFetchRequest *testRequest = [SingleRelatedEntity requestAll];
    
    assertThat([[testRequest entity] name], is(equalTo(NSStringFromClass([SingleRelatedEntity class]))));
}

// Test return result set, all, first

- (void) testCreateRequestForFirstEntity
{
    GHFail(@"Test Not Implemented");
}

- (void) testCanGetEntityDescriptionFromEntityClass
{
    GHFail(@"Test Not Implemented");
}

// Test Entity creation

- (void) testCanCreateEntityInstance
{
    GHFail(@"Test Not Implemented");
}

// Test Entity Deletion

- (void) testCanDeleteEntityInstance
{
    GHFail(@"Test Not Implemented");
}

// Test Number of Entities

- (void) testCanSearchForNumberOfAllEntities
{
    GHFail(@"Test Not Implemented");
}

- (void) testCanSearchForNumberOfUniqueEntities
{
    GHFail(@"Test Not Implemented");
}


- (void) testCanSearchForNumberOfEntitesWithPredicate
{
    GHFail(@"Test Not Implemented");
}

- (void) testCanSearchForNumberOfUniqueEntitiesWithPredicate
{
    GHFail(@"Test Not Implemented");
}


@end
