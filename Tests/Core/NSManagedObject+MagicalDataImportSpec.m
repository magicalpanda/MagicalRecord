//
//  NSManagedObject+MagicalDataImportSpec.m
//  MagicalRecord
//
//  Created by Tony Arnold on 21/08/2013.
//  Copyright 2013 Magical Panda Software LLC. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "NSManagedObject+MagicalDataImport.h"

SpecBegin(NSManagedObjectMagicalDataImport)

describe(@"NSManagedObject+MagicalDataImport", ^{
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
});

SpecEnd
