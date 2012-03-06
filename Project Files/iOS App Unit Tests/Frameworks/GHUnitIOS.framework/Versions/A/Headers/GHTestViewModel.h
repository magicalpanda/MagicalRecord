//
//  GHTest.h
//  GHUnit
//
//  Created by Gabriel Handford on 1/17/09.
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

#import "GHTestGroup.h"
#import "GHTestSuite.h"
#import "GHTestRunner.h"

@class GHTestNode;

@protocol GHTestNodeDelegate <NSObject>
- (void)testNodeDidChange:(GHTestNode *)node;
@end

typedef enum {
  GHTestNodeFilterNone = 0,
  GHTestNodeFilterFailed = 1
} GHTestNodeFilter;

/*!
 Test view model for use in a tree view.
 */
@interface GHTestViewModel : NSObject <GHTestNodeDelegate> {
	
  NSString *identifier_;
	GHTestSuite *suite_;
	GHTestNode *root_;
	
	GHTestRunner *runner_;
	
	NSMutableDictionary *map_; // id<GHTest>#identifier -> GHTestNode

	BOOL editing_;

	NSMutableDictionary *defaults_;
}

@property (readonly, nonatomic) GHTestNode *root;
@property (assign, nonatomic, getter=isEditing) BOOL editing;

/*!
 Create view model with root test group node.

 @param identifier Unique identifier for test model (used to load defaults)
 @param suite Suite
 */
- (id)initWithIdentifier:(NSString *)identifier suite:(GHTestSuite *)suite;

/*!
 @result Name of test suite.
 */
- (NSString *)name;

/*!
 Status description.

 @param prefix Prefix to append
 @result Current status string
 */
- (NSString *)statusString:(NSString *)prefix;

/*!
 Find the test node from the test.

 @param test Find test
 */
- (GHTestNode *)findTestNodeForTest:(id<GHTest>)test;

/*!
 Find the first failure.

 @result The first failure
 */
- (GHTestNode *)findFailure;

/*!
 Find the next failure starting from node.

 @param node Node to start from
 */
- (GHTestNode *)findFailureFromNode:(GHTestNode *)node;

/*!
 Register node, so that we can do a lookup later. See findTestNodeForTest:.

 @param node Node to register
 */
- (void)registerNode:(GHTestNode *)node;

/*!
 @result Returns the number of test groups.
 */
- (NSInteger)numberOfGroups;

/*!
 Returns the number of tests in group.
 @param group Group number
 @result The number of tests in group.
 */
- (NSInteger)numberOfTestsInGroup:(NSInteger)group;

/*!
 Search for path to test.
 @param test Test
 @result Index path
 */
- (NSIndexPath *)indexPathToTest:(id<GHTest>)test;

/*!
 Load defaults (user settings saved with saveDefaults).
 */
- (void)loadDefaults;

/*!
 Save defaults (user settings to be loaded with loadDefaults).
 */
- (void)saveDefaults;

/*!
 Run with current test suite.

 @param delegate Callback
 @param inParallel If YES, will run tests in operation queue
 @param options Options
 */
- (void)run:(id<GHTestRunnerDelegate>)delegate inParallel:(BOOL)inParallel options:(GHTestOptions)options;

/*!
 Cancel test run.
 */
- (void)cancel;

/*!
 Check if running.

 @result YES if running.
 */
- (BOOL)isRunning;

@end


@interface GHTestNode : NSObject {

	id<GHTest> test_;
	NSMutableArray */*of GHTestNode*/children_;
  NSMutableArray */* of GHTestNode*/filteredChildren_;

	id<GHTestNodeDelegate> delegate_;
  GHTestNodeFilter filter_;
  NSString *textFilter_;
}

@property (readonly, nonatomic) NSArray */* of GHTestNode*/children;
@property (readonly, nonatomic) id<GHTest> test;
@property (assign, nonatomic) id<GHTestNodeDelegate> delegate;
@property (assign, nonatomic) GHTestNodeFilter filter;
@property (retain, nonatomic) NSString *textFilter;

- (id)initWithTest:(id<GHTest>)test children:(NSArray */*of id<GHTest>*/)children source:(GHTestViewModel *)source;
+ (GHTestNode *)nodeWithTest:(id<GHTest>)test children:(NSArray */*of id<GHTest>*/)children source:(GHTestViewModel *)source;

- (NSString *)identifier;
- (NSString *)name;
- (NSString *)nameWithStatus;

- (GHTestStatus)status;
- (NSString *)statusString;
- (NSString *)stackTrace;
- (NSString *)exceptionFilename;
- (NSInteger)exceptionLineNumber;
- (NSString *)log;
- (BOOL)isRunning;
- (BOOL)isDisabled;
- (BOOL)isHidden;
- (BOOL)isEnded;
- (BOOL)isGroupTest; // YES if test has "sub tests"

- (BOOL)isSelected;
- (void)setSelected:(BOOL)selected;

- (BOOL)hasChildren;
- (BOOL)failed;

- (void)notifyChanged;

- (void)setFilter:(GHTestNodeFilter)filter textFilter:(NSString *)textFilter;

@end

//! @endcond
