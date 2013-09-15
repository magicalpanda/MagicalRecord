//
//  ImportSingleRelatedEntitySpec.m
//  MagicalRecord
//
//  Created by Tony Arnold on 20/08/2013.
//  Copyright 2013 Magical Panda Software LLC. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "SingleRelatedEntity.h"
#import "AbstractRelatedEntity.h"
#import "ConcreteRelatedEntity.h"
#import "MappedEntity.h"
#import "FixtureHelpers.h"

SpecBegin(ImportSingleRelatedEntity)

describe(@"ImportSingleRelatedEntity", ^{
    __block NSManagedObjectContext *managedObjectContext;
    __block SingleRelatedEntity    *singleTestEntity;

	beforeAll(^{
        [MagicalRecord setDefaultModelFromClass:[self class]];
        [MagicalRecord setupCoreDataStackWithInMemoryStore];

        managedObjectContext = [NSManagedObjectContext MR_defaultContext];
	});

    afterAll(^{
        [MagicalRecord cleanUp];
    });

    beforeEach(^{
        MappedEntity *testMappedEntity = [MappedEntity MR_createInContext:managedObjectContext];
        testMappedEntity.testMappedEntityIDValue = 42;
        testMappedEntity.sampleAttribute = @"This attribute created as part of the test case setup";

        id testEntityData = [self dataFromJSONFixture];
        singleTestEntity = [SingleRelatedEntity MR_importFromObject:testEntityData];

        [managedObjectContext MR_saveToPersistentStoreAndWait];

        expect(singleTestEntity).toNot.beNil();
    });

    afterEach(^{
        [NSManagedObjectContext MR_resetContextForCurrentThread];
        [NSManagedObjectContext MR_resetDefaultContext];
    });

	describe(@"should import an entity related to an abstract entity", ^{
        it(@"via a 'to one' relationship", ^{
            id testRelatedEntity = singleTestEntity.testAbstractToOneRelationship;

            expect(testRelatedEntity).toNot.beNil();
            expect([testRelatedEntity sampleBaseAttribute]).to.contain(@"BASE");
            expect([testRelatedEntity respondsToSelector:@selector(sampleConcreteAttribute)]).to.beFalsy();
        });

        it(@"via a 'to many' relationship", ^{
            expect(singleTestEntity.testAbstractToManyRelationship).to.haveCountOf(2);

            id testRelatedEntity = [singleTestEntity.testAbstractToManyRelationship anyObject];

            expect(testRelatedEntity).toNot.beNil();
            expect([testRelatedEntity sampleBaseAttribute]).to.contain(@"BASE");
            expect([testRelatedEntity respondsToSelector:@selector(sampleConcreteAttribute)]).to.beFalsy();
        });
    });

    describe(@"should import an entity related to a concrete sub-entity", ^{
        it(@"via a 'to one' relationship", ^{
            id testRelatedEntity = singleTestEntity.testConcreteToOneRelationship;

            expect(testRelatedEntity).toNot.beNil();
            expect([testRelatedEntity sampleBaseAttribute]).to.contain(@"BASE");
            expect([testRelatedEntity sampleBaseAttribute]).to.contain(@"DESCENDANT");
        });

        it(@"via a 'to many' relationship", ^{
            expect(singleTestEntity.testConcreteToManyRelationship).to.haveCountOf(3);

            id testRelatedEntity = [singleTestEntity.testConcreteToManyRelationship anyObject];

            expect(testRelatedEntity).toNot.beNil();
            expect([testRelatedEntity sampleBaseAttribute]).to.contain(@"BASE");
            expect([testRelatedEntity sampleBaseAttribute]).to.contain(@"DESCENDANT");
        });
    });
});

SpecEnd
