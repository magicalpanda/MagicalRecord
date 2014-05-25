//
//  Created by Tony Arnold on 21/12/2013.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>

#define EXP_SHORTHAND
#import "Expecta.h"

#import "MagicalRecord.h"

@class MagicalRecordStack;

@interface MagicalRecordTestBase : XCTestCase

@property(readwrite, nonatomic, strong) MagicalRecordStack *stack;

/**
 *  Setup and return a new Magical Record stack. Returns an in-memory stack by
 *  default. Subclasses can override this and return a suitable stack for
 *  the tests they are performing.
 *
 *  @return New instance of one of the MagicalRecordStack subclasses.
 */
+ (MagicalRecordStack *)newMagicalRecordStack;

@end
