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
#import "MagicalRecordStack.h"

SpecBegin(NSManagedObjectMagicalDataImport)

describe(@"NSManagedObject+MagicalDataImport", ^{

    __block MagicalRecordStack *stack = nil;

	beforeAll(^{
        stack = [MagicalRecord setupStackWithInMemoryStore];
        [stack setModelFromClass:[self class]];
	});

    afterAll(^{
        [stack reset];
    });
});

SpecEnd
