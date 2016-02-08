//
//  BlurWallSwitchViewController.m
//  ColorgyCourse
//
//  Created by 張子晏 on 2016/1/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BlurWallSwitchViewController.h"
#import "ColorgyChatAPIOC.h"
#import "ColorgyCourse-Swift.h"

@interface BlurWallSwitchViewController ()

@end

@implementation BlurWallSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [ColorgyChatAPI getQuestion:^(NSDictionary *response) {
//        if (![[response valueForKey:@"question"] isEqual:[NSNull null]]) {
//            self.lastestQuestion = [response valueForKey:@"question"];
//            self.questionDate = [response valueForKey:@"date"];
//        } else {
//            self.lastestQuestion = nil;
//            self.questionDate = nil;
//        }
//    } failure:^() {}];
	
    // View Customized
    self.view.backgroundColor = [self UIColorFromRGB:250.0 green:247.0 blue:245.0 alpha:100.0];
    self.isEmailOK = NO;
    
    self.openingViewController = [[OpeningViewController alloc] init];
    [self addChildViewController:self.openingViewController];
    
    
    BlurWallViewController *blurWallViewController = [[BlurWallViewController alloc] init];
    
    self.navigationBlurWallViewController = [[UINavigationController alloc] initWithRootViewController:blurWallViewController];
    [self addChildViewController:self.navigationBlurWallViewController];
    
    self.activityViewController = self.openingViewController;
    
    [self switchViewController];
}

#pragma mark - switcher

- (void)switchViewController {
    
    // 檢查信箱認證
    if ([self isEmailOkCheck]) {
        [self transitionFromViewController:self.activityViewController toViewController:self.navigationBlurWallViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
            if (finished) {
                [self.view addSubview:self.navigationBlurWallViewController.view];
                self.activityViewController = self.navigationBlurWallViewController;
                //[self didMoveToParentViewController:self];
            } else {
                self.activityViewController = self.openingViewController;
            }
        }];
    } else {
        [self transitionFromViewController:self.activityViewController toViewController:self.openingViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
            if (finished) {
                [self.view addSubview:self.openingViewController.view];
                self.activityViewController = self.openingViewController;
                //[self didMoveToParentViewController:self];
            } else {
                self.activityViewController = self.navigationBlurWallViewController;            }
        }];
    }
}

- (BOOL)isEmailOkCheck {
    if ([UserSetting UserOrganization]) {
        self.isEmailOK = YES;
    } else {
        self.isEmailOK = NO;
    }
    return self.isEmailOK;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIColor

- (UIColor *)UIColorFromRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:(alpha / 100)];
}

@end
