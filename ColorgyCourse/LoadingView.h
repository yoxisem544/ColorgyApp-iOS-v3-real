//
//  LoadingView.h
//  Colorgy
//
//  Created by 張子晏 on 2016/1/18.
//  Copyright © 2016年 張子晏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

@property UIActivityIndicatorView *indicatorView;
@property UIView *popView;
@property UIView *maskView;
@property UIImageView *emailImageView;
@property UIButton *checkEmailButton;
@property UILabel *messageLabel;
@property NSString *loadingString;
@property NSString *finishedString;
@property CAShapeLayer *pathLayer;
@property (copy) void (^callbackBlock)(void);
@property UIWindow *currentWindow;
@property UIView *pathView;

- (instancetype)initJustFinished;
- (void)start;
- (void)justFinished;
- (void)finished:(void (^)(void))callbackBlock;
- (void)dismiss:(void (^)(void))callbackBlock;
// - (void)emailCheck;
- (UIColor *)UIColorFromRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

@end
