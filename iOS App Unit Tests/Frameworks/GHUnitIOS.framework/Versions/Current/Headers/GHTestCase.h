//
//  GHTestCase.h
//  GHUnit
//
//  Created by Gabriel Handford on 1/21/09.
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

//
// Portions of this file fall under the following license, marked with:
// GTM_BEGIN : GTM_END
//
//  Copyright 2008 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
// 
//  http://www.apache.org/licenses/LICENSE-2.0
// 
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

#import "GHTestMacros.h"
#import "GHTest.h"

/*!
 Log to your test case logger.
 For example,
 @code
 GHTestLog(@"Some debug info, %@", obj);
 @endcode
 */
#define GHTestLog(...) [self log:[NSString stringWithFormat:__VA_ARGS__, nil]]

/*!
 The base class for a test case. 
 
 @code
 @interface MyTest : GHTestCase {}
 @end
 
 @implementation MyTest
 
 // Run before each test method
 - (void)setUp { }

 // Run after each test method
 - (void)tearDown { }

 // Run before the tests are run for this class
 - (void)setUpClass { }

 // Run before the tests are run for this class
 - (void)tearDownClass { }
 
 // Tests are prefixed by 'test' and contain no arguments and no return value
 - (void)testA { 
   GHTestLog(@"Log with a test with the GHTestLog(...) for test specific logging.");
 }

 // Another test; Tests are run in lexical order
 - (void)testB { }
 
 // Override any exceptions; By default exceptions are raised, causing a test failure
 - (void)failWithException:(NSException *)exception { }
 
 @end
 @endcode

 */
@interface GHTestCase : NSObject {
  id<GHTestCaseLogWriter> logWriter_; // weak
  
  SEL currentSelector_;
}

//! The current test selector
@property (assign, nonatomic) SEL currentSelector; 
@property (assign, nonatomic) id<GHTestCaseLogWriter> logWriter;

// GTM_BEGIN
//! Run before each test method
- (void)setUp;

//! Run after each test method
- (void)tearDown;

/*! 
 By default exceptions are raised, causing a test failure
 @brief Override any exceptions
 @param exception Exception that was raised by test
 */
- (void)failWithException:(NSException*)exception;
// GTM_END

//! Run before the tests (once per test case)
- (void)setUpClass;

//! Run after the tests (once per test case)
- (void)tearDownClass;

/*!
 Whether to run the tests on a separate thread. Override this method in your
 test case to override the default.
 Default is NO, tests are run on a separate thread by default.
 @result If YES runs on the main thread
 */
- (BOOL)shouldRunOnMainThread;

//! Any special handling of exceptions after they are thrown; By default logs stack trace to standard out.
- (void)handleException:(NSException *)exception;

/*!
 Log a message, which notifies the log delegate.
 This is not meant to be used directly, see GHTestLog(...) macro.
 @param message
 */
- (void)log:(NSString *)message;

@end
