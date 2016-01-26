//
//  BlurWallSwitchViewController.m
//  ColorgyCourse
//
//  Created by 張子晏 on 2016/1/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BlurWallSwitchViewController.h"
#import "OpeningViewController.h"
#import "BlurWallViewController.h"

@interface BlurWallSwitchViewController ()

@end

@implementation BlurWallSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // View Customized
    self.view.backgroundColor = [self UIColorFromRGB:250.0 green:247.0 blue:245.0 alpha:100.0];
    
    self.isEmailOK = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 檢查信箱認證
//    if (![self isEmailOkCheck]) {
//        OpeningViewController *openingViewController = [[OpeningViewController alloc] init];
//        
//        [self.navigationController pushViewController:openingViewController animated:NO];
//    } else {
        BlurWallViewController *blurViewController = [[BlurWallViewController alloc] init];
        
        [self.navigationController pushViewController:blurViewController animated:NO];
//    }
}

- (BOOL)isEmailOkCheck {
    self.isEmailOK = !self.isEmailOK;
    return self.isEmailOK;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UIColor

- (UIColor *)UIColorFromRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:(alpha / 100)];
}

@end
