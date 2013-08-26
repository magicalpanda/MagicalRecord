//
//  NSManagedObject-MagicalRecordSpec.m
//  MagicalRecord
//
//  Created by Tony Arnold on 20/08/2013.
//  Copyright 2013 Magical Panda Software LLC. All rights reserved.
//

#define EXP_SHORTHAND
#import "Expecta.h"
#import "Specta.h"

// Project
#import "NSManagedObject+MagicalRecord.h"
#import "SingleEntityWithNoRelationships.h"

SpecBegin(NSManagedObjectMagicalRecord)

describe(@"NSManagedObject+MagicalRecord", ^{
	beforeAll(^{
        [MagicalRecord setDefaultModelFromClass:[self class]];
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
	});

    afterEach(^{
        [NSManagedObjectContext MR_resetContextForCurrentThread];
        [NSManagedObjectContext MR_resetDefaultContext];
    });

    afterAll(^{
        [MagicalRecord cleanUp];
    });

    describe(@"when retrieving an instance of a managed object from another context", ^{
        it(@"should return a managed object with a permanent object ID", ^{
            NSManagedObject *insertedEntity = [SingleEntityWithNoRelationships MR_createEntity];

            expect([[insertedEntity objectID] isTemporaryID]).to.beTruthy();

            [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {

                NSManagedObject *localEntity = [insertedEntity MR_inContext:localContext];
                expect([[localEntity objectID] isTemporaryID]).to.beFalsy();
            }];

        });
    });
});

SpecEnd
