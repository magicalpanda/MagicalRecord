//
//  GHNSObject+Invocation.h
//  GHKit
//
//  Created by Gabriel Handford on 1/18/09.
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

#import "GHNSInvocation+Utils.h"
#import "GHNSInvocationProxy.h"

/*!
 Adds performSelector methods that take a nil-terminated variable argument list,
 for when you need to pass more arguments to performSelector.
 */
@interface NSObject (GHInvocation_GHUNIT)

/*!
 Perform selector if responds.
 @param selector
 @result nil if we don't respond to the selector, otherwise the selector result
 */
- (id)ghu_performIfRespondsToSelector:(SEL)selector;

/*!
 Perform selector if responds with multiple arguments.
 @param selector
 @param withObjects nil terminated variable argument list 
 @result nil if we don't respond to the selector, otherwise the selector result
 */
- (id)ghu_performIfRespondsToSelector:(SEL)selector withObjects:object, ...;

/*!
 Invoke selector with arguments.
 @param selector
 @param withObjects nil terminated variable argument list 
 */
- (id)ghu_performSelector:(SEL)selector withObjects:object, ...;

- (id)ghu_performSelector:(SEL)selector afterDelay:(NSTimeInterval)delay withObjects:object, ...;

/*!
 Invoke selector with arguments on main thread.
 Does not wait until selector is finished.
 @param selector
 @param withObjects nil terminated variable argument list 
 */
- (void)ghu_performSelectorOnMainThread:(SEL)selector withObjects:object, ...;

/*!
 Invoke selector with arguments on main thread.
 @param selector
 @param waitUntilDone Whether to join on selector and wait for it to finish.
 @param withObjects nil terminated variable argument list 
 */
- (void)ghu_performSelectorOnMainThread:(SEL)selector waitUntilDone:(BOOL)waitUntilDone withObjects:object, ...;


- (void)ghu_performSelector:(SEL)selector onMainThread:(BOOL)onMainThread waitUntilDone:(BOOL)waitUntilDone withObjects:object, ...;

- (void)ghu_performSelector:(SEL)selector onMainThread:(BOOL)onMainThread waitUntilDone:(BOOL)waitUntilDone arguments:(NSArray *)arguments;

- (void)ghu_performSelector:(SEL)selector onMainThread:(BOOL)onMainThread waitUntilDone:(BOOL)waitUntilDone 
								afterDelay:(NSTimeInterval)delay arguments:(NSArray *)arguments;


// Invocation proxies

- (id)ghu_proxyOnMainThread;
- (id)ghu_proxyOnMainThread:(BOOL)waitUntilDone;
- (id)ghu_proxyOnThread:(NSThread *)thread;
- (id)ghu_proxyOnThread:(NSThread *)thread waitUntilDone:(BOOL)waitUntilDone;
- (id)ghu_proxyAfterDelay:(NSTimeInterval)delay;

// Debug proxies
- (id)ghu_timedProxy:(NSTimeInterval *)time;
- (id)ghu_debugProxy:(NSTimeInterval *)time proxy:(GHNSInvocationProxy_GHUNIT **)proxy;

@end
