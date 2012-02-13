//
//  GHNSInvocationProxy_GHUNIT.h
//  GHKit
//
//  Modified by Gabriel Handford on 5/9/09.
//  This class is based on DDInvocationGrabber.
//

/*
 * Copyright (c) 2007-2009 Dave Dribin
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */


/*
 *  This class is based on CInvocationGrabber:
 *
 *  Copyright (c) 2007, Toxic Software
 *  All rights reserved.
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are
 *  met:
 *  
 *  * Redistributions of source code must retain the above copyright notice,
 *  this list of conditions and the following disclaimer.
 *  
 *  * Redistributions in binary form must reproduce the above copyright
 *  notice, this list of conditions and the following disclaimer in the
 *  documentation and/or other materials provided with the distribution.
 *  
 *  * Neither the name of the Toxic Software nor the names of its
 *  contributors may be used to endorse or promote products derived from
 *  this software without specific prior written permission.
 *  
 *  THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 *  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE
 *  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 *  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 *  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 *  THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

/*!
 Proxy that allows invocation on a separate thread, or with a delay.
 
 Use with the GHNSObject+Invocation category:
 
 @code
 NSMutableArray *array = ...; 
 // Adds object to array after 5 seconds
 [[array ghu_proxyAfterDelay:5.0] addObject:@"test"];
 
 
 NSThread *thread = ...
 // Remove all objects from another thread
 [[array ghu_proxyOnThread:thread waitUntilDone:NO] removeAllObjects];
 @endcode
 
 Create invocation proxy for a NSMutableArray.
 
 @code 
 NSMutableArray *array = ...;
 NSThread *thread = ...
 
 GHNSInvocationProxy_GHUNIT *arrayProxy = [GHNSInvocationProxy_GHUNIT invocation];
 arrayProxy.target = array;
 arrayProxy.thread = thread;
 arrayProxy.waitUntilDone = NO;

 // Performs method on thread and doesn't wait for return
 [arrayProxy addObject:@"test"];
 @endcode
 */
@interface GHNSInvocationProxy_GHUNIT : NSProxy {
	
	id target_;

	NSThread *thread_;
	BOOL waitUntilDone_;
	NSTimeInterval delay_;
	
	// If debuging time to set
	NSTimeInterval *time_;
	
	NSInvocation *invocation_;
}

@property (retain, nonatomic) id target;
@property (retain, nonatomic) NSInvocation *invocation;
@property (retain, nonatomic) NSThread *thread;
@property (assign, nonatomic) BOOL waitUntilDone;
@property (assign, nonatomic) NSTimeInterval delay;
@property (assign, nonatomic) NSTimeInterval *time;

/*!
 Create autoreleased empty invocation proxy.
 @result Invocation proxy
 */
+ (id)invocation;

/*!
 Create invocation proxy with target.
 @param target
 @result Invocation proxy
 */
- (id)prepareWithInvocationTarget:(id)target;

@end
