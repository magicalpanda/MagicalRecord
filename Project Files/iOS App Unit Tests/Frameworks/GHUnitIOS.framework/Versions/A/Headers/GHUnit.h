//
//  GHUnit.h
//  GHUnit
//
//  Created by Gabriel Handford on 1/19/09.
//  Copyright 2009. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "GHTestCase.h"
#import "GHAsyncTestCase.h"
#import "GHTestSuite.h"
#import "GHTestMacros.h"
#import "GHTestRunner.h"

#import "GHTest.h"
#import "GHTesting.h"
#import "GHTestOperation.h"
#import "GHTestGroup.h"
#import "GHTest+JUnitXML.h"
#import "GHTestGroup+JUnitXML.h"
#import "NSException+GHTestFailureExceptions.h"
#import "NSValue+GHValueFormatter.h"

#if TARGET_OS_IPHONE
#import "GHUnitIOSAppDelegate.h"
#import "GHViewTestCase.h"
#endif

#ifdef DEBUG
#define GHUDebug(fmt, ...) do { \
fputs([[[NSString stringWithFormat:fmt, ##__VA_ARGS__] stringByAppendingString:@"\n"] UTF8String], stdout); \
} while(0)
#else
#define GHUDebug(fmt, ...) do {} while(0)
#endif
