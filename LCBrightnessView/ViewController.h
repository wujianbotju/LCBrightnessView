//
//  ViewController.h
//  LCBrightnessView
//
//  Created by wujianbo on 2017/5/4.
//  Copyright © 2017年 chaoui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UISlider *brightnessSlider;

- (IBAction)brightnessSliderValueChanged:(id)sender;

- (IBAction)brightnessSliderTouchUp:(id)sender;

@end

