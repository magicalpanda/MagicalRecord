//
//  GHMockNSURLConnection.h
//  GHUnit
//
//  Created by Gabriel Handford on 4/9/09.
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

#import <Foundation/Foundation.h>

extern NSString *const GHMockNSURLConnectionException;

/*!
 NSURLConnection for mocking.
 
 Use with GHAsyncTestCase to mock out connections.
 
     @interface GHNSURLConnectionMockTest : GHAsyncTestCase {}
     @end
     
     @implementation GHNSURLConnectionMockTest
     
     - (void)testMock {
       [self prepare];
       GHMockNSURLConnection *connection = [[GHMockNSURLConnection alloc] initWithRequest:nil delegate:self];	
       [connection receiveHTTPResponseWithStatusCode:204 headers:testHeaders_ afterDelay:0.1];
       [connection receiveData:testData_ afterDelay:0.2];
       [connection finishAfterDelay:0.3];
       [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
     }
     
     - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
       GHAssertEquals([(NSHTTPURLResponse *)response statusCode], 204, nil);
       GHAssertEqualObjects([(NSHTTPURLResponse *)response allHeaderFields], testHeaders_, nil);
     }
     
     - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
       GHAssertEqualObjects(data, testData_, nil);
     }
     
     - (void)connectionDidFinishLoading:(NSURLConnection *)connection {
       [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testMock)];
     }
     @end

 */
@interface GHMockNSURLConnection : NSObject {
	NSURLRequest *request_;
	id delegate_; // weak
	
	BOOL cancelled_;	
	BOOL started_;
}

@property (readonly, nonatomic, getter=isStarted) BOOL started;
@property (readonly, nonatomic, getter=isCancelled) BOOL cancelled;

// Mocked version of NSURLConnection#initWithRequest:delegate:
- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate;

// Mocked version of NSURLConnection#initWithRequest:delegate:startImmediately:
- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately;

// Mocked version of NSURLConnection#scheduleInRunLoop:forMode: (NOOP)
- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode;

// Mocked version of NSURLConnection#start (NOOP)
- (void)start;

/*!
 Send generic response to delegate after delay.
 (For asynchronous requests)
 @param response Response
 @param afterDelay Delay in seconds (if < 0, there is no delay)
 */
- (void)receiveResponse:(NSURLResponse *)response afterDelay:(NSTimeInterval)afterDelay;

/*!
 Send HTTP response to delegate with status code, headers, after delay.
 This is only the HTTP response (and not data or finished).
 (For asynchronous requests)
 @param statusCode HTTP status code
 @param headers Headers
 @param afterDelay Delay in seconds (if < 0, there is no delay)
 */
- (void)receiveHTTPResponseWithStatusCode:(int)statusCode headers:(NSDictionary *)headers afterDelay:(NSTimeInterval)afterDelay;

/*!
 Send data to connection delegate after delay.
 @param data Data to send
 @param afterDelay Delay in seconds
 */
- (void)receiveData:(NSData *)data afterDelay:(NSTimeInterval)afterDelay;

/*!
 Send data to connection delegate.
 @param data Data to send
 @param statusCode HTTP status code
 @param MIMEType Mime type
 @param afterDelay Delay
 */
- (void)receiveData:(NSData *)data statusCode:(NSInteger)statusCode MIMEType:(NSString *)MIMEType afterDelay:(NSTimeInterval)afterDelay;

/*!
 Send data (from file in bundle resource) to connection delegate after delay.
 (For asynchronous requests)
 @param path Path to file
 @param afterDelay Delay in seconds
 */
- (void)receiveDataFromPath:(NSString *)path afterDelay:(NSTimeInterval)afterDelay;

/*!
 Calls connectionDidFinish: delegate after delay.
 (For asynchronous requests)
 @param delay Delay in seconds (if < 0, there is no delay)
 */
- (void)finishAfterDelay:(NSTimeInterval)delay;

/*!
 Sends mock response, sends data, and then calls finish.
 (For asynchronous requests)
 @param path Path to load data from. File should be available in Test target (bundle)
 @param statusCode Status code for response
 @param MIMEType Content type for response header
 @param afterDelay Delay before responding (if < 0, there is no delay)
 */
- (void)receiveFromPath:(NSString *)path statusCode:(NSInteger)statusCode MIMEType:(NSString *)MIMEType afterDelay:(NSTimeInterval)afterDelay;

/*!
 Sends mock response, sends data, and then calls finish.
 (For asynchronous requests)
 @param data Data to load. File should be available in Test target (bundle)
 @param statusCode Status code for response
 @param MIMEType Content type for response header
 @param afterDelay Delay before responding (if < 0, there is no delay)
 */ 
- (void)receiveData:(NSData *)data statusCode:(NSInteger)statusCode MIMEType:(NSString *)MIMEType afterDelay:(NSTimeInterval)afterDelay;

/*!
 Calls connection:didFailWithError: on delegate after specified delay.
 @param error The error to pass to the delegate.
 @param afterDelay Delay before responding (if < 0, there is no delay)
 */
- (void)failWithError:(NSError *)error afterDelay:(NSTimeInterval)afterDelay;

@end
