//
//  HelloViewController.m
//  ColorgyCourse
//
//  Created by 張子晏 on 2016/2/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import "HelloViewController.h"
#import "ColorgyCourse-Swift.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HelloViewController ()

@property ChatUserInformation *information;

@end

@implementation HelloViewController

- (instancetype)initWithInformaion:(ChatUserInformation *)information {
    self = [super init];
    if (self) {
        self.information = information;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layout];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout

- (void)layout {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTintColor:[self UIColorFromRGB:248 green:150 blue:128 alpha:100]];
    [self.tabBarController.tabBar setHidden:YES];
    
    // UserImageView
    CGFloat userImageViewLength = self.view.bounds.size.width;
    
    self.userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, userImageViewLength, userImageViewLength)];
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:self.information.avatarBlur2XURL]];
    self.userImageView.contentMode = UIViewContentModeScaleAspectFit;
    NSLog(@"%@", [self.information description]);
    [self.view addSubview:self.userImageView];
    
    // set gradient
    UIView *gradientView = [[UIView alloc] initWithFrame:self.userImageView.frame];
    
    gradientView.alpha = 0.5;
    gradientView.center = CGPointMake(self.userImageView.bounds.size.width / 2, self.userImageView.bounds.size.height / 2);
    
    [self.userImageView addSubview:gradientView];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = gradientView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil]; // 由上到下的漸層顏色
    [gradientView.layer insertSublayer:gradient atIndex:0];
    
    // ButtonView
    CGFloat buttonViewHeight = 64;
    
    self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - buttonViewHeight, CGRectGetWidth(self.view.bounds), buttonViewHeight)];
    [self.buttonView setBackgroundColor:[self UIColorFromRGB:59 green:58 blue:59 alpha:100]];
    [self.view addSubview:self.buttonView];
    
    // helloButton
    CGFloat helloButtonWidth = CGRectGetWidth(self.view.bounds) - 100;
    CGFloat helloButtonHeight = 40;
    
    self.helloButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.helloButton setFrame:CGRectMake(0, 0, helloButtonWidth, helloButtonHeight)];
    [self.helloButton setCenter:CGPointMake(self.buttonView.bounds.size.width / 2, self.buttonView.bounds.size.height / 2)];
    [self.helloButton setBackgroundColor:[self UIColorFromRGB:59 green:58 blue:59 alpha:100]];
    [self.helloButton.layer setCornerRadius:2.5];
    [self.helloButton.layer setBorderColor:[self UIColorFromRGB:248 green:150 blue:128 alpha:100].CGColor];
    [self.helloButton.layer setBorderWidth:1.5];
    
    
    [self.helloButton setTitleColor:[self UIColorFromRGB:248 green:150 blue:128 alpha:100] forState:UIControlStateNormal];
    [self.helloButton setTitle:@"打招呼" forState:UIControlStateNormal];
    [self.buttonView addSubview:self.helloButton];
    
    // Cheack hi
    [ColorgyChatAPI checkUserAvailability:^(ChatUser *chatUser) {
        [ColorgyChatAPI checkHi:chatUser.userId targetId:self.information.id success:^(BOOL can) {
            if (can) {
                [self.helloButton setTitle:@"打招呼" forState:UIControlStateNormal];
                [self.helloButton addTarget:self action:@selector(helloAction) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [self.helloButton setTitle:@"已打招呼" forState:UIControlStateNormal];
                [self.buttonView addSubview:self.helloButton];
            }
        } failure:^() {}];
    } failure:^() {}];
    
    // scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, userImageViewLength, self.view.bounds.size.width, self.view.bounds.size.height - userImageViewLength - self.buttonView.bounds.size.height)];
    self.scrollView.contentSize = CGSizeMake(1000, 1000);
    self.scrollView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.scrollView];
}

- (void)scrollViewLayout {
}

#pragma mark - Hello Action
- (void)helloAction {
    [ColorgyChatAPI checkUserAvailability:^(ChatUser *chatUser) {
        [ColorgyChatAPI sayHi:chatUser.userId targetId:self.information.id message:@"你好美女！！" success:^() {
            [self.helloButton setTitle:@"已打招呼" forState:UIControlStateNormal];
            [self.helloButton removeTarget:self action:@selector(helloAction) forControlEvents:UIControlEventTouchUpInside];
        } failure:^() {}];
    } failure:^() {}];
}

#pragma mark - UIColor

- (UIColor *)UIColorFromRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:(alpha / 100)];
}

@end
