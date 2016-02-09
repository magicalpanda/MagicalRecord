//
//  Created by Tony Arnold on 21/12/2013.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>

@interface MagicalRecordTestBase : XCTestCase

@property (readwrite, nonatomic, strong) MagicalRecordStack *stack;

@end
