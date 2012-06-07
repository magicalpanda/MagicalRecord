#import <SenTestingKit/SenTestingKit.h>

@class
  SPTSpec
, SPTExample
;

@interface SPTSenTestCase : SenTestCase {
  NSInvocation *_SPT_invocation;
  SenTestCaseRun *_SPT_run;
}

@property (nonatomic, assign) NSInvocation *SPT_invocation;
@property (nonatomic, assign) SenTestCaseRun *SPT_run;

+ (SPTSpec *)SPT_spec;
- (void)SPT_setCurrentSpecWithFileName:(const char *)fileName lineNumber:(NSUInteger)lineNumber;
- (void)SPT_defineSpec;
- (void)SPT_unsetCurrentSpec;
- (void)SPT_runExampleAtIndex:(NSUInteger)index;
- (SPTExample *)SPT_getCurrentExample;

@end
