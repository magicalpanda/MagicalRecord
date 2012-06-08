//
//  GHUnitIOSTestView.h
//  GHUnitIOS
//
//  Created by John Boiles on 8/8/11.
//  Copyright 2011. All rights reserved.
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

#import <UIKit/UIKit.h>
#import "YKUIImageViewControl.h"

@class GHUnitIOSTestView;

@protocol GHUnitIOSTestViewDelegate <NSObject>
- (void)testViewDidSelectSavedImage:(GHUnitIOSTestView *)testView;
- (void)testViewDidSelectRenderedImage:(GHUnitIOSTestView *)testView;
- (void)testViewDidApproveChange:(GHUnitIOSTestView *)testView;
@end

@interface GHUnitIOSTestView : UIScrollView {
  id<GHUnitIOSTestViewDelegate> controlDelegate_;

  // TODO(johnb): Perhaps hold a scrollview here as subclassing UIViews can be weird.

  YKUIImageViewControl *savedImageView_;
  YKUIImageViewControl *renderedImageView_;

  UIButton *approveButton_;

  UILabel *textLabel_;
}
@property(assign, nonatomic) id<GHUnitIOSTestViewDelegate> controlDelegate;

- (void)setSavedImage:(UIImage *)savedImage renderedImage:(UIImage *)renderedImage text:(NSString *)text;

- (void)setText:(NSString *)text;

@end
