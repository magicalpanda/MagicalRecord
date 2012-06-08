//
//  GHUnitIOSViewController.h
//  GHUnitIOS
//
//  Created by Gabriel Handford on 1/25/09.
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

#import "GHUnitIOSView.h"

#import "GHUnitIOSTableViewDataSource.h"
#import "GHUnitIOSTestViewController.h"

/*
 Main view controller for the iOS test application.
 */
@interface GHUnitIOSViewController : UIViewController <UITableViewDelegate, GHTestRunnerDelegate, UISearchBarDelegate> {
    
  GHUnitIOSView *view_;

  GHUnitIOSTableViewDataSource *dataSource_;
  GHTestSuite *suite_;
  
  UIBarButtonItem *runButton_;
  
  // If set then we will no longer auto scroll as tests are run
  BOOL userDidDrag_;
  
}

@property (retain, nonatomic) GHTestSuite *suite;

- (void)reloadTest:(id<GHTest>)test;

- (void)scrollToTest:(id<GHTest>)test;
- (void)scrollToBottom;

- (void)setStatusText:(NSString *)message;

- (void)runTests;

- (void)cancel;

- (void)reload;

- (void)loadDefaults;
- (void)saveDefaults;

- (GHUnitIOSTableViewDataSource *)dataSource;

@end

