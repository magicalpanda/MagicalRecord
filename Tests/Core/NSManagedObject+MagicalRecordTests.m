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

// +[NSManagedObject(_PFDynamicAccessorsAndPropertySupport) entityName] was subsequently added in iOS 10 and macOS 10.12
// so this expectation has become obsolete
/*
- (void)testThatInternalEntityNameReturnsClassNameWhenEntityNameMethodIsNotImplemented
{
    XCTAssertNotNil([EntityWithoutEntityNameMethod MR_entityName]);
    XCTAssertEqualObjects([EntityWithoutEntityNameMethod MR_entityName], NSStringFromClass([EntityWithoutEntityNameMethod class]));
}
*/

- (void)testThatInternalEntityNameReturnsProvidedNameWhenEntityNameMethodIsImplemented
{
    XCTAssertNotNil([EntityWithoutEntityNameMethod MR_entityName]);
    XCTAssertNotEqualObjects([DifferentClassNameMapping MR_entityName], NSStringFromClass([DifferentClassNameMapping class]));
    XCTAssertEqualObjects([DifferentClassNameMapping MR_entityName], [DifferentClassNameMapping entityName]);
}

@end
