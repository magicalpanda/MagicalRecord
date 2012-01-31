//
//  GHTestGroup.h
//
//  Created by Gabriel Handford on 1/16/09.
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

//! @cond DEV

#import "GHTest.h"
#import "GHTestCase.h"

/*!
 @brief Interface for a group of tests.

 This group conforms to the GHTest protocol as well (see Composite pattern).
 */
@protocol GHTestGroup <GHTest>
- (NSString *)name;
- (id<GHTestGroup>)parent;
- (NSArray *)children;
@end

/*!
 @brief A collection of tests (or test groups).

 A test group is a collection of id<GHTest>, that may represent a set of test case methods. 
 
 For example, if you had the following GHTestCase.

 @code
 @interface FooTest : GHTestCase {}
 - (void)testFoo;
 - (void)testBar;
 @end
 @endcode
 
 The GHTestGroup would consist of and array of GHTest, [FooTest#testFoo and FooTest#testBar], 
 each test being a target and selector pair.

 A test group may also consist of a group of groups (since GHTestGroup conforms to GHTest),
 and this might represent a GHTestSuite.
 */
@interface GHTestGroup : NSObject <GHTestDelegate, GHTestGroup> {
  
  NSObject<GHTestDelegate> *delegate_; // weak
  id<GHTestGroup> parent_; // weak
  
  NSMutableArray */*of id<GHTest>*/children_;
    
  NSString *name_; // The name of the test group (usually the class name of the test case
  NSTimeInterval interval_; // Total time of child tests
  GHTestStatus status_; // Current status of the group (current status of running or completed child tests)
  GHTestStats stats_; // Current stats for the group (aggregate of child test stats)
  
  BOOL didSetUpClass_;
  
  GHTestOptions options_;
  
  // Set if test is created from initWithTestCase:delegate:
  // Allows use to perform setUpClass and tearDownClass (once per test case run)
  id testCase_; 
  
  NSException *exception_; // If exception happens in group setUpClass/tearDownClass
}

@property (readonly, nonatomic) NSArray */*of id<GHTest>*/children;
@property (assign, nonatomic) id<GHTestGroup> parent;
@property (readonly, nonatomic) id testCase;
@property (assign, nonatomic) GHTestOptions options;

/*!
 Create an empty test group.
 @param name The name of the test group
 @param delegate Delegate, notifies of test start and end
 @result New test group
 */
- (id)initWithName:(NSString *)name delegate:(id<GHTestDelegate>)delegate;

/*!
 Create test group from a test case.
 @param testCase Test case, could be a subclass of SenTestCase or GHTestCase
 @param delegate Delegate, notifies of test start and end
 @result New test group
 */
- (id)initWithTestCase:(id)testCase delegate:(id<GHTestDelegate>)delegate;

/*!
 Create test group from a single test.
 @param testCase
 @param selector Test to run 
 @param delegate
 */
- (id)initWithTestCase:(id)testCase selector:(SEL)selector delegate:(id<GHTestDelegate>)delegate;

/*!
 Create test group from a test case.
 @param testCase Test case, could be a subclass of SenTestCase or GHTestCase
 @param delegate Delegate, notifies of test start and end
 @result New test group
 */
+ (GHTestGroup *)testGroupFromTestCase:(id)testCase delegate:(id<GHTestDelegate>)delegate;

/*!
 Add a test case (or test group) to this test group.
 @param testCase Test case, could be a subclass of SenTestCase or GHTestCase
 */
- (void)addTestCase:(id)testCase;

/*!
 Add a test group to this test group.
 @param testGroup Test group to add
 */
- (void)addTestGroup:(GHTestGroup *)testGroup;

/*!
 Add tests to this group.
 @param tests Tests to add
 */
- (void)addTests:(NSArray */*of id<GHTest>*/)tests;

/*!
 Add test to this group.
 @param test Test to add
 */
- (void)addTest:(id<GHTest>)test;

/*!
 Whether the test group should run on the main thread.
 Call passes to test case instance if enabled.
 */
- (BOOL)shouldRunOnMainThread;

/*!
 @result YES if we have any enabled chilren, NO if all children have been disabled.
 */
- (BOOL)hasEnabledChildren;

/*!
 Get list of failed tests.
 @result Failed tests
 */
- (NSArray */*of id<GHTest>*/)failedTests;

/*!
 Run in operation queue.
 Tests from the group are added and will block until they have completed.
 @param operationQueue If nil, then runs as is
 @param options Options
 */
- (void)runInOperationQueue:(NSOperationQueue *)operationQueue options:(GHTestOptions)options;

@end

//! @endcond
