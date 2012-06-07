#import <Foundation/Foundation.h>
#import "SpectaTypes.h"

@class
  SPTExampleGroup
;

@interface SPTSharedExampleGroups : NSObject

+ (void)addSharedExampleGroupWithName:(NSString *)name block:(SPTDictionaryBlock)block exampleGroup:(SPTExampleGroup *)exampleGroup;
+ (SPTDictionaryBlock)sharedExampleGroupWithName:(NSString *)name exampleGroup:(SPTExampleGroup *)exampleGroup;
+ (void)defineSharedExampleGroups;

@end

