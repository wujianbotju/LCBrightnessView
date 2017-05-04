//
//  ViewController.m
//  LCBrightnessView
//
//  Created by wujianbo on 2017/5/4.
//  Copyright © 2017年 chaoui. All rights reserved.
//

#import "ViewController.h"
#import "LCBrightnessView.h"

@interface ViewController ()
{
    LCBrightnessView *brightnessView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    brightnessView = [[LCBrightnessView alloc] initWithFrame:CGRectZero];
    self.brightnessSlider.value = [UIScreen mainScreen].brightness;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)brightnessSliderValueChanged:(id)sender
{
    [UIScreen mainScreen].brightness = self.brightnessSlider.value;
    [brightnessView show];
}

- (IBAction)brightnessSliderTouchUp:(id)sender
{
    [brightnessView hideAnimated:YES];
}

@end
