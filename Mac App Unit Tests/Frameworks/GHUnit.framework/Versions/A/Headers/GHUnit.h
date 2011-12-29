//
//  GHUnit.h
//  GHUnit
//
//  Created by Gabriel Handford on 1/19/09.
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
#import "GHAsyncTestCase.h"
#import "GHTestSuite.h"
#import "GHTestMacros.h"
#import "GHTestRunner.h"

#import "GHTest.h"
#import "GHTesting.h"
#import "GHTestOperation.h"
#import "GHTestGroup.h"
#import "GHTest+JUnitXML.h"
#import "GHTestGroup+JUnitXML.h"
#import "NSException+GHTestFailureExceptions.h"
#import "NSValue+GHValueFormatter.h"

#if TARGET_OS_IPHONE
#import "GHUnitIPhoneAppDelegate.h"
#endif

#ifdef DEBUG
#define GHUDebug(fmt, ...) do { \
fputs([[[NSString stringWithFormat:fmt, ##__VA_ARGS__] stringByAppendingString:@"\n"] UTF8String], stdout); \
} while(0)
#else
#define GHUDebug(fmt, ...) do {} while(0)
#endif

/*! 
 @mainpage GHUnit
 
 
 GHUnit is a test framework for Objective-C (Mac OS X 10.5 and above and iPhone 3.x and above).
 It can be used with SenTestingKit, GTM or all by itself. 
 
 For example, your test cases will be run if they subclass any of the following:
 
 - GHTestCase
 - SenTestCase
 - GTMTestCase
 
 
 Source: http://github.com/gabriel/gh-unit
 
 View docs online: http://gabriel.github.com/gh-unit/

 
 This manual is divided in the following sections:
 - @subpage Examples
 - @subpage Installing
 - @subpage Building
 - @subpage TestMacros 
 - @subpage EnvVariables
 - @subpage CommandLine "Command Line & Makefiles"
 - @subpage Customizing
 - @subpage Hudson 
 
 
 @image html http://rel.me.s3.amazonaws.com/gh-unit/images/GHUnit-IPhone-0.4.18.png
 
 @image html http://rel.me.s3.amazonaws.com/gh-unit/images/GHUnit-0.4.18.png 
 
 @section Notes Notes
 
 GHUnit was inspired by and uses parts of GTM (google-toolbox-for-mac) code, mostly from UnitTesting: http://code.google.com/p/google-toolbox-for-mac/source/browse/trunk/UnitTesting/
 
 */
 
/*!
 @page Installing Installing
 
 - @ref InstallingIOS
 - @ref InstallMacOSX
 
 @section InstallingIOS Installing (iOS)
 
 - Add a <tt>New Target</tt>. Select <tt>Cocoa Touch -> Application</tt>. Name it <tt>Tests</tt> (or something similar).
 - Add the <tt>GHUnitIOS.framework</tt> to your project.
 - Add the following frameworks to <tt>Linked Libraries</tt>:
    - <tt>GHUnitIOS.framework</tt>
    - <tt>CoreGraphics.framework</tt>
    - <tt>Foundation.framework</tt>
    - <tt>UIKit.framework</tt>
 - Under 'Framework Search Paths' make sure the (parent) directory to GHUnit.framework is listed.
 - Under 'Other Linker Flags' in the <tt>Tests</tt> target, add <tt>-ObjC</tt> and <tt>-all_load</tt>
 - By default, the Tests-Info.plist file includes <tt>MainWindow</tt> for <tt>Main nib file base name</tt>. You should clear this field.
 - Add the GHUnitIOSTestMain.m (http://github.com/gabriel/gh-unit/blob/master/Project-IPhone/GHUnitIOSTestMain.m) file into your project.
 - (Optional) Create and and set a prefix header (<tt>Tests_Prefix.pch</tt>) and add <tt>#import <GHUnitIOS/GHUnit.h></tt> to it, and then you won't have to include that import for every test.
 - (Optional) @ref Makefile "Install Makefile"
 - @ref Examples "Create a test"
 
 Now you can create a test (either by subclassing <tt>SenTestCase</tt> or <tt>GHTestCase</tt>), adding it to your test target.
 
 @section InstallMacOSX Installing (Mac OS X)
 
 You can install it globally in /Library/Frameworks or with a little extra effort embed it with your project.
 
 @subsection InstallLibraryFrameworks Installing in /Library/Frameworks
 
 - Copy <tt>GHUnit.framework</tt> to <tt>/Library/Frameworks/</tt>
 - Add a <tt>New Target</tt>. Select <tt>Cocoa -> Application</tt>. Name it <tt>Tests</tt> (or something similar).
 - In the <tt>Target 'Tests' Info</tt> window, <tt>General</tt> tab:
    - Add a linked library, under <tt>Mac OS X 10.X SDK</tt> section, select <tt>GHUnit.framework</tt>
    - If your main target is a library: Add a linked library, and select your main target.
    - If your main target is an application, you will need to include these source files in the <tt>Test</tt> project manually. 
    - Add a direct dependency, and select your project. (This will cause your application or framework to build before the test target.)
 - Copy GHUnitTestMain.m (http://github.com/gabriel/gh-unit/tree/master/Classes-MacOSX/GHUnitTestMain.m) into your project and include in the Test target.
 - Now create a test (either by subclassing <tt>SenTestCase</tt> or <tt>GHTestCase</tt>), adding it to your test target. (See example test case below.)
 - By default, the Tests-Info.plist file includes <tt>MainWindow</tt> for <tt>Main nib file base name</tt>. You should clear this field.
 - (Optional) @ref Makefile "Install Makefile"
 - @ref Examples "Create a test"
 
 @subsection InstallProject Installing in your project
 
 - Add a <tt>New Target</tt>. Select <tt>Cocoa -> Application</tt>. Name it <tt>Tests</tt> (or something similar).
 - In the Finder, copy <tt>GHUnit.framework</tt> to your project directory (maybe in MyProject/Frameworks/.)
 - In the <tt>Tests</tt> target, add the <tt>GHUnit.framework</tt> files (from MyProject/Frameworks/). It should now be visible as a <tt>Linked Framework</tt> in the target. 
 - In the <tt>Tests</tt> target, under Build Settings, add <tt>@loader_path/../Frameworks</tt> to <tt>Runpath Search Paths</tt> (Under All Configurations)
 - In the <tt>Tests</tt> target, add <tt>New Build Phase</tt> | <tt>New Copy Files Build Phase</tt>. 
    - Change the Destination to <tt>Frameworks</tt>.
    - Drag <tt>GHUnit.framework</tt> into the the build phase
    - Make sure the copy phase appears before any <tt>Run Script</tt> phases 
 - Copy GHUnitTestMain.m (http://github.com/gabriel/gh-unit/tree/master/Classes-MacOSX/GHUnitTestMain.m) into your project and include in the Test target.
 
 - If your main target is a library: 
    - In the <tt>Target 'Tests' Info</tt> window, <tt>General</tt> tab: 
        - Add a linked library, and select your main target; This is so you can link your test target against your main target, and then you don't have to manually include source files in both targets.
 - If your main target is an application, you will need to include these source files to the <tt>Test</tt> project manually.
 
 - Now create a test (either by subclassing <tt>SenTestCase</tt> or <tt>GHTestCase</tt>), adding it to your test target. (See example test case below.)
 - By default, the Tests-Info.plist file includes <tt>MainWindow</tt> for <tt>Main nib file base name</tt>. You should clear this field.
 - (Optional) @ref Makefile "Install Makefile"
 - @ref Examples "Create a test"
 */
 
/*!
 @page Building Building
 
 For iOS, run <tt>make</tt> from within the <tt>Project-IPhone</tt> directory. The framework is in <tt>Project-IPhone/build/Framework/</tt>.
 
 For Mac OS X, the framework build is stored in <tt>Project/build/Release/</tt>.
 */

/*!
 @page Examples Examples
 
 - @ref ExampleTestCase
 - @ref ExampleAsyncTestCase
 
 @section ExampleTestCase Example Test Case
 
 For example <tt>ExampleTest.m</tt>:
 
 @code
 // For iOS
 #import <GHUnitIOS/GHUnit.h> 
 // For Mac OS X
 //#import <GHUnit/GHUnit.h>
 
 @interface ExampleTest : GHTestCase { }
 @end
 
 @implementation ExampleTest
 
 - (BOOL)shouldRunOnMainThread {
   // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
   return NO;
 }
 
 - (void)setUpClass {
   // Run at start of all tests in the class
 }
 
 - (void)tearDownClass {
   // Run at end of all tests in the class
 }
 
 - (void)setUp {
   // Run before each test method
 }
 
 - (void)tearDown {
   // Run after each test method
 }	
 
 - (void)testFoo {       
   NSString *a = @"foo";
   GHTestLog(@"I can log to the GHUnit test console: %@", a);
 
   // Assert a is not NULL, with no custom error description
   GHAssertNotNULL(a, nil);
 
   // Assert equal objects, add custom error description
   NSString *b = @"bar";
   GHAssertEqualObjects(a, b, @"A custom error message. a should be equal to: %@.", b);
 }
 
 - (void)testBar {
   // Another test
 }
 
 @end
 @endcode
 
 @section ExampleAsyncTestCase Example Async Test Case
 
 @code
 // For iOS
 #import <GHUnitIOS/GHUnit.h> 
 // For Mac OS X
 //#import <GHUnit/GHUnit.h> 
 
 @interface ExampleAsyncTest : GHAsyncTestCase { }
 @end
 
 @implementation ExampleAsyncTest
  
 - (void)testURLConnection {
   
   // Call prepare to setup the asynchronous action.
   // This helps in cases where the action is synchronous and the
   // action occurs before the wait is actually called.
   [self prepare];

   NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]];
   NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];

   // Wait until notify called for timeout (seconds); If notify is not called with kGHUnitWaitStatusSuccess then
   // we will throw an error.
   [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];

   [connection release];
 }
 
 - (void)connectionDidFinishLoading:(NSURLConnection *)connection {
   // Notify of success, specifying the method where wait is called.
   // This prevents stray notifies from affecting other tests.
   [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testURLConnection)];
 }
 
 - (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
   // Notify of connection failure
   [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testURLConnection)];
 }
 
 - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
   GHTestLog(@"%@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
 } 
 
 @end
 @endcode
 
 
 @section ExampleProjects Example Projects
 
 Example projects can be found at: http://github.com/gabriel/gh-unit/tree/master/Examples/ 
  
 */
 
/*!
 @page EnvVariables Environment Variables
 
 @section GHUnitEnvVariables GHUnit Environment Variables
 
 Go into the "Get Info" contextual menu of your (Tests) executable (inside the "Executables" group in the left panel of XCode). 
 Then go in the "Arguments" tab. You can add the following environment variables:
 
 @verbatim
 GHUNIT_CLI - Default NO; Runs tests on the command line (see Debugger Console, Cmd-Shift-R)
 GHUNIT_RERAISE - Default NO; If an exception is encountered it re-raises it allowing you to crash into the debugger
 GHUNIT_AUTORUN - Default NO; If YES, tests will start automatically
 GHUNIT_AUTOEXIT - Default NO; If YES, will exit upon test completion (no matter what); For command line MacOSX testing
 @endverbatim
 
 
 @section EnvVariablesTest Test Environment Variables (Recommended)
 
 Go into the "Get Info" contextual menu of your (Tests) executable (inside the "Executables" group in the left panel of XCode). 
 Then go in the "Arguments" tab. You can add the following environment variables:
 
 @verbatim
 Environment Variable:                 Default:  Set to:
 NSDebugEnabled                           NO       YES
 NSZombieEnabled                          NO       YES
 NSDeallocateZombies                      NO       NO (or YES)
 NSHangOnUncaughtException                NO       YES
 NSAutoreleaseFreedObjectCheckEnabled     NO       YES
 @endverbatim
 
 If Using NSDeallocateZombies=NO, then all objects will leak so be sure to turn it off when debugging memory leaks.
 
 For more info on these varaiables see NSDebug.h (http://theshadow.uw.hu/iPhoneSDKdoc/Foundation.framework/NSDebug.h.html)
 
 For malloc debugging:
 
 @verbatim
 MallocStackLogging
 MallocStackLoggingNoCompact
 MallocScribble
 MallocPreScribble
 MallocGuardEdges
 MallocDoNotProtectPrelude
 MallocDoNotProtectPostlude
 MallocCheckHeapStart
 MallocCheckHeapEach
 @endverbatim
 
 If you see a message like:
 
 @verbatim
 2009-10-15 13:02:24.746 Tests[38615:40b] *** -[Foo class]: message sent to deallocated instance 0x1c8e680
 @endverbatim
 
 Re-run (in gdb) with <tt>MallocStackLogging=YES</tt> (or <tt>MallocStackLoggingNoCompact=YES</tt>), then if you run under gdb:
 
 @verbatim
 (gdb) shell malloc_history 38615 0x1c8e680
 
 ALLOC 0x1a9ad10-0x1a9ad6f [size=96]: thread_a024a500 |start | main | UIApplicationMain | GSEventRun | GSEventRunModal | CFRunLoopRunInMode | CFRunLoopRunSpecific | __NSThreadPerformPerform | -[GHTestGroup _run:] | -[GHTest run] | +[GHTesting runTest:selector:withObject:exception:interval:] | -[Foo foo] | +[NSObject alloc] | +[NSObject allocWithZone:] | _internal_class_createInstance | _internal_class_createInstanceFromZone | calloc | malloc_zone_calloc 
 
 @endverbatim
 
 Somewhere between runTest and NSObject alloc there may be an object that wasn't retained.
 
 Also using <tt>MallocScribble=YES</tt> causes the malloc library to overwrite freed memory with a well-known value (0x55), and occasionally checks freed malloc blocks to make sure the memory has not been over-written overwritten written since it was cleared.
 
 For more info on these variables see MallocDebug (http://developer.apple.com/mac/library/documentation/Performance/Conceptual/ManagingMemory/Articles/MallocDebug.html)
 
 For more info on malloc_history see malloc_history (http://developer.apple.com/mac/library/documentation/Darwin/Reference/ManPages/man1/malloc_history.1.html)
 
 */

/*!
 
 @page CommandLine Command Line
 
 @section CommandLineRunningTests Running Tests
 
 To run the tests from the command line:
 
 - Copy the RunTests.sh (http://github.com/gabriel/gh-unit/tree/master/Scripts/RunTests.sh) file into your project directory (if you haven't already).
 - In XCode:
    - To the <tt>Tests</tt> target, Add <tt>New Build Phase</tt> | <tt>New Run Script Build Phase</tt>
    - Enter <tt>sh RunTests.sh</tt> as the script. The path to <tt>RunTests.sh</tt> should be relative to the xcode project file (.xcodeproj)!
        - (Optional) Uncheck 'Show environment variables in build log'
 
 From the command line, run the tests from xcodebuild (with the GHUNIT_CLI environment variable set):
 
 @verbatim
 // For mac app; This might seg fault in 10.6, in which case you should use make test via Makefile below
 GHUNIT_CLI=1 xcodebuild -target Tests -configuration Debug -sdk macosx10.5 build	
 
 // For iPhone app
 GHUNIT_CLI=1 xcodebuild -target Tests -configuration Debug -sdk iphonesimulator4.0 build
 @endverbatim
 
 If you are wondering, the <tt>RunTests.sh</tt> script will only run the tests if the env variable GHUNIT_CLI is set. 
 This is why this RunScript phase is ignored when running the test GUI. This is how we use a single Test target for both the GUI and command line testing.
 
 This may seem strange that we run via xcodebuild with a RunScript phase in order to work on the command line, but otherwise we may not have
 the environment settings or other XCode specific configuration right.
 
 @section Makefile Makefile
 
 Follow the directions above for adding command line support.
 
 Example Makefile's for Mac or iPhone apps:
 
 - Makefile (Mac OS X): http://github.com/gabriel/gh-unit/tree/master/Project/Makefile (for a Mac App)
 - Makefile (iOS): http://github.com/gabriel/gh-unit/tree/master/Project-IPhone/Makefile (for an iPhone App)
 
 The script will return a non-zero exit code on test failure.
 
 To run the tests via the Makefile:
 
 @verbatim
 make test
 @endverbatim
 
 @section RunningATest Running a Test Case / Single Test
 
 The <tt>TEST</tt> environment variable can be used to run a single test or test case.
 
 @verbatim
 // Run all tests in GHSlowTest
 make test TEST="GHSlowTest"
 
 // Run the method testSlowA in GHSlowTest	
 make test TEST="GHSlowTest/testSlowA"
 @endverbatim
 
 */

/*!
  
 @page TestMacros Test Macros
 
 The following test macros are included. 
 
 These macros are directly from: GTMSenTestCase.h (http://code.google.com/p/google-toolbox-for-mac/source/browse/trunk/UnitTesting/GTMSenTestCase.h)
 prefixed with GH so as not to conflict with the GTM macros if you are using those in your project.
 
 The <tt>description</tt> argument appends extra information for when the assert fails; though most of the time you might leave it as nil.
 
 @code
 GHAssertNoErr(a1, description, ...)
 GHAssertErr(a1, a2, description, ...)
 GHAssertNotNULL(a1, description, ...)
 GHAssertNULL(a1, description, ...)
 GHAssertNotEquals(a1, a2, description, ...)
 GHAssertNotEqualObjects(a1, a2, desc, ...)
 GHAssertOperation(a1, a2, op, description, ...)
 GHAssertGreaterThan(a1, a2, description, ...)
 GHAssertGreaterThanOrEqual(a1, a2, description, ...)
 GHAssertLessThan(a1, a2, description, ...)
 GHAssertLessThanOrEqual(a1, a2, description, ...)
 GHAssertEqualStrings(a1, a2, description, ...)
 GHAssertNotEqualStrings(a1, a2, description, ...)
 GHAssertEqualCStrings(a1, a2, description, ...)
 GHAssertNotEqualCStrings(a1, a2, description, ...)
 GHAssertEqualObjects(a1, a2, description, ...)
 GHAssertEquals(a1, a2, description, ...)
 GHAbsoluteDifference(left,right) (MAX(left,right)-MIN(left,right))
 GHAssertEqualsWithAccuracy(a1, a2, accuracy, description, ...)
 GHFail(description, ...)
 GHAssertNil(a1, description, ...)
 GHAssertNotNil(a1, description, ...)
 GHAssertTrue(expr, description, ...)
 GHAssertTrueNoThrow(expr, description, ...)
 GHAssertFalse(expr, description, ...)
 GHAssertFalseNoThrow(expr, description, ...)
 GHAssertThrows(expr, description, ...)
 GHAssertThrowsSpecific(expr, specificException, description, ...)
 GHAssertThrowsSpecificNamed(expr, specificException, aName, description, ...)
 GHAssertNoThrow(expr, description, ...)
 GHAssertNoThrowSpecific(expr, specificException, description, ...)
 GHAssertNoThrowSpecificNamed(expr, specificException, aName, description, ...)
 @endcode

 */
 
/*!
 
 @page Customizing Customizing
 
 @section CustomTests Custom Test Case Classes
 
 You can register additional classes at runtime; if you have your own. For example:
 
 @code
 [[GHTesting sharedInstance] registerClassName:@"MySpecialTestCase"];
 @endcode 
 
 @section AlternateIOSAppDelegate Using an Alternate iPhone Application Delegate
 
 If you want to use a custom application delegate in your test environment, you should subclass GHUnitIPhoneAppDelegate:
 
 @code
 @interface MyTestApplicationDelegate : GHUnitIPhoneAppDelegate { }
 @end
 @endcode
 
 Then in GHUnitIPhoneTestMain.m:
 
 @code
 retVal = UIApplicationMain(argc, argv, nil, @"MyTestApplicationDelegate");
 @endcode
 
 I am looking into removing this dependency but this will work in the meantime.
 
 @section UsingSenTesting Using SenTestingKit
 
 You can also use GHUnit with SenTestCase, for example:
 
 @code
 #import <SenTestingKit/SenTestingKit.h>
 
 @interface MyTest : SenTestCase { }
 @end
 
 @implementation MyTest
 
 - (void)setUp {
   // Run before each test method
 }
 
 - (void)tearDown {
   // Run after each test method
 }
 
 - (void)testFoo {
   // Assert a is not NULL, with no custom error description
   STAssertNotNULL(a, nil);
 
   // Assert equal objects, add custom error description
   STAssertEqualObjects(a, b, @"Foo should be equal to: %@. Something bad happened", bar);
 }
 
 - (void)testBar {
   // Another test
 }
 
 @end
 @endcode

 */
 
/*!
 
 @page Hudson Hudson
 
 @section Using Using Hudson with GHUnit
 
 Hudson (http://hudson-ci.org/) is a continuous
 integration server that has a broad set of support and plugins, and is easy to set up. You
 can use Hudson to run your GHUnit tests after every checkin, and report the
 results to your development group in a variety of ways (by email, to Campfire,
 and so on).
 
 Here's how to set up Hudson with GHUnit.
 
 1. Follow the instructions to set up a Makefile for your GHUnit project.
 
 2. Download <tt>hudson.war</tt> from http://hudson-ci.org/.
 Run it with <tt>java -jar hudson.war</tt>. It will start up on 
 http://localhost:8080/
 
 3. Go to <tt>Manage Hudson -> Manage Plugins</tt> and install whatever plugins you
 need for your project.  For instance, you might want to install the Git 
 and GitHub plugins if you host your code on GitHub (http://www.github.com)
 
 4. Create a new job for your project and click on <tt>Configure</tt>. Most of the options
 are self-explanatory or can be figured out with the online help. You probably
 want to configure <tt>Source Code Management</tt>, and then under <tt>Build Triggers</tt> check
 <tt>Poll SCM</tt> and add a schedule of <tt>* * * * *</tt> (which checks your source control
 system for new changes once a minute).
 
 5. Under <tt>Build</tt>, enter the following command:
 
 @verbatim
 make clean && WRITE_JUNIT_XML=YES make test
 @endverbatim
 
 6. Under <tt/>Post-build Actions</tt>, check <tt/>Publish JUnit test result report</tt> and enter
 the following in <tt>Test report XMLs</tt>:
 
 @verbatim
 build/test-results/\*.xml
 @endverbatim
 
 That's all it takes. Check in a change that breaks one of your tests. Hudson
 should detect the change, run a build and test, and then report the failure.
 Fix the test, check in again, and you should see a successful build report.
 
 @section Troubleshooting Troubleshooting
 
 If your XCode build fails with a set of font-related errors, you may be running
 Hudson headless (e.g., via an SSH session). Launch Hudson via Terminal.app on 
 the build machine (or otherwise attach a DISPLAY to the session) in order to 
 address this.   
  
 */
