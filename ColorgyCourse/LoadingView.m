//
//  LoadingView.m
//  Colorgy
//
//  Created by 張子晏 on 2016/1/18.
//  Copyright © 2016年 張子晏. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoadingView

#pragma mark - Initializing

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentWindow = [UIApplication sharedApplication].keyWindow;
        
        self.frame = self.currentWindow.frame;
        // mask view
        self.maskView = [[UIView alloc] initWithFrame:self.frame];
        //        self.maskView.backgroundColor = [UIColor blackColor];
        
        [self addSubview:self.maskView];
        
        // alert view
        self.popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 125, 125)];
        self.popView.center = self.center;
        self.popView.layer.cornerRadius = 3.54;
        self.popView.layer.backgroundColor = [self UIColorFromRGB:248 green:150 blue:128 alpha:100].CGColor;
        
        [self addSubview:self.popView];
        
        // indicator view
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        self.indicatorView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.indicatorView.center = CGPointMake(self.center.x, self.center.y - 20);
        
        [self.indicatorView startAnimating];
        [self addSubview:self.indicatorView];
        
        self.loadingString = @"上傳中";
        self.finishedString = @"成功";
        
        // attributed message string
        NSAttributedString *attributedMessageString = [[NSAttributedString alloc] initWithString:self.loadingString attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"STHeitiTC-Light" size:18.0]}];
        
        // message label
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.popView.bounds.size.width - 20, 38)];
        self.messageLabel.center = CGPointMake(self.center.x, self.center.y + 30);
        self.messageLabel.attributedText = attributedMessageString;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.messageLabel];
        
        // email view
        self.emailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WhiteMail"]];
        self.emailImageView.center = CGPointMake(self.popView.center.x, self.popView.center.y - 15);
    }
    return self;
}

- (void)start {
    [self.window addSubview:self];
    [self.checkEmailButton removeFromSuperview];
    [self.emailImageView removeFromSuperview];
    [self.pathLayer removeFromSuperlayer];
    [self.indicatorView startAnimating];
    [self addSubview:self.indicatorView];
    
    self.popView.layer.backgroundColor = [self UIColorFromRGB:248 green:150 blue:128 alpha:100].CGColor;
    
    // attributed message string
    NSAttributedString *attributedMessageString = [[NSAttributedString alloc] initWithString:self.loadingString attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"STHeitiTC-Light" size:18.0]}];
    
    // message label
    self.messageLabel.attributedText = attributedMessageString;
    
    [self.currentWindow addSubview:self];
}

- (void)finished:(void (^)(void))callbackBlock {
    self.callbackBlock = callbackBlock;
    [self.indicatorView stopAnimating];
    [self.indicatorView removeFromSuperview];
    
    // attributed message string
    NSAttributedString *attributedMessageString = [[NSAttributedString alloc] initWithString:self.finishedString attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"STHeitiTC-Light" size:18.0]}];
    
    self.messageLabel.attributedText = attributedMessageString;
    
    [UIView animateWithDuration:1.0 animations:^{
        self.popView.layer.backgroundColor = [self UIColorFromRGB:0 green:207 blue:228 alpha:100].CGColor;
    } completion:^(BOOL finished){
    }];
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(40.0, 45.0)];
    [path addLineToPoint:CGPointMake(55.0, 60.0)];
    [path addLineToPoint:CGPointMake(85.0, 30.0)];
    
    self.pathLayer = [CAShapeLayer layer];
    
    self.pathLayer.frame = self.popView.frame;
    self.pathLayer.path = path.CGPath;
    self.pathLayer.strokeColor = [[UIColor whiteColor] CGColor];
    self.pathLayer.fillColor = nil;
    self.pathLayer.lineWidth = 2.0f;
    self.pathLayer.lineJoin = kCALineJoinBevel;
    
    [self.layer addSublayer:self.pathLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    pathAnimation.duration = 0.3;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss:callbackBlock];
    });
}

- (void)dismiss:(void (^)(void))callbackBlock {
    [self removeFromSuperview];
    
    if (callbackBlock) {
        callbackBlock();
    }
}

- (void)emailCheck {
    [self.window addSubview:self];
    [self.pathLayer removeFromSuperlayer];
    [self.indicatorView startAnimating];
    [self addSubview:self.emailImageView];
    
    self.popView.layer.backgroundColor = [self UIColorFromRGB:248 green:150 blue:128 alpha:100].CGColor;
    
    // attributed message string
    NSAttributedString *attributedMessageString = [[NSAttributedString alloc] initWithString:@"快去收信" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"STHeitiTC-Light" size:18.0]}];
    
    // message label
    self.messageLabel.attributedText = attributedMessageString;
    
    // check button
    self.checkEmailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkEmailButton.frame = CGRectMake(141, 440, 160, 41);
    self.checkEmailButton.backgroundColor = [UIColor clearColor];
    self.checkEmailButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.checkEmailButton.layer.borderWidth = 2.5;
    self.checkEmailButton.layer.cornerRadius = 2.5;
    self.checkEmailButton.center = CGPointMake(self.maskView.center.x, self.popView.center.y + 120);
    
    [self.checkEmailButton setTitle:@"收到認證信了" forState:UIControlStateNormal];
    [self.checkEmailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.checkEmailButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:20.0]];
    
    [self.maskView addSubview:self.checkEmailButton];
    
    [self.currentWindow addSubview:self];
    
}

#pragma mark - UIColor

- (UIColor *)UIColorFromRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:(alpha / 100)];
}

@end
