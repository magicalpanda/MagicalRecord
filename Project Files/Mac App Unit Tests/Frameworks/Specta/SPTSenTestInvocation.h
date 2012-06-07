#import <Foundation/Foundation.h>
#import "SpectaTypes.h"

@interface SPTSenTestInvocation : NSInvocation {
  SPTVoidBlock _SPT_invocationBlock;
}

@property (nonatomic, copy) SPTVoidBlock SPT_invocationBlock;

@end
