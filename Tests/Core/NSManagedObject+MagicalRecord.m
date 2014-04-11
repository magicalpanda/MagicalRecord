//
//  Created by Tony Arnold on 11/04/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordTestBase.h"
#import "NSManagedObject+MagicalRecord.h"

#import "DifferentClassNameMapping.h"
#import "EntityWithoutEntityNameMethod.h"

@interface NSManagedObjectMagicalRecord : MagicalRecordTestBase

@end

@implementation NSManagedObjectMagicalRecord

- (void)testThatInternalEntityNameReturnsClassNameWhenEntityNameMethodIsNotImplemented
{
    expect([EntityWithoutEntityNameMethod class]).toNot.respondTo(@selector(entityName));
    expect([EntityWithoutEntityNameMethod MR_internalEntityName]).to.equal(NSStringFromClass([EntityWithoutEntityNameMethod class]));
}

- (void)testThatInternalEntityNameReturnsProvidedNameWhenEntityNameMethodIsImplemented
{
    expect([DifferentClassNameMapping class]).to.respondTo(@selector(entityName));
    expect([DifferentClassNameMapping MR_internalEntityName]).toNot.equal(NSStringFromClass([DifferentClassNameMapping class]));
    expect([DifferentClassNameMapping MR_internalEntityName]).to.equal([DifferentClassNameMapping entityName]);
}

@end
