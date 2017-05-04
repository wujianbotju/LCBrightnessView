//
//  Created by wujianbo on 2017/4/19.
//  Copyright © 2017年 wujianbo. All rights reserved.
//

#import "LCBrightnessView.h"


static const CGFloat kBrightnessViewSize = 155;
static const NSInteger kBrightnessStepCount = 16;

@interface LCBrightnessView ()

@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIImageView		*backImage;
@property (nonatomic, strong) UILabel			*title;
@property (nonatomic, strong) UIView			*brightnessLevelView;
@property (nonatomic, strong) NSMutableArray	*tipArray;

@end

@implementation LCBrightnessView
@synthesize hideDelay;

- (instancetype)initWithFrame:(CGRect)frame
{
    CGSize windowSize = [UIApplication sharedApplication].keyWindow.bounds.size;
    CGFloat x = (windowSize.width - kBrightnessViewSize) / 2.0f;
    CGFloat y = (windowSize.height - kBrightnessViewSize) / 2.0f;
    if (self = [super initWithFrame:CGRectMake(x, y, kBrightnessViewSize, kBrightnessViewSize)])
    {
        [self setupUI];
	}
    self.userInteractionEnabled = NO;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.layer.allowsGroupOpacity = NO;
    hideDelay = 1.5f;
	return self;
}

- (void)setupUI
{
    self.layer.cornerRadius  = 10;
    self.layer.masksToBounds = YES;
    
    // Blur effect
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    _effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    _effectView.frame = self.bounds;
//    [self addSubview:_effectView];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
    [self addSubview:toolbar];
    
    [self addSubview:self.backImage];
    [self addSubview:self.title];
    [self addSubview:self.brightnessLevelView];
    
    [self createTips];
    [self addStatusBarNotification];
    [self addKVOObserver];
}

- (void)createTips
{
	self.tipArray = [NSMutableArray arrayWithCapacity:kBrightnessStepCount];
	CGFloat tipW = (self.brightnessLevelView.bounds.size.width - 17) / kBrightnessStepCount;
	CGFloat tipH = 5;
	CGFloat tipY = 1;
    
    for (int i = 0; i < kBrightnessStepCount; i++)
    {
        CGFloat tipX   = i * (tipW + 1) + 1;
        UIImageView *image    = [[UIImageView alloc] init];
        image.backgroundColor = [UIColor whiteColor];
        image.frame           = CGRectMake(tipX, tipY, tipW, tipH);
		[self.brightnessLevelView addSubview:image];
		[self.tipArray addObject:image];
	}
	[self updateBrightnessLevel:[UIScreen mainScreen].brightness];
}

- (void)addStatusBarNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarOrientationNotification:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)statusBarOrientationNotification:(NSNotification *)notify
{
    if (self.superview)
    {
        self.center = CGPointMake(self.superview.bounds.size.width*0.5f, self.superview.bounds.size.height*0.5f);
    }
    [self layoutIfNeeded];
}

- (void)addKVOObserver
{
	[[UIScreen mainScreen] addObserver:self
							forKeyPath:@"brightness"
							   options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat levelValue = [change[NSKeyValueChangeNewKey] floatValue];
    [self updateBrightnessLevel:levelValue];
}

- (void)updateBrightnessLevel:(CGFloat)brightnessLevel
{
    //kBrightnessStepCount - 1: make sure at least one tip is shown
	NSInteger level = brightnessLevel * (kBrightnessStepCount - 1);
    for (int i = 0; i < self.tipArray.count; i++)
    {
		UIImageView *img = self.tipArray[i];
        img.hidden = i > level;
	}
}

- (void)hideImplementationWithAnimated:(NSNumber*)animated
{
    if ([animated boolValue])
    {
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
            }
        }];
    }
    else
    {
        [self removeFromSuperview];
    }
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(kBrightnessViewSize, kBrightnessViewSize);
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[UIScreen mainScreen] removeObserver:self forKeyPath:@"brightness"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

#pragma mark - Custom getter
- (UILabel*)title
{
    if (!_title)
    {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 30)];
        _title.font = [UIFont boldSystemFontOfSize:16];
        _title.textColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.0f];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.text = @"亮度";
    }
    return _title;
}

- (UIImageView *)backImage
{
    if (!_backImage)
    {
        CGFloat x = (kBrightnessViewSize - 70) * 0.5;
        CGFloat y = (kBrightnessViewSize - 70) * 0.5;
        _backImage = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 70, 70)];
        _backImage.image  = [UIImage imageNamed:@"brightness"];
    }
    return _backImage;
}

- (UIView *)brightnessLevelView
{
    if (!_brightnessLevelView)
    {
        _brightnessLevelView  = [[UIView alloc] initWithFrame:CGRectMake(13, 132, self.bounds.size.width - 26, 7)];
        _brightnessLevelView.backgroundColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.0f];
        [self addSubview:_brightnessLevelView];
    }
    return _brightnessLevelView;
}

#pragma mark - Public APIs
- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self showInView:keyWindow];
}

- (void)showInView:(UIView*)superView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self.layer removeAllAnimations];
    self.alpha = 1;
    if (self.superview != superView)
    {
        [superView addSubview:self];
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        centerXConstraint.active = YES;
        centerYConstraint.active = YES;
    }
    else
    {
        [superView bringSubviewToFront:self];
    }
}

- (void)hideAnimated:(BOOL)animated
{
    [self hideAnimated:animated immediately:NO];
}

- (void)hideAnimated:(BOOL)animated immediately:(BOOL)immediately
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if (hideDelay > 0 && !immediately)
    {
        [self performSelector:@selector(hideImplementationWithAnimated:) withObject:@(animated) afterDelay:hideDelay];
    }
    else
    {
        [self hideImplementationWithAnimated:@(animated)];
    }
}

@end
