//
//  GHTestMacros.h
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

//
// Portions of this file fall under the following license, marked with
// SENTE_BEGIN - SENTE_END
//
// Copyright (c) 1997-2005, Sen:te (Sente SA).  All rights reserved.
//
// Use of this source code is governed by the following license:
// 
// Redistribution and use in source and binary forms, with or without modification, 
// are permitted provided that the following conditions are met:
// 
// (1) Redistributions of source code must retain the above copyright notice, 
// this list of conditions and the following disclaimer.
// 
// (2) Redistributions in binary form must reproduce the above copyright notice, 
// this list of conditions and the following disclaimer in the documentation 
// and/or other materials provided with the distribution.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
// IN NO EVENT SHALL Sente SA OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT 
// OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
// EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// 
// Note: this license is equivalent to the FreeBSD license.
// 
// This notice may not be removed from this file.

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

#import <Foundation/Foundation.h>

#import "NSException+GHTestFailureExceptions.h"
#import "NSValue+GHValueFormatter.h"

// GTM_BEGIN

extern NSString *const GHTestFilenameKey;
extern NSString *const GHTestLineNumberKey;
extern NSString *const GHTestFailureException;

#if defined(__cplusplus) 
extern "C" 
#endif 

NSString *GHComposeString(NSString *, ...);


/*!
 Generates a failure when a1 != noErr

 @param a1 Should be either an OSErr or an OSStatus
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present.
 @param ...: A variable number of arguments to the format string. Can be absent.
 */
