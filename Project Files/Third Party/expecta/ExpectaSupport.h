#import "EXPExpect.h"
#import "EXPBlockDefinedMatcher.h"

id _EXPObjectify(char *type, ...);
EXPExpect *_EXP_expect(id testCase, int lineNumber, char *fileName, EXPIdBlock actualBlock);

void EXPFail(id testCase, int lineNumber, char *fileName, NSString *message);
NSString *EXPDescribeObject(id obj);

void EXP_prerequisite(EXPBoolBlock block);
void EXP_match(EXPBoolBlock block);
void EXP_failureMessageForTo(EXPStringBlock block);
void EXP_failureMessageForNotTo(EXPStringBlock block);

// workaround for the categories bug: http://developer.apple.com/library/mac/#qa/qa1490/_index.html
#define EXPFixCategoriesBug(name) \
@interface EXPFixCategoriesBug##name; @end \
@implementation EXPFixCategoriesBug##name; @end

#define _EXPMatcherInterface(matcherName, matcherArguments) \
@interface EXPExpect (matcherName##Matcher) \
@property (nonatomic, readonly) void(^ matcherName) matcherArguments; \
@end

#define _EXPMatcherImplementationBegin(matcherName, matcherArguments) \
EXPFixCategoriesBug(EXPMatcher##matcherName##Matcher); \
@implementation EXPExpect (matcherName##Matcher) \
@dynamic matcherName;\
- (void(^) matcherArguments) matcherName { \
  EXPBlockDefinedMatcher *matcher = [[EXPBlockDefinedMatcher alloc] init]; \
  [[[NSThread currentThread] threadDictionary] setObject:matcher forKey:@"EXP_currentMatcher"]; \
  __block id actual = self.actual; \
  __block void (^prerequisite)(EXPBoolBlock block) = ^(EXPBoolBlock block) { EXP_prerequisite(block); }; \
  __block void (^match)(EXPBoolBlock block) = ^(EXPBoolBlock block) { EXP_match(block); }; \
  __block void (^failureMessageForTo)(EXPStringBlock block) = ^(EXPStringBlock block) { EXP_failureMessageForTo(block); }; \
  __block void (^failureMessageForNotTo)(EXPStringBlock block) = ^(EXPStringBlock block) { EXP_failureMessageForNotTo(block); }; \
  prerequisite(nil); match(nil); failureMessageForTo(nil); failureMessageForNotTo(nil); \
  void (^matcherBlock) matcherArguments = ^ matcherArguments { \
    {

#define _EXPMatcherImplementationEnd \
    } \
    [self applyMatcher:matcher to:&actual]; \
  }; \
  return [[matcherBlock copy] autorelease]; \
} \
@end
