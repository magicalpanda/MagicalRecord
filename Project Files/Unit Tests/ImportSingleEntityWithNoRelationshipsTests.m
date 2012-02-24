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
    [MagicalRecordHelpers setupCoreDataStackWithInMemoryStore];

    id singleEntity = [self dataFromJSONFixture];
    
    testEntity = [SingleEntityWithNoRelationships MR_importFromDictionary:singleEntity];
}

- (void) tearDownClass
{
    [MagicalRecordHelpers cleanUp];
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

#if TARGET_OS_IPHONE 

#if defined(__IPHONE_5_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0

- (void) testImportUIColorAttributeToEntity
{
    UIColor *actualColor = testEntity.colorTestAttribute;
 
    if ([actualColor respondsToSelector:@selector(getRed:green:blue:alpha:)]) 
    {
        CGFloat red, blue, green, alpha;
        [actualColor getRed:&red green:&green blue:&blue alpha:&alpha];

        assertThatFloat(alpha, is(equalToFloat(1.)));
        assertThatFloat(red, is(equalToFloat(64./255.)));
        assertThatFloat(green, is(equalToFloat(128./255.)));
        assertThatFloat(blue, is(equalToFloat(225./255.)));
    }
}
#endif

- (NSDate *) dateFromString:(NSString *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM d, yyyy hh:mm:ss a zzz";
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    formatter.locale = [NSLocale currentLocale];
    
    NSDate *expectedDate = [formatter dateFromString:date];

    return expectedDate;
}

#else

- (void) testImportNSColorAttributeToEntity
{
    NSColor *actualColor = testEntity.colorTestAttribute;
    
    assertThatFloat(actualColor.alphaComponent, is(equalToFloat(255./255.)));
    assertThatFloat(actualColor.redComponent, is(equalToFloat(64./255.)));
    assertThatFloat(actualColor.greenComponent, is(equalToFloat(128./255.)));
    assertThatFloat(actualColor.blueComponent, is(equalToFloat(225./255.)));
}

- (NSDate *) dateFromString:(NSString *)date
{
    NSDate *expectedDate = [NSDate dateWithString:date];
    return expectedDate;
}

#endif

- (void) testImportDateAttributeToEntity
{
    NSDate *expectedDate = [self dateFromString:@"Jul 23, 2011 10:30:40 PM MST"];
    assertThat(testEntity.dateTestAttribute, is(equalTo(expectedDate)));
}

- (void) testImportDataAttributeWithCustomFormat
{
    NSDate *expectedDate = [self dateFromString:@"Aug 5, 2011 01:56:04 AM MDT"];
    assertThat(testEntity.dateWithCustomFormat, is(equalTo(expectedDate)));
    
}

@end