#define GHAssertNoErr(a1, description, ...) \
do { \
@try {\
OSStatus a1value = (a1); \
if (a1value != noErr) { \
NSString *_expression = [NSString stringWithFormat:@"Expected noErr, got %ld for (%s)", a1value, #a1]; \
if (description) { \
_expression = [NSString stringWithFormat:@"%@: %@", _expression, GHComposeString(description, ##__VA_ARGS__)]; \
} \
[self failWithException:[NSException ghu_failureInFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:_expression]]; \
} \
}\
@catch (id anException) {\
[self failWithException:[NSException ghu_failureInRaise:[NSString stringWithFormat:@"(%s) == noErr fails", #a1] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while(0)

/*!
 Generates a failure when a1 != a2

 @param a1 Rreceived value. Should be either an OSErr or an OSStatus
 @param a2 Expected value. Should be either an OSErr or an OSStatus
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present.
 @param ... A variable number of arguments to the format string. Can be absent.
 */
#define GHAssertErr(a1, a2, description, ...) \
do { \
@try {\
OSStatus a1value = (a1); \
OSStatus a2value = (a2); \
if (a1value != a2value) { \
NSString *_expression = [NSString stringWithFormat:@"Expected %s(%ld) but got %ld for (%s)", #a2, a2value, a1value, #a1]; \
if (description) { \
_expression = [NSString stringWithFormat:@"%@: %@", _expression, GHComposeString(description, ##__VA_ARGS__)]; \
} \
[self failWithException:[NSException ghu_failureInFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:_expression]]; \
} \
}\
@catch (id anException) {\
[self failWithException:[NSException ghu_failureInRaise:[NSString stringWithFormat:@"(%s) == (%s) fails", #a1, #a2] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while(0)


/*!
 Generates a failure when a1 is NULL

 @param a1 Should be a pointer (use GHAssertNotNil for an object)
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present.
 @param ... A variable number of arguments to the format string. Can be absent.
 */
#define GHAssertNotNULL(a1, description, ...) \
do { \
@try {\
const void* a1value = (a1); \
if (a1value == NULL) { \
NSString *_expression = [NSString stringWithFormat:@"(%s) != NULL", #a1]; \
if (description) { \
_expression = [NSString stringWithFormat:@"%@: %@", _expression, GHComposeString(description, ##__VA_ARGS__)]; \
} \
[self failWithException:[NSException ghu_failureInFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:_expression]]; \
} \
}\
@catch (id anException) {\
[self failWithException:[NSException ghu_failureInRaise:[NSString stringWithFormat:@"(%s) != NULL fails", #a1] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while(0)

/*!
 Generates a failure when a1 is not NULL

 @param a1 should be a pointer (use GHAssertNil for an object)
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present.
 @param ... A variable number of arguments to the format string. Can be absent.
 */
#define GHAssertNULL(a1, description, ...) \
do { \
@try {\
const void* a1value = (a1); \
if (a1value != NULL) { \
NSString *_expression = [NSString stringWithFormat:@"(%s) == NULL", #a1]; \
if (description) { \
_expression = [NSString stringWithFormat:@"%@: %@", _expression, GHComposeString(description, ##__VA_ARGS__)]; \
} \
[self failWithException:[NSException ghu_failureInFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:_expression]]; \
} \
}\
@catch (id anException) {\
[self failWithException:[NSException ghu_failureInRaise:[NSString stringWithFormat:@"(%s) == NULL fails", #a1] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while(0)

/*!
 Generates a failure when a1 is equal to a2. This test is for C scalars, structs and unions.

 @param a1 Argument 1
 @param a2 Argument 2
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present.
 @param ... A variable number of arguments to the format string. Can be absent.
 */
#define GHAssertNotEquals(a1, a2, description, ...) \
do { \
@try {\
if (strcmp(@encode(__typeof__(a1)), @encode(__typeof__(a2))) != 0) { \
[self failWithException:[NSException ghu_failureInFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:[@"Type mismatch -- " stringByAppendingString:GHComposeString(description, ##__VA_ARGS__)]]]; \
} else { \
__typeof__(a1) a1value = (a1); \
__typeof__(a2) a2value = (a2); \
NSValue *a1encoded = [NSValue value:&a1value withObjCType:@encode(__typeof__(a1))]; \
NSValue *a2encoded = [NSValue value:&a2value withObjCType:@encode(__typeof__(a2))]; \
if ([a1encoded isEqualToValue:a2encoded]) { \
NSString *_expression = [NSString stringWithFormat:@"(%s) != (%s)", #a1, #a2]; \
if (description) { \
_expression = [NSString stringWithFormat:@"%@: %@", _expression, GHComposeString(description, ##__VA_ARGS__)]; \
} \
[self failWithException:[NSException ghu_failureInFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:_expression]]; \
} \
} \
} \
@catch (id anException) {\
[self failWithException:[NSException ghu_failureInRaise:[NSString stringWithFormat:@"(%s) != (%s)", #a1, #a2] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while(0)

/*!
 Generates a failure when a1 is equal to a2. This test is for objects.

 @param a1 Argument 1. object.
 @param a2 Argument 2. object.
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present.
 @param ... A variable number of arguments to the format string. Can be absent.
 */
#define GHAssertNotEqualObjects(a1, a2, desc, ...) \
do { \
@try {\
id a1value = (a1); \
id a2value = (a2); \
if ( (strcmp(@encode(__typeof__(a1value)), @encode(id)) == 0) && \
(strcmp(@encode(__typeof__(a2value)), @encode(id)) == 0) && \
![(id)a1value isEqual:(id)a2value] ) continue; \
NSString *_expression = [NSString stringWithFormat:@"%s('%@') != %s('%@')", #a1, [a1 description], #a2, [a2 description]]; \
if (desc) { \
_expression = [NSString stringWithFormat:@"%@: %@", _expression, GHComposeString(desc, ##__VA_ARGS__)]; \
} \
[self failWithException:[NSException ghu_failureInFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:_expression]]; \
}\
@catch (id anException) {\
[self failWithException:[NSException ghu_failureInRaise:[NSString stringWithFormat: @"(%s) != (%s)", #a1, #a2] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(desc, ##__VA_ARGS__)]]; \
}\
} while(0)

/*!
 Generates a failure when a1 is not 'op' to a2. This test is for C scalars. 

 @param a1 Argument 1
 @param a2 Argument 2
 @param op Operation
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present.
 @param ... A variable number of arguments to the format string. Can be absent.
 */
#define GHAssertOperation(a1, a2, op, description, ...) \
do { \
@try {\
if (strcmp(@encode(__typeof__(a1)), @encode(__typeof__(a2))) != 0) { \
[self failWithException:[NSException ghu_failureInFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:[@"Type mismatch -- " stringByAppendingString:GHComposeString(description, ##__VA_ARGS__)]]]; \
} else { \
__typeof__(a1) a1value = (a1); \
__typeof__(a2) a2value = (a2); \
if (!(a1value op a2value)) { \
double a1DoubleValue = a1value; \
double a2DoubleValue = a2value; \
NSString *_expression = [NSString stringWithFormat:@"%s (%lg) %s %s (%lg)", #a1, a1DoubleValue, #op, #a2, a2DoubleValue]; \
if (description) { \
_expression = [NSString stringWithFormat:@"%@: %@", _expression, GHComposeString(description, ##__VA_ARGS__)]; \
} \
[self failWithException:[NSException ghu_failureInFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:_expression]]; \
} \
} \
} \
@catch (id anException) {\
[self failWithException:[NSException \
ghu_failureInRaise:[NSString stringWithFormat:@"(%s) %s (%s)", #a1, #op, #a2] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while(0)

/*! 
 Generates a failure when a1 is not > a2. This test is for C scalars. 

 @param a1 argument 1
 @param a2 argument 2
 @param op operation
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present.
 @param ... A variable number of arguments to the format string. Can be absent. 
 */
#define GHAssertGreaterThan(a1, a2, description, ...) \
GHAssertOperation(a1, a2, >, description, ##__VA_ARGS__)

/*! 
 Generates a failure when a1 is not >= a2. This test is for C scalars. 

 @param a1 argument 1
 @param a2 argument 2
 @param op operation
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present.
 @param ... A variable number of arguments to the format string. Can be absent. 
 */
#define GHAssertGreaterThanOrEqual(a1, a2, description, ...) \
GHAssertOperation(a1, a2, >=, description, ##__VA_ARGS__)

/*! 
 Generates a failure when a1 is not < a2. This test is for C scalars. 

 @param a1 argument 1
 @param a2 argument 2
 @param op operation
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present.
 @param ... A variable number of arguments to the format string. Can be absent.
 */
#define GHAssertLessThan(a1, a2, description, ...) \
GHAssertOperation(a1, a2, <, description, ##__VA_ARGS__)

/*! Generates a failure when a1 is not <= a2. This test is for C scalars. 

 @param a1 argument 1
 @param a2 argument 2
 @param op operation
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present.
 @param ... A variable number of arguments to the format string. Can be absent.
 */
#define GHAssertLessThanOrEqual(a1, a2, description, ...) \
GHAssertOperation(a1, a2, <=, description, ##__VA_ARGS__)

/*! 
 Generates a failure when string a1 is not equal to string a2. This call
 differs from GHAssertEqualObjects in that strings that are different in
 composition (precomposed vs decomposed) will compare equal if their final
 representation is equal.
 ex O + umlaut decomposed is the same as O + umlaut composed.

 @param a1 string 1
 @param a2 string 2
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present.
 @param ... A variable number of arguments to the format string. Can be absent.
 */
#define GHAssertEqualStrings(a1, a2, description, ...) \
do { \
@try {\
id a1value = (a1); \
id a2value = (a2); \
if (a1value == a2value) continue; \
if ([a1value isKindOfClass:[NSString class]] && \
[a2value isKindOfClass:[NSString class]] && \
[a1value compare:a2value options:0] == NSOrderedSame) continue; \
[self failWithException:[NSException ghu_failureInEqualityBetweenObject: a1value \
andObject: a2value \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(description, ##__VA_ARGS__)]]; \
}\
@catch (id anException) {\
[self failWithException:[NSException ghu_failureInRaise:[NSString stringWithFormat: @"(%s) == (%s)", #a1, #a2] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while(0)

/*! 
 Generates a failure when string a1 is equal to string a2. This call
 differs from GHAssertEqualObjects in that strings that are different in
 composition (precomposed vs decomposed) will compare equal if their final
 representation is equal.
 ex O + umlaut decomposed is the same as O + umlaut composed.

 @param a1 string 1
 @param a2 string 2
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present.
 @param ... A variable number of arguments to the format string. Can be absent.
 */
#define GHAssertNotEqualStrings(a1, a2, description, ...) \
do { \
@try {\
id a1value = (a1); \
id a2value = (a2); \
if (([a1value isKindOfClass:[NSString class]] && \
[a2value isKindOfClass:[NSString class]] && \
[a1value compare:a2value options:0] != NSOrderedSame) || \
(a1value == nil && [a2value isKindOfClass:[NSString class]]) || \
(a2value == nil && [a1value isKindOfClass:[NSString class]]) \
) continue; \
[self failWithException:[NSException ghu_failureInInequalityBetweenObject: a1value \
andObject: a2value \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(description, ##__VA_ARGS__)]]; \
}\
@catch (id anException) {\
[self failWithException:[NSException ghu_failureInRaise:[NSString stringWithFormat: @"(%s) != (%s)", #a1, #a2] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while(0)

/*! 
 Generates a failure when c-string a1 is not equal to c-string a2.

 @param a1 string 1
 @param a2 string 2
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present.
 @param ... A variable number of arguments to the format string. Can be absent.
 */
#define GHAssertEqualCStrings(a1, a2, description, ...) \
do { \
@try {\
const char* a1value = (a1); \
const char* a2value = (a2); \
if (a1value == a2value) continue; \
if (strcmp(a1value, a2value) == 0) continue; \
[self failWithException:[NSException ghu_failureInEqualityBetweenObject: [NSString stringWithUTF8String:a1value] \
andObject: [NSString stringWithUTF8String:a2value] \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(description, ##__VA_ARGS__)]]; \
}\
@catch (id anException) {\
[self failWithException:[NSException ghu_failureInRaise:[NSString stringWithFormat: @"(%s) == (%s)", #a1, #a2] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while(0)

/*! 
 Generates a failure when c-string a1 is equal to c-string a2.

 @param a1 string 1
 @param a2 string 2
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present.
 @param ... A variable number of arguments to the format string. Can be absent.
 */
#define GHAssertNotEqualCStrings(a1, a2, description, ...) \
do { \
@try {\
const char* a1value = (a1); \
const char* a2value = (a2); \
if (strcmp(a1value, a2value) != 0) continue; \
[self failWithException:[NSException ghu_failureInEqualityBetweenObject: [NSString stringWithUTF8String:a1value] \
andObject: [NSString stringWithUTF8String:a2value] \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(description, ##__VA_ARGS__)]]; \
}\
@catch (id anException) {\
[self failWithException:[NSException ghu_failureInRaise:[NSString stringWithFormat: @"(%s) != (%s)", #a1, #a2] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while(0)

// GTM_END

// SENTE_BEGIN
/*! Generates a failure when !{ [a1 isEqualTo:a2] } is false 
 (or one is nil and the other is not). 

 @param a1    The object on the left
 @param a2    The object on the right
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present
 @param ... A variable number of arguments to the format string. Can be absent
 */
#define GHAssertEqualObjects(a1, a2, description, ...) \
do { \
@try {\
id a1value = (a1); \
id a2value = (a2); \
if (a1value == a2value) continue; \
if ( (strcmp(@encode(__typeof__(a1value)), @encode(id)) == 0) && \
(strcmp(@encode(__typeof__(a2value)), @encode(id)) == 0) && \
[(id)a1value isEqual: (id)a2value] ) continue; \
[self failWithException:[NSException ghu_failureInEqualityBetweenObject: a1value \
andObject: a2value \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(description, ##__VA_ARGS__)]]; \
}\
@catch (id anException) {\
[self failWithException:[NSException ghu_failureInRaise:[NSString stringWithFormat: @"(%s) == (%s)", #a1, #a2] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while(0)


/*! Generates a failure when a1 is not equal to a2. This test is for
 C scalars, structs and unions.

 @param a1    The argument on the left
 @param a2    The argument on the right
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present
 @param ... A variable number of arguments to the format string. Can be absent
 */
#define GHAssertEquals(a1, a2, description, ...) \
do { \
@try {\
if ( strcmp(@encode(__typeof__(a1)), @encode(__typeof__(a2))) != 0 ) { \
[self failWithException:[NSException ghu_failureInFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:[@"Type mismatch -- " stringByAppendingString:GHComposeString(description, ##__VA_ARGS__)]]]; \
} else { \
__typeof__(a1) a1value = (a1); \
__typeof__(a2) a2value = (a2); \
NSValue *a1encoded = [NSValue value:&a1value withObjCType: @encode(__typeof__(a1))]; \
NSValue *a2encoded = [NSValue value:&a2value withObjCType: @encode(__typeof__(a2))]; \
if (![a1encoded isEqualToValue:a2encoded]) { \
[self failWithException:[NSException ghu_failureInEqualityBetweenValue: a1encoded \
andValue: a2encoded \
withAccuracy: nil \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(description, ##__VA_ARGS__)]]; \
} \
} \
} \
@catch (id anException) {\
[self failWithException:[NSException ghu_failureInRaise:[NSString stringWithFormat: @"(%s) == (%s)", #a1, #a2] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while(0)

//! Absolute difference
#define GHAbsoluteDifference(left,right) (MAX(left,right)-MIN(left,right))


/*! 
 Generates a failure when a1 is not equal to a2 within + or - accuracy is false. 
 This test is for scalars such as floats and doubles where small differences 
 could make these items not exactly equal, but also works for all scalars.

 @param a1    The scalar on the left
 @param a2    The scalar on the right
 @param accuracy  The maximum difference between a1 and a2 for these values to be considered equal
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present
 @param ... A variable number of arguments to the format string. Can be absent
 */
#define GHAssertEqualsWithAccuracy(a1, a2, accuracy, description, ...) \
do { \
@try {\
if (strcmp(@encode(__typeof__(a1)), @encode(__typeof__(a2))) != 0) { \
[self failWithException:[NSException ghu_failureInFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:[@"Type mismatch -- " stringByAppendingString:GHComposeString(description, ##__VA_ARGS__)]]]; \
} else { \
__typeof__(a1) a1value = (a1); \
__typeof__(a2) a2value = (a2); \
__typeof__(accuracy) accuracyvalue = (accuracy); \
if (GHAbsoluteDifference(a1value, a2value) > accuracyvalue) { \
NSValue *a1encoded = [NSValue value:&a1value withObjCType:@encode(__typeof__(a1))]; \
NSValue *a2encoded = [NSValue value:&a2value withObjCType:@encode(__typeof__(a2))]; \
NSValue *accuracyencoded = [NSValue value:&accuracyvalue withObjCType:@encode(__typeof__(accuracy))]; \
[self failWithException:[NSException ghu_failureInEqualityBetweenValue: a1encoded \
andValue: a2encoded \
withAccuracy: accuracyencoded \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(description, ##__VA_ARGS__)]]; \
} \
} \
} \
@catch (id anException) {\
[self failWithException:[NSException ghu_failureInRaise:[NSString stringWithFormat: @"(%s) == (%s)", #a1, #a2] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while(0)



/*! 
 Generates a failure unconditionally. 

 @param description A format string as in the printf() function. Can be nil or an empty string but must be present
 @param ... A variable number of arguments to the format string. Can be absent
 */
#define GHFail(description, ...) \
[self failWithException:[NSException ghu_failureInFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(description, ##__VA_ARGS__)]]



/*! 
 Generates a failure when a1 is not nil.

 @param a1    An object
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present
 @param ... A variable number of arguments to the format string. Can be absent
 */
#define GHAssertNil(a1, description, ...) \
do { \
@try {\
id a1value = (a1); \
if (a1value != nil) { \
NSString *_a1 = [NSString stringWithUTF8String: #a1]; \
NSString *_expression = [NSString stringWithFormat:@"((%@) == nil)", _a1]; \
[self failWithException:[NSException ghu_failureInCondition: _expression \
isTrue: NO \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(description, ##__VA_ARGS__)]]; \
} \
}\
@catch (id anException) {\
[self failWithException:[NSException ghu_failureInRaise:[NSString stringWithFormat: @"(%s) == nil fails", #a1] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while(0)


/*! 
 Generates a failure when a1 is nil.

 @param a1    An object
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present
 @param ... A variable number of arguments to the format string. Can be absent
 */
#define GHAssertNotNil(a1, description, ...) \
do { \
@try {\
id a1value = (a1); \
if (a1value == nil) { \
NSString *_a1 = [NSString stringWithUTF8String: #a1]; \
NSString *_expression = [NSString stringWithFormat:@"((%@) != nil)", _a1]; \
[self failWithException:[NSException ghu_failureInCondition: _expression \
isTrue: NO \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(description, ##__VA_ARGS__)]]; \
} \
}\
@catch (id anException) {\
[self failWithException:[NSException ghu_failureInRaise:[NSString stringWithFormat: @"(%s) != nil fails", #a1] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while(0)


/*! 
 Generates a failure when expression evaluates to false. 

 @param expr    The expression that is tested
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present
 @param ... A variable number of arguments to the format string. Can be absent
 */
#define GHAssertTrue(expr, description, ...) \
do { \
BOOL _evaluatedExpression = (expr);\
if (!_evaluatedExpression) {\
NSString *_expression = [NSString stringWithUTF8String: #expr];\
[self failWithException:[NSException ghu_failureInCondition: _expression \
isTrue: YES \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(description, ##__VA_ARGS__)]]; \
} \
} while (0)


/*! 
 Generates a failure when expression evaluates to false and in addition will 
 generate error messages if an exception is encountered. 
 
 @param expr    The expression that is tested
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present
 @param ... A variable number of arguments to the format string. Can be absent
 */
#define GHAssertTrueNoThrow(expr, description, ...) \
do { \
@try {\
BOOL _evaluatedExpression = (expr);\
if (!_evaluatedExpression) {\
NSString *_expression = [NSString stringWithUTF8String: #expr];\
[self failWithException:[NSException ghu_failureInCondition: _expression \
isTrue: NO \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(description, ##__VA_ARGS__)]]; \
} \
} \
@catch (id anException) {\
[self failWithException:[NSException ghu_failureInRaise:[NSString stringWithFormat: @"(%s) ", #expr] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while (0)


/*! 
 Generates a failure when the expression evaluates to true. 

 @param expr    The expression that is tested
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present
 @param ... A variable number of arguments to the format string. Can be absent
 */
#define GHAssertFalse(expr, description, ...) \
do { \
BOOL _evaluatedExpression = (expr);\
if (_evaluatedExpression) {\
NSString *_expression = [NSString stringWithUTF8String: #expr];\
[self failWithException:[NSException ghu_failureInCondition: _expression \
isTrue: NO \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(description, ##__VA_ARGS__)]]; \
} \
} while (0)


/*! 
 Generates a failure when the expression evaluates to true and in addition 
 will generate error messages if an exception is encountered.
 
 @param expr    The expression that is tested
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present
 @param ... A variable number of arguments to the format string. Can be absent
 */
#define GHAssertFalseNoThrow(expr, description, ...) \
do { \
@try {\
BOOL _evaluatedExpression = (expr);\
if (_evaluatedExpression) {\
NSString *_expression = [NSString stringWithUTF8String: #expr];\
[self failWithException:[NSException ghu_failureInCondition: _expression \
isTrue: YES \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(description, ##__VA_ARGS__)]]; \
} \
} \
@catch (id anException) {\
[self failWithException:[NSException ghu_failureInRaise:[NSString stringWithFormat: @"!(%s) ", #expr] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while (0)


/*! 
 Generates a failure when expression does not throw an exception. 

 @param expression    The expression that is evaluated
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present
 @param ... A variable number of arguments to the format string. Can be absent.
 */
#define GHAssertThrows(expr, description, ...) \
do { \
@try { \
(expr);\
} \
@catch (id anException) { \
continue; \
}\
[self failWithException:[NSException ghu_failureInRaise: [NSString stringWithUTF8String:#expr] \
exception: nil \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(description, ##__VA_ARGS__)]]; \
} while (0)


/*! 
 Generates a failure when expression does not throw an exception of a 
 specific class. 

 @param expression    The expression that is evaluated
 @param specificException    The specified class of the exception
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present
 @param ... A variable number of arguments to the format string. Can be absent
 */
#define GHAssertThrowsSpecific(expr, specificException, description, ...) \
do { \
@try { \
(expr);\
} \
@catch (specificException *anException) { \
continue; \
}\
@catch (id anException) {\
NSString *_descrip = GHComposeString(@"(Expected exception: %@) %@", NSStringFromClass([specificException class]), description);\
[self failWithException:[NSException ghu_failureInRaise: [NSString stringWithUTF8String:#expr] \
exception: anException \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(_descrip, ##__VA_ARGS__)]]; \
continue; \
}\
NSString *_descrip = GHComposeString(@"(Expected exception: %@) %@", NSStringFromClass([specificException class]), description);\
[self failWithException:[NSException ghu_failureInRaise: [NSString stringWithUTF8String:#expr] \
exception: nil \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(_descrip, ##__VA_ARGS__)]]; \
} while (0)


/*! Generates a failure when expression does not throw an exception of a 
 specific class with a specific name.  Useful for those frameworks like
 AppKit or Foundation that throw generic NSException w/specific names 
 (NSInvalidArgumentException, etc).

 @param expression    The expression that is evaluated
 @param specificException    The specified class of the exception
 @param aName    The name of the specified exception
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present
 @param ... A variable number of arguments to the format string. Can be absent
 */
#define GHAssertThrowsSpecificNamed(expr, specificException, aName, description, ...) \
do { \
@try { \
(expr);\
} \
@catch (specificException *anException) { \
if ([aName isEqualToString: [anException name]]) continue; \
NSString *_descrip = GHComposeString(@"(Expected exception: %@ (name: %@)) %@", NSStringFromClass([specificException class]), aName, description);\
[self failWithException: \
[NSException ghu_failureInRaise: [NSString stringWithUTF8String:#expr] \
exception: anException \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(_descrip, ##__VA_ARGS__)]]; \
continue; \
}\
@catch (id anException) {\
NSString *_descrip = GHComposeString(@"(Expected exception: %@) %@", NSStringFromClass([specificException class]), description);\
[self failWithException: \
[NSException ghu_failureInRaise: [NSString stringWithUTF8String:#expr] \
exception: anException \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(_descrip, ##__VA_ARGS__)]]; \
continue; \
}\
NSString *_descrip = GHComposeString(@"(Expected exception: %@) %@", NSStringFromClass([specificException class]), description);\
[self failWithException: \
[NSException ghu_failureInRaise: [NSString stringWithUTF8String:#expr] \
exception: nil \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(_descrip, ##__VA_ARGS__)]]; \
} while (0)


/*! 
 Generates a failure when expression does throw an exception. 

 @param expression    The expression that is evaluated
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present
 @param ... A variable number of arguments to the format string. Can be absent
 */
#define GHAssertNoThrow(expr, description, ...) \
do { \
@try { \
(expr);\
} \
@catch (id anException) { \
[self failWithException:[NSException ghu_failureInRaise: [NSString stringWithUTF8String:#expr] \
exception: anException \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while (0)


/*! 
 Generates a failure when expression does throw an exception of the specitied
 class. Any other exception is okay (i.e. does not generate a failure).

 @param expression    The expression that is evaluated
 @param specificException    The specified class of the exception
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present
 @param ... A variable number of arguments to the format string. Can be absent
 */
#define GHAssertNoThrowSpecific(expr, specificException, description, ...) \
do { \
@try { \
(expr);\
} \
@catch (specificException *anException) { \
[self failWithException:[NSException ghu_failureInRaise: [NSString stringWithUTF8String:#expr] \
exception: anException \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(description, ##__VA_ARGS__)]]; \
}\
@catch (id anythingElse) {\
; \
}\
} while (0)


/*! 
 Generates a failure when expression does throw an exception of a 
 specific class with a specific name.  Useful for those frameworks like
 AppKit or Foundation that throw generic NSException w/specific names 
 (NSInvalidArgumentException, etc).

 @param expression The expression that is evaluated.
 @param specificException    The specified class of the exception
 @param aName    The name of the specified exception
 @param description A format string as in the printf() function. Can be nil or an empty string but must be present
 @param ... A variable number of arguments to the format string. Can be absent
 */
#define GHAssertNoThrowSpecificNamed(expr, specificException, aName, description, ...) \
do { \
@try { \
(expr);\
} \
@catch (specificException *anException) { \
if ([aName isEqualToString: [anException name]]) { \
NSString *_descrip = GHComposeString(@"(Expected exception: %@ (name: %@)) %@", NSStringFromClass([specificException class]), aName, description);\
[self failWithException: \
[NSException ghu_failureInRaise: [NSString stringWithUTF8String:#expr] \
exception: anException \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(_descrip, ##__VA_ARGS__)]]; \
} \
continue; \
}\
@catch (id anythingElse) {\
; \
}\
} while (0)


@interface NSException(GHTestMacros_GTMSenTestAdditions)
+ (NSException *)ghu_failureInFile:(NSString *)filename 
                        atLine:(int)lineNumber 
               withDescription:(NSString *)formatString, ...;
+ (NSException *)ghu_failureInCondition:(NSString *)condition 
                             isTrue:(BOOL)isTrue 
                             inFile:(NSString *)filename 
                             atLine:(int)lineNumber 
                    withDescription:(NSString *)formatString, ...;
+ (NSException *)ghu_failureInEqualityBetweenObject:(id)left
                                      andObject:(id)right
                                         inFile:(NSString *)filename
                                         atLine:(int)lineNumber
                                withDescription:(NSString *)formatString, ...;
+ (NSException *)ghu_failureInInequalityBetweenObject:(id)left
                                            andObject:(id)right
                                               inFile:(NSString *)filename
                                               atLine:(int)lineNumber
                                      withDescription:(NSString *)formatString, ...;
+ (NSException *)ghu_failureInEqualityBetweenValue:(NSValue *)left 
                                      andValue:(NSValue *)right 
                                  withAccuracy:(NSValue *)accuracy 
                                        inFile:(NSString *)filename 
                                        atLine:(int) ineNumber
                               withDescription:(NSString *)formatString, ...;
+ (NSException *)ghu_failureInRaise:(NSString *)expression 
                         inFile:(NSString *)filename 
                         atLine:(int)lineNumber
                withDescription:(NSString *)formatString, ...;
+ (NSException *)ghu_failureInRaise:(NSString *)expression 
                      exception:(NSException *)exception 
                         inFile:(NSString *)filename 
                         atLine:(int)lineNumber 
                withDescription:(NSString *)formatString, ...;
+ (NSException *)ghu_failureWithName:(NSString *)name
                              inFile:(NSString *)filename
                              atLine:(int)lineNumber
                              reason:(NSString *)reason;
@end

// SENTE_END
