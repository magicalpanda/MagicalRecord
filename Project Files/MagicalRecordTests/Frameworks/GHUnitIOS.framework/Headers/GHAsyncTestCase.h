//
//  GHAsyncTestCase.h
//  GHUnit
//
//  Created by Gabriel Handford on 4/8/09.
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

/*!
 Common wait statuses to use with waitForStatus:timeout:.
 */
enum {
  kGHUnitWaitStatusUnknown = 0, // Unknown wait status
  kGHUnitWaitStatusSuccess, // Wait status success
  kGHUnitWaitStatusFailure, // Wait status failure
  kGHUnitWaitStatusCancelled // Wait status cancelled
};

/*!
 Asynchronous test case with wait and notify.
 
 If notify occurs before wait has started (if it was a synchronous call), this test
 case will still work.

 Be sure to call prepare before the asynchronous method (otherwise an exception will raise).
 
     @interface MyAsyncTest : GHAsyncTestCase { }
     @end
     
     @implementation MyAsyncTest
     
     - (void)testSuccess {
       // Prepare for asynchronous call
       [self prepare];
       
       // Do asynchronous task here
       [self performSelector:@selector(_succeed) withObject:nil afterDelay:0.1];
       
       // Wait for notify
       [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
     }
     
     - (void)_succeed {
       // Notify the wait. Notice the forSelector points to the test above. 
       // This is so that stray notifies don't error or falsely succeed other tests.
       // To ignore the check, forSelector can be NULL.
       [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testSuccess)];
     }
     
     @end

 */
@interface GHAsyncTestCase : GHTestCase {

  NSInteger waitForStatus_;
  NSInteger notifiedStatus_;
  
  BOOL prepared_; // Whether prepared was called before waitForStatus:timeout:
  NSRecursiveLock *lock_; // Lock to synchronize on
  SEL waitSelector_; // The selector we are waiting on
    
  NSArray *_runLoopModes;
}

/*!
 Run loop modes to run while waiting; 
 Defaults to NSDefaultRunLoopMode, NSRunLoopCommonModes, NSConnectionReplyMode
 */
@property (retain, nonatomic) NSArray *runLoopModes; 

/*!
 Prepare before calling the asynchronous method. 
 */
- (void)prepare;

/*!
 Prepare and specify the selector we will use in notify.

 @param selector Selector
 */
- (void)prepare:(SEL)selector;

/*!
 Wait for notification of status or timeout.
 
 Be sure to prepare before calling your asynchronous method.
 For example, 
 
    - (void)testFoo {
      [self prepare];
 
      // Do asynchronous task here
 
      [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
    }
 
 @param status kGHUnitWaitStatusSuccess, kGHUnitWaitStatusFailure or custom status 
 @param timeout Timeout in seconds
 */
- (void)waitForStatus:(NSInteger)status timeout:(NSTimeInterval)timeout;

/*! 
 @param status kGHUnitWaitStatusSuccess, kGHUnitWaitStatusFailure or custom status 
 @param timeout Timeout in seconds
 @deprecated Use waitForTimeout:
 */
- (void)waitFor:(NSInteger)status timeout:(NSTimeInterval)timeout;

/*!
 Wait for timeout to occur.
 Fails if we did _NOT_ timeout.

 @param timeout Timeout
 */
- (void)waitForTimeout:(NSTimeInterval)timeout;

/*!
 Notify waiting of status for test selector.

 @param status Status, for example, kGHUnitWaitStatusSuccess
 @param selector If not NULL, then will verify this selector is where we are waiting. This prevents stray asynchronous callbacks to fail a later test.
 */
- (void)notify:(NSInteger)status forSelector:(SEL)selector;

/*!
 Notify waiting of status for any selector.

 @param status Status, for example, kGHUnitWaitStatusSuccess
 */
- (void)notify:(NSInteger)status;

/*!
 Run the run loops for the specified interval.

 @param interval Interval
 @author Adapted from Robert Palmer, pauseForTimeout
 */
- (void)runForInterval:(NSTimeInterval)interval;

@end
