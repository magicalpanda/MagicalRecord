//
//  ImportSingleEntityWithRelatedEntitiesTests.m
//  Magical Record
//
//  Created by Saul Mora on 7/23/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordDataImportTestCase.h"
#import "SingleRelatedEntity.h"
#import "AbstractRelatedEntity.h"
#import "ConcreteRelatedEntity.h"
#import "MappedEntity.h"

@interface ImportSingleRelatedEntityTests : MagicalRecordDataImportTestCase

@property (nonatomic, retain) SingleRelatedEntity *singleTestEntity;

@end

@implementation ImportSingleRelatedEntityTests

@synthesize singleTestEntity = _singleTestEntity;

- (void)setUp
{
    [super setUp];

    NSManagedObjectContext *stackContext = self.stack.context;

    self.singleTestEntity = [SingleRelatedEntity MR_importFromObject:self.testEntityData inContext:stackContext];

    expect(self.singleTestEntity).toNot.beNil();
}

- (void)testImportAnEntityRelatedToAbstractEntityViaToOneRelationshop
{
    AbstractRelatedEntity *relatedEntity = self.singleTestEntity.testAbstractToOneRelationship;

    expect(relatedEntity).toNot.beNil();
    expect(relatedEntity).to.beKindOf([AbstractRelatedEntity class]);
    expect(relatedEntity).to.respondTo(@selector(sampleBaseAttribute));
    expect(relatedEntity.sampleBaseAttribute).to.contain(@"BASE");
}

- (void)testImportAnEntityRelatedToAbstractEntityViaToManyRelationship
{
    XCTAssertNotNil(self.singleTestEntity, @"singleTestEntity should not be nil");

    NSUInteger relationshipCount = [self.singleTestEntity.testAbstractToManyRelationship count];
    XCTAssertEqual(relationshipCount, (NSUInteger)2, @"Expected relationship count to be 2, received %zd", relationshipCount);

    id testRelatedEntity = [self.singleTestEntity.testAbstractToManyRelationship anyObject];

    XCTAssertNotNil(testRelatedEntity, @"testRelatedEntity should not be nil");

    NSRange stringRange = [[testRelatedEntity sampleBaseAttribute] rangeOfString:@"BASE"];
    XCTAssertTrue(stringRange.length > 0, @"Expected to find 'BASE' in string '%@' but did not", [testRelatedEntity sampleBaseAttribute]);

    XCTAssertFalse([testRelatedEntity respondsToSelector:@selector(sampleConcreteAttribute)], @"testRelatedEntity should respond to selector sampleConcreteAttribute");
}

#pragma mark - Subentity tests

- (void)testImportAnEntityRelatedToAConcreteSubEntityViaToOneRelationship
{
    id testRelatedEntity = self.singleTestEntity.testConcreteToOneRelationship;

    XCTAssertNotNil(testRelatedEntity, @"testRelatedEntity should not be nil");

    NSRange stringRange = [[testRelatedEntity sampleBaseAttribute] rangeOfString:@"BASE"];
    XCTAssertTrue(stringRange.length > 0, @"Expected to find 'BASE' in string '%@' but did not", [testRelatedEntity sampleBaseAttribute]);

    stringRange = [[testRelatedEntity sampleConcreteAttribute] rangeOfString:@"DESCENDANT"];
    XCTAssertTrue(stringRange.length > 0, @"Expected to find 'DESCENDANT' in string '%@' but did not", [testRelatedEntity sampleConcreteAttribute]);
}

- (void)testImportAnEntityRelatedToASubEntityViaToManyRelationship
{
    NSUInteger relationshipCount = [self.singleTestEntity.testConcreteToManyRelationship count];
    XCTAssertEqual(relationshipCount, (NSUInteger)3, @"Expected relationship count to be 3, received %zd", relationshipCount);

    id testRelatedEntity = [self.singleTestEntity.testConcreteToManyRelationship anyObject];
    XCTAssertNotNil(testRelatedEntity, @"testRelatedEntity should not be nil");

    NSRange stringRange = [[testRelatedEntity sampleBaseAttribute] rangeOfString:@"BASE"];
    XCTAssertTrue(stringRange.length > 0, @"Expected to find 'BASE' in string '%@' but did not", [testRelatedEntity sampleBaseAttribute]);

    stringRange = [[testRelatedEntity sampleConcreteAttribute] rangeOfString:@"DESCENDANT"];
    XCTAssertTrue(stringRange.length > 0, @"Expected to find 'DESCENDANT' in string '%@' but did not", [testRelatedEntity sampleConcreteAttribute]);
}

// TODO: Test ordered to many relationships

@end
