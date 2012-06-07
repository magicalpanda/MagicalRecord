// A Specta Test for MagicalFactorySepcs

#import "Specta.h"

SpecBegin(MagicalFactorySepcs)

describe(@"MagicalFactorySepcs", ^{

      context(@"On loading", ^{
        __block NSObject *object = nil;
            
        beforeEach(^{ 
            object = [[NSObject alloc] init];
        });
        
        it(@"should exist", ^{
            STAssertNotNil(object, @"should not be nil");
        });

    });
});

SpecEnd
