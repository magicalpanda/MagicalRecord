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
        assertThatFloat(red, is(equalToFloat(64.0f/255.0f)));
        assertThatFloat(green, is(equalToFloat(128.0f/255.0f)));
        assertThatFloat(blue, is(equalToFloat(225.0f/255.0f)));
    }
}
#endif

- (NSDate *) dateFromString:(NSString *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    formatter.locale = [NSLocale currentLocale];
    
    NSDate *expectedDate = [formatter dateFromString:date];

    return expectedDate;
}

#else

- (void) testImportNSColorAttributeToEntity
{
#warning Proper fix is to extract out color tests to seperate mac and iOS specific model files with proper configurations
    NSColor *actualColor = (NSColor *)[testEntity colorTestAttribute];
    
    assertThatDouble([actualColor alphaComponent], is(equalToDouble(255.0/255.0)));
    assertThatDouble([actualColor redComponent], is(equalToFloat(64.0f/255.0f)));
    assertThatDouble([actualColor greenComponent], is(equalToFloat(128.0f/255.0f)));
    assertThatDouble([actualColor blueComponent], is(equalToFloat(225.0f/255.0f)));
}

- (NSDate *) dateFromString:(NSString *)date
{
    NSDate *expectedDate = [NSDate dateWithString:date];
    return expectedDate;
}

#endif

- (void) testImportDateAttributeToEntity
{
    NSDate *expectedDate = [self dateFromString:@"2011-07-23 22:30:40 +0000"];
    assertThat(testEntity.dateTestAttribute, is(equalTo(expectedDate)));
}

- (void) testImportDateAttributeWithCustomFormat
{
    NSDate *expectedDate = [self dateFromString:@"2011-08-05 00:56:04 +0000"];
    assertThat(testEntity.dateWithCustomFormat, is(equalTo(expectedDate)));
    
}

@end
