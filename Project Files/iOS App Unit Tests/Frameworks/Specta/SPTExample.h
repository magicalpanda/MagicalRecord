#import <Foundation/Foundation.h>
#import "SpectaTypes.h"

@interface SPTExample : NSObject {
  NSString *_name;
  SPTVoidBlock _block;
  BOOL _pending;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) SPTVoidBlock block;
@property (nonatomic) BOOL pending;

- (id)initWithName:(NSString *)name block:(SPTVoidBlock)block;

@end

