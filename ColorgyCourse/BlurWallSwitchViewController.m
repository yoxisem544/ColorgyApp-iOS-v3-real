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
    
    self.navigationController.navigationBarHidden = YES;
    
    // View Customized
    self.view.backgroundColor = [self UIColorFromRGB:250.0 green:247.0 blue:245.0 alpha:100.0];
    self.isEmailOK = NO;
    [self childViewLayoutInitializing];
}

- (void)childViewLayoutInitializing {
    self.openingViewController = [[OpeningViewController alloc] initWithLayout:0];
    [self addChildViewController:self.openingViewController];
    
    self.blurWallViewController = [[BlurWallViewController alloc] init];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.navigationBlurWallViewController = [[UINavigationController alloc] initWithRootViewController:self.blurWallViewController];
    [self addChildViewController:self.navigationBlurWallViewController];
    
    self.activityViewController = self.openingViewController;
    
    // Do any additional setup after loading the view.
    [ColorgyChatAPI getQuestion:^(NSString *date, NSString *question) {
        self.lastestQuestion = question;
        self.questionDate = date;
        [self switchViewController];
    } failure:^() {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失敗Q_Q" message:@"請檢查網路連線是否正常，使用模糊聊需要完整的網路功能" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"重試" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self childViewLayoutInitializing];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"瞭解" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // SubmitNameButtom Customized
            self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.refreshButton.frame = CGRectMake(141, 440, 120, 41);
            self.refreshButton.backgroundColor = [UIColor clearColor];
            self.refreshButton.layer.borderColor = [self UIColorFromRGB:248 green:150 blue:128 alpha:100].CGColor;
            self.refreshButton.layer.borderWidth = 2.5;
            self.refreshButton.layer.cornerRadius = 2.5;
            self.refreshButton.center = self.view.center;
            
            // SubmitNameButtom Customized
            [self.refreshButton setTitle:@"重試" forState:UIControlStateNormal];
            [self.refreshButton setTitleColor:[self UIColorFromRGB:248 green:150 blue:128 alpha:100] forState:UIControlStateNormal];
            [self.refreshButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:20.0]];

            [self.refreshButton addTarget:self action:@selector(childViewLayoutInitializing) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:self.refreshButton];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

#pragma mark - switcher

- (void)switchViewController {
    
    // 檢查信箱認證
    if (NO && [self isEmailOkCheck]) {
        // 模糊牆
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
        // 信箱認證
        [self transitionFromViewController:self.activityViewController toViewController:self.openingViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
            if (finished) {
                [self.view addSubview:self.openingViewController.view];
                self.activityViewController = self.openingViewController;
                //[self didMoveToParentViewController:self];
            } else {
                self.activityViewController = self.navigationBlurWallViewController;
            }
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
