//
//  GHTestViewController.h
//  GHKit
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

#import "GHTestViewModel.h"
#import "GHTestGroup.h"
#import "GHTestOutlineViewModel.h"

#import "BWSplitView.h"

@interface GHTestViewController : NSViewController <GHTestRunnerDelegate, GHTestOutlineViewModelDelegate> {

	IBOutlet BWSplitView *_splitView;
	IBOutlet NSView *_statusView;
	IBOutlet NSView *_detailsView;	
	IBOutlet NSOutlineView *_outlineView;	
	IBOutlet NSTextView *_textView;
	IBOutlet NSSegmentedControl *_textSegmentedControl;
  IBOutlet NSSegmentedControl *_segmentedControl;
  IBOutlet NSSearchField *_searchField;
	
	BOOL wrapInTextView_;		
	NSString *status_;
	double statusProgress_;
	BOOL runInParallel_;	
	NSString *runLabel_;
  
  NSString *exceptionFilename_;
  NSInteger exceptionLineNumber_;
	
	GHTestSuite *suite_;
	
	GHTestOutlineViewModel *dataSource_;
  BOOL running_;
}

@property (assign, nonatomic) BOOL wrapInTextView;
@property (readonly, nonatomic) id<GHTest> selectedTest;
@property (readonly, nonatomic) GHTestOutlineViewModel *dataSource;

@property (retain, nonatomic) NSString *status;
@property (assign, nonatomic) double statusProgress;
@property (retain, nonatomic) NSString *runLabel;

@property (retain, nonatomic) GHTestSuite *suite;
@property (assign, nonatomic, getter=isRunning) BOOL running;

@property (retain, nonatomic) NSString *exceptionFilename;
@property (assign, nonatomic) NSInteger exceptionLineNumber;


- (void)loadTestSuite;

- (void)selectFirstFailure;

- (IBAction)copy:(id)sender;
- (IBAction)runTests:(id)sender;
- (IBAction)toggleDetails:(id)sender;
- (IBAction)updateTextSegment:(id)sender;
- (IBAction)updateMode:(id)sender;
- (IBAction)updateSearchFilter:(id)sender;
- (IBAction)openExceptionFilename:(id)sender;
- (IBAction)rerunTest:(id)sender;

- (id<GHTest>)selectedTest;

- (void)runTests;

- (void)reload;

- (void)loadDefaults;
- (void)saveDefaults;

- (BOOL)isShowingDetails;

- (void)selectRow:(NSInteger)row;

@end
