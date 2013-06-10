//
//  DataImportTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "SingleEntityWithNoRelationships.h"

@interface ImportSingleEntityWithNoRelationshipsTests : GHTestCase

@property (nonatomic, retain) SingleEntityWithNoRelationships *testEntity;

@end

@implementation ImportSingleEntityWithNoRelationshipsTests

@synthesize testEntity;

- (void) setUpClass
{
    [NSManagedObjectModel MR_setDefaultManagedObjectModel:[NSManagedObjectModel MR_managedObjectModelNamed:@"TestModel.momd"]];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];

    id singleEntity = [self dataFromJSONFixture];
    
    testEntity = [SingleEntityWithNoRelationships MR_importFromObject:singleEntity];
}

- (void) tearDownClass
{
    [MagicalRecord cleanUp];
}

- (void) testImportASingleEntity
{
    assertThat(testEntity, is(notNilValue()));
}

- (void) testImportStringAttributeToEntity
{
    assertThat(testEntity.stringTestAttribute, is(equalTo(@"This is a test value")));
}

- (void) testImportInt16AttributeToEntity
{
    assertThat(testEntity.int16TestAttribute, is(equalToInteger(256)));
}

- (void) testImportInt32AttributeToEntity
{
    assertThat(testEntity.int32TestAttribute, is(equalToInt(32)));
}

- (void) testImportInt64AttributeToEntity
{
    assertThat(testEntity.int64TestAttribute, is(equalToInteger(42)));
}

- (void) testImportDecimalAttributeToEntity
{
    assertThat(testEntity.decimalTestAttribute, is(equalToDouble(1.2)));
}

- (void) testImportDoubleAttributeToEntity
{
    assertThat(testEntity.doubleTestAttribute, is(equalToDouble(124.3)));
}

- (void) testImportFloatAttributeToEntity
{
    assertThat(testEntity.floatTestAttribute, is(equalToFloat(10000000000)));
}

- (void) testImportBooleanAttributeToEntity
{
    assertThat(testEntity.booleanTestAttribute, is(equalToBool(NO)));
}

- (void) testImportMappedStringAttributeToEntity
{
    assertThat(testEntity.mappedStringAttribute, is(equalTo(@"Mapped value")));
}

- (void) testImportStringAttributeWithNullValue
{
    assertThat(testEntity.nullTestAttribute, is(nilValue()));
}

- (void) testImportAttributeNotInJsonData
{
    assertThat(testEntity.notInJsonAttribute, containsString(@"Core Data Model"));
}

- (NSDate *) dateFromString:(NSString *)date
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
  NSDate *expectedDate = [formatter dateFromString:date];
  
  return expectedDate;
}

- (void) testImportDateAttributeToEntity
{
    NSDate *expectedDate = [self dateFromString:@"2011-07-23 22:30:40"];
    assertThat(testEntity.dateTestAttribute, is(equalTo(expectedDate)));
}

- (void) testImportDateAttributeWithCustomFormat
{
    NSDate *expectedDate = [self dateFromString:@"2011-08-05 00:56:04"];
    assertThat(testEntity.dateWithCustomFormat, is(equalTo(expectedDate)));
    
}

- (void) testImportInt16AsStringAttributeToEntity
{
    assertThat(testEntity.int16AsStringTestAttribute, is(equalToInteger(256)));
}

- (void) testImportInt32AsStringAttributeToEntity
{
    assertThat(testEntity.int32AsStringTestAttribute, is(equalToInt(32)));
}

- (void) testImportInt64AsStringAttributeToEntity
{
    assertThat(testEntity.int64AsStringTestAttribute, is(equalToInteger(42)));
}

- (void) testImportDecimalAsStringAttributeToEntity
{
    assertThat(testEntity.decimalAsStringTestAttribute, is(equalToDouble(1.2)));
}

- (void) testImportDoubleAsStringAttributeToEntity
{
    assertThat(testEntity.doubleAsStringTestAttribute, is(equalToDouble(124.3)));
}

- (void) testImportFloatAsStringAttributeToEntity
{
    assertThat(testEntity.floatAsStringTestAttribute, is(equalToFloat(10000000000)));
}

@end
