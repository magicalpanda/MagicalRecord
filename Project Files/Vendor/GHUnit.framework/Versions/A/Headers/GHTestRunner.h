//
//  GHTestRunner.h
//
//  Created by Gabriel Handford on 1/16/09.
//  Copyright 2008 Gabriel Handford
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

//! @cond DEV

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

#import "GHTestGroup.h"
#import "GHTestSuite.h"

@class GHTestRunner;

// Delegates can be guaranteed to be notified on the main thread (using #delegateOnMainThread)
@protocol GHTestRunnerDelegate <NSObject>
@optional
- (void)testRunnerDidStart:(GHTestRunner *)runner;
- (void)testRunner:(GHTestRunner *)runner didStartTest:(id<GHTest>)test; // Test started
- (void)testRunner:(GHTestRunner *)runner didUpdateTest:(id<GHTest>)test; // Test changed
- (void)testRunner:(GHTestRunner *)runner didEndTest:(id<GHTest>)test; // Test finished
- (void)testRunnerDidCancel:(GHTestRunner *)runner;
- (void)testRunnerDidEnd:(GHTestRunner *)runner;

- (void)testRunner:(GHTestRunner *)runner didLog:(NSString *)message; // Runner logged message
- (void)testRunner:(GHTestRunner *)runner test:(id<GHTest>)test didLog:(NSString *)message; // Test logged message
@end

/*!
 Runs the tests.
 Tests are run a separate thread though delegates are called on the 
 main thread by default (see #delegateOnMainThread).
 */
@interface GHTestRunner : NSObject <GHTestDelegate> { 
  
  id<GHTest> test_; // The test to run; Could be a GHTestGroup (suite), GHTestGroup (test case), or GHTest (target/selector)
  
  NSObject<GHTestRunnerDelegate> *delegate_; // weak
    
  GHTestOptions options_; 
  
  BOOL running_;
  BOOL cancelling_;
  
  NSTimeInterval startInterval_;
  
  NSOperationQueue *operationQueue_; //! If running a suite in operation queue
}

@property (retain) id<GHTest> test;
@property (assign) NSObject<GHTestRunnerDelegate> *delegate;
@property (assign) GHTestOptions options;
@property (readonly) GHTestStats stats;
@property (readonly, getter=isRunning) BOOL running;
@property (readonly, getter=isCancelling) BOOL cancelling;
@property (readonly) NSTimeInterval interval;
@property (retain, nonatomic) NSOperationQueue *operationQueue;


/*!
 Create runner for test.
 @param test
 */
- (id)initWithTest:(id<GHTest>)test;

/*!
 Create runner for all tests.
 @see GHTesting#loadAllTestCases.
 @result Runner
 */
+ (GHTestRunner *)runnerForAllTests;

/*!
 Create runner for test suite.
 @param suite
 @result Runner
 */
+ (GHTestRunner *)runnerForSuite:(GHTestSuite *)suite;

/*!
 Create runner for class and method.
 @param testClassName
 @param methodName
 @result Runner
 */
+ (GHTestRunner *)runnerForTestClassName:(NSString *)testClassName methodName:(NSString *)methodName;

/*!
 Get the runner from the environment.
 If the TEST env is set, then we will only run that test case or test method.
 */
+ (GHTestRunner *)runnerFromEnv;

/*!
 Run the test runner. Usually called from the test main.
 Reads the TEST environment variable and filters on that; or all tests are run.
 @result 0 is success, otherwise the failure count
 */
+ (int)run;

- (void)runInBackground;

/*!
 Start the test runner with the default test.
 @result 0 is success, otherwise the failure count
 */
- (int)runTests;

- (void)cancel;

- (void)setInParallel:(BOOL)inParallel;
- (BOOL)isInParallel;

/*!
 Write message to console.
 */
- (void)log:(NSString *)message;

@end

//! @endcond

