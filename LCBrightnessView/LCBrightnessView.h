//
//  Created by wujianbo on 2017/4/26.
//  Copyright © 2017年 wujianbo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  A UIView to show device brightness like system volume view
 *  Please use [UIScreen mainScreen].brightness to change device brightness (It doesn't work with simulator)
 */
@interface LCBrightnessView : UIView
{
    NSTimeInterval hideDelay;       //hide delay time after call hideAnimated. default value is 1.5s
}

@property (nonatomic, assign) NSTimeInterval hideDelay;

/**
 *  initialize
 *
 *  @param frame argument frame will be ignored, LCBrightnessView will shown in the center of screen with fixed size
 *
 *  @return LCBrightnessView object
 */
- (instancetype)initWithFrame:(CGRect)frame;


/**
 *  show in key window
 */
- (void)show;

/**
 *  show in specified view
 *
 *  @param superView LCBrightnessView will be added to
 */
- (void)showInView:(UIView*)superView;


/**
 *  LCBrightnessView will not be hidden immediately after calling this method. Please see property hideDelay.
 *  If hideDelay is equal or less than 0, view will be hidden immediately
 *
 *  @param animated use animation or not
 */
- (void)hideAnimated:(BOOL)animated;

/**
 *  hide LCBrightnessView with more arguments
 *
 *  @param animated    use animation or not
 *  @param immediately hide LCBrightnessView immediately or not
 */
- (void)hideAnimated:(BOOL)animated immediately:(BOOL)immediately;

@end
