//
//  DataImportTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "DataImportTests.h"
#import "SingleEntityWithNoRelationships.h"

@implementation DataImportTests

- (void) setUp
{
    [NSManagedObjectModel setDefaultManagedObjectModel:[NSManagedObjectModel managedObjectModelNamed:@"TestModel.momd"]];
    [MagicalRecordHelpers setupCoreDataStackWithInMemoryStore];
}

- (void) tearDown
{
    [MagicalRecordHelpers cleanUp];
}

- (void) testImportASingleEntity
{
    id singleEntity = [FixtureHelpers dataFromPListFixtureNamed:@"SingleEntityWithNoRelationships"];
    
    SingleEntityWithNoRelationships *testEntity = [SingleEntityWithNoRelationships mr_importFromDictionary:singleEntity];
    
    assertThat(testEntity, is(notNilValue()));
    
    assertThat(testEntity.integerTestAttribute, is(equalToInteger(42)));
    assertThat(testEntity.stringTestAttribute, is(equalTo(@"This is a test value")));
}

@end
