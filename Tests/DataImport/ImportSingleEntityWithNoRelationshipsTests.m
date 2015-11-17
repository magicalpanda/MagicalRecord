//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordDataImportTestCase.h"
#import "SingleEntityWithNoRelationships.h"

@interface NSString (MagicalRecordDateFormatter)

- (NSDate *)MRTests_dateFromString;

@end

@interface ImportSingleEntityWithNoRelationshipsTests : MagicalRecordDataImportTestCase

@property (readwrite, nonatomic, strong) SingleEntityWithNoRelationships *testEntity;

@end

@implementation ImportSingleEntityWithNoRelationshipsTests

- (void)setUp
{
    [super setUp];

    NSManagedObjectContext *stackContext = self.stack.context;

    self.testEntity = [SingleEntityWithNoRelationships MR_importFromObject:self.testEntityData inContext:stackContext];
}

- (void)testImportASingleEntity
{
    XCTAssertNotNil(self.testEntity);
}

- (void)testImportStringAttributeToEntity
{
    XCTAssertEqualObjects(self.testEntity.stringTestAttribute, @"This is a test value");
}

- (void)testImportInt16AttributeToEntity
{
    XCTAssertEqualObjects(self.testEntity.int16TestAttribute, @256, @"int16TestAttribute did not contain expected value, instead found: %@", self.testEntity.int16TestAttribute);
}

- (void)testImportInt32AttributeToEntity
{
    XCTAssertEqualObjects(self.testEntity.int32TestAttribute, @32, @"int32TestAttribute did not contain expected value, instead found: %@", self.testEntity.int32TestAttribute);
}

- (void)testImportInt64AttributeToEntity
{
    XCTAssertEqualObjects(self.testEntity.int64TestAttribute, @42, @"int64TestAttribute did not contain expected value, instead found: %@", self.testEntity.int64TestAttribute);
}

- (void)testImportDecimalAttributeToEntity
{
    XCTAssertEqualObjects(self.testEntity.decimalTestAttribute, @1.2, @"decimalTestAttribute did not contain expected value, instead found: %@", self.testEntity.decimalTestAttribute);
}

- (void)testImportDoubleAttributeToEntity
{
    XCTAssertEqualObjects(self.testEntity.doubleTestAttribute, @124.3, @"doubleTestAttribute did not contain expected value, instead found: %@", self.testEntity.doubleTestAttribute);
}

- (void)testImportFloatAttributeToEntity
{
    XCTAssertEqualObjects(self.testEntity.floatTestAttribute, @10000000000, @"floatTestAttribute did not contain expected value, instead found: %@", self.testEntity.floatTestAttribute);
}

- (void)testImportBooleanAttributeToEntity
{
    XCTAssertFalse([self.testEntity.booleanTestAttribute boolValue], @"booleanTestAttribute did not contain expected value, instead found: %@", self.testEntity.booleanTestAttribute);
}

- (void)testImportMappedStringAttributeToEntity
{
    XCTAssertEqualObjects(self.testEntity.mappedStringAttribute, @"Mapped value", @"mappedStringAttribute did not contain expected value, instead found: %@", self.testEntity.mappedStringAttribute);
}

- (void)testImportStringAttributeWithNullValue
{
    XCTAssertNil(self.testEntity.nullTestAttribute, @"nullTestAttribute did not contain expected value, instead found: %@", self.testEntity.nullTestAttribute);
}

- (void)testImportNumberAsStringAttributeToEntity
{
    XCTAssertEqualObjects(self.testEntity.numberAsStringTestAttribute, @"10248909829", @"numberAsStringTestAttribute did not contain expected value, instead found: %@", self.testEntity.numberAsStringTestAttribute);
}

- (void)testImportBooleanAsStringAttributeToEntity
{
    XCTAssertTrue(self.testEntity.booleanAsStringTestAttribute, @"booleanFromStringTestAttribute did not contain expected value, instead found: %@", self.testEntity.booleanAsStringTestAttribute);
}

- (void)testImportAttributeNotInJsonData
{
    NSRange rangeOfString = [self.testEntity.notInJsonAttribute rangeOfString:@"Core Data Model"];

    XCTAssertNotEqual(@(rangeOfString.length), @0, @"notInJsonAttribute did not contain expected string, instead received: %@", self.testEntity.notInJsonAttribute);
}

#if TARGET_OS_IPHONE

- (void)testImportUIColorAttributeToEntity
{
    UIColor *actualColor = self.testEntity.colorTestAttribute;

    if ([actualColor respondsToSelector:@selector(getRed:green:blue:alpha:)])
    {
        CGFloat red, blue, green, alpha;
        [actualColor getRed:&red green:&green blue:&blue alpha:&alpha];

        XCTAssertEqualWithAccuracy(alpha, (CGFloat)1.0, FLT_EPSILON, @"Unexpected value returned: %f", alpha);
        XCTAssertEqualWithAccuracy(red, (CGFloat)(64.0f / 255.0f), FLT_EPSILON, @"Unexpected value returned: %f", red);
        XCTAssertEqualWithAccuracy(green, (CGFloat)(128.0f / 255.0f), FLT_EPSILON, @"Unexpected value returned: %f", green);
        XCTAssertEqualWithAccuracy(blue, (CGFloat)(225.0f / 255.0f), FLT_EPSILON, @"Unexpected value returned: %f", blue);
    }
}

#else

- (void)testImportNSColorAttributeToEntity
{
    NSColor *actualColor = self.testEntity.colorTestAttribute;

    XCTAssertEqualWithAccuracy([actualColor alphaComponent], (CGFloat)(255.0 / 255.0), FLT_EPSILON, @"Unexpected value returned");
    XCTAssertEqualWithAccuracy([actualColor redComponent], (CGFloat)(64.0f / 255.0f), FLT_EPSILON, @"Unexpected value returned");
    XCTAssertEqualWithAccuracy([actualColor greenComponent], (CGFloat)(128.0f / 255.0f), FLT_EPSILON, @"Unexpected value returned");
    XCTAssertEqualWithAccuracy([actualColor blueComponent], (CGFloat)(225.0f / 255.0f), FLT_EPSILON, @"Unexpected value returned");
}

#endif /* if TARGET_OS_IPHONE */

- (void)testImportDateAttributeToEntity
{
    XCTAssertEqualObjects(self.testEntity.dateTestAttribute, [@"2011-07-23 22:30:40 +0000" MRTests_dateFromString]);
}

- (void)testImportDateAttributeWithCustomFormat
{
    XCTAssertEqualObjects(self.testEntity.dateWithCustomFormat, [@"2011-08-05 01:56:04 +0000" MRTests_dateFromString]);
}

- (void)testImportEpochDate
{
    XCTAssertEqualObjects(self.testEntity.unixTimeTestAttribute, [NSDate dateWithTimeIntervalSince1970:1388349428]);
}

- (void)testImportEpochDate13
{
    XCTAssertEqualObjects(self.testEntity.unixTime13TestAttribute, [NSDate dateWithTimeIntervalSince1970:1388349427.543]);
}

@end

@implementation NSString (MagicalRecordDateFormatter)

- (NSDate *)MRTests_dateFromString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    formatter.locale = [NSLocale currentLocale];

    NSDate *expectedDate = [formatter dateFromString:self];

    return expectedDate;
}

@end
