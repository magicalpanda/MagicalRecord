//
//  GHTestOutlineViewModel.h
//  GHUnit
//
//  Created by Gabriel Handford on 7/17/09.
//  Copyright 2009. All rights reserved.
//

#import "GHTestViewModel.h"
@class GHTestOutlineViewModel;


@protocol GHTestOutlineViewModelDelegate <NSObject>
- (void)testOutlineViewModelDidChangeSelection:(GHTestOutlineViewModel *)testOutlineViewModel;
@end



@interface GHTestOutlineViewModel : GHTestViewModel 
#if MAC_OS_X_VERSION_MAX_ALLOWED >= 1060 // on lines like this to not confuse IB
  <NSOutlineViewDelegate, NSOutlineViewDataSource> 	
#endif
{
	id<GHTestOutlineViewModelDelegate> delegate_; // weak
	
	NSButtonCell *editCell_;
}

@property (assign, nonatomic) id<GHTestOutlineViewModelDelegate> delegate;

@end
