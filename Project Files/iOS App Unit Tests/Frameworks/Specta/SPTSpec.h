#import <Foundation/Foundation.h>

@class
  SPTExample
, SPTExampleGroup
;

@interface SPTSpec : NSObject {
  SPTExampleGroup *_rootGroup;
  NSMutableArray *_groupStack;
  NSArray *_compiledExamples;
  NSString *_fileName;
  NSUInteger _lineNumber;
}

@property (nonatomic, retain) SPTExampleGroup *rootGroup;
@property (nonatomic, retain) NSMutableArray *groupStack;
@property (nonatomic, retain) NSArray *compiledExamples;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic) NSUInteger lineNumber;

- (SPTExampleGroup *)currentGroup;
- (void)compile;

@end
