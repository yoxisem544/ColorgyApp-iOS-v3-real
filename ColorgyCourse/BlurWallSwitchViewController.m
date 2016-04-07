//
//  BlurWallSwitchViewController.m
//  ColorgyCourse
//
//  Created by 張子晏 on 2016/1/26.
//  Copyright © 2016年 David. All rights reserved.
//
/*
    模糊牆與註冊設計理念，兩個主功能建立在BlurWallSwitcher，
    透過switchViewController這個method進行子控制器的切換，
    達成。
 
    在這邊描述一下我們可以改進的方向：
    1. Model跟Controller切的不夠清楚，現在是Controller直接
    呼叫Api跟Server拿資料，所以造成同樣的資料大量重複拿取。建議
    ，有個專門的控制器負責處理，並管理（尤其是圖片！！）。
    2. 跳轉如何實現？透過AppDelegate接收跳轉頁面的資訊，並通知給
    TabBarController並Push到目標畫面，所以TabBar之前要先有NivigationController才可以Push，按下返回鍵，會回到TabBarController。
*/

#import "BlurWallSwitchViewController.h"
#import "ColorgyChatAPIOC.h"
#import "ColorgyCourse-Swift.h"

#define DEBUG_TAG() printf("debug+ [%s], line=%d, func=%s\n", __FILE__, __LINE__, __func__)

@interface BlurWallSwitchViewController ()

@end

@implementation BlurWallSwitchViewController

#pragma mark - Life Cycle

// 為了解決快速使用者切換所設計的，在切換使用者後會重置註冊頁面
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	// 檢查使用者的學校
	NSString *userOrg = [self getUserOrganization];
	if (userOrg) {
		NSLog(@"%@", userOrg);
		NSLog(@"%@", userOrg);
		[ColorgyAPI availableOrganization:userOrg success:^(BOOL isAvailable) {
			if (isAvailable) {
				// 檢查現在的user是否更換，更換的話重置重置註冊頁面並切換子控制器
				[ColorgyChatAPI checkUserAvailability:^(ChatUser *chatUser) {
					NSLog(@"%@, %@", chatUser.userId, self.chatUser.userId);
					if (![chatUser.userId isEqualToString:self.chatUser.userId] && chatUser.userId && self.chatUser.userId) {
						// change user
						self.chatUser = chatUser;
						[self.openingViewController refreshView]; // 重置註冊頁面
						[self switchViewController]; // 切換子控制器
					}
				} failure:^() {
					NSLog(@"check user availability error in BlurWallSwitchController");
					DEBUG_TAG();
				}];
			} else {
				// set view
				[self setupNotYetAvailableView];
			}
		} failure:^{
			
		}];
	}
}

// 檢查使用者的學校並且回傳
- (NSString *)getUserOrganization {
	NSString *userPossibleOrg = [UserSetting UserPossibleOrganization];
	NSString *userOrg = [UserSetting UserOrganization];
	
	if (userOrg) {
		return userOrg;
	} else if (userPossibleOrg) {
		return userPossibleOrg;
	} else {
		return nil;
	}
}

// 尚未開放的畫面
- (void)setupNotYetAvailableView {
	if (!self.notAvailableLabel) {
		self.notAvailableLabel = [[UILabel alloc] init];
		self.notAvailableLabel.textAlignment = NSTextAlignmentCenter;
		self.notAvailableLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
		self.notAvailableLabel.clipsToBounds = YES;
		self.notAvailableLabel.text = @"您的學校尚未開放模糊聊的功能喔！";
		self.notAvailableLabel.font = [UIFont systemFontOfSize:16];
		self.notAvailableLabel.layer.cornerRadius = 4.0;
		self.notAvailableLabel.frame = CGRectMake(0, 0, 290, 40);
		self.notAvailableLabel.center = self.view.center;
		if (self.notAvailableLabel.superview != self.view) {
			[self.view addSubview:self.notAvailableLabel];
		}
	}
}

// 畫面Load完，會初始化子控制器，再檢查使用者，失敗的話會出現提醒視窗並新增個重試的按鈕，重試會呼叫切換子控制器的方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self childViewLayoutInitializing]; // 初始化子控制器
    [self switchViewController]; // 切換子控制器
    
    self.navigationController.navigationBarHidden = YES;
    
    // View Customized
    self.view.backgroundColor = [self UIColorFromRGB:250.0 green:247.0 blue:245.0 alpha:100.0];
}

// 初始化兩個子控制器，一個是註冊另外個是模糊牆
- (void)childViewLayoutInitializing {
    self.openingViewController = [[OpeningViewController alloc] init];
    [self addChildViewController:self.openingViewController];
    
    self.blurWallViewController = [[BlurWallViewController alloc] init];
    
    self.navigationController.navigationBarHidden = YES;
    
    // 模糊牆基本上是一個導航控制器的根控制器
    self.navigationBlurWallViewController = [[UINavigationController alloc] initWithRootViewController:self.blurWallViewController];
    [self addChildViewController:self.navigationBlurWallViewController];
    
    // 登記現在的控制器
    self.activityViewController = self.openingViewController;
    [self checkCurrentController]; // 檢查現在的控制器
}

// 秀出現在的控制器為何者
- (void)checkCurrentController {
    if (self.activityViewController) {
        if (self.activityViewController == self.openingViewController) {
            NSLog(@"is in openingViewController now");
        } else if (self.activityViewController == self.blurWallViewController) {
            NSLog(@"is in blurWallViewController now");
        } else {
            NSLog(@"activityViewController is other");
        }
    } else {
        NSLog(@"activityViewController is nil");
    }
}

#pragma mark - switcher

// 切換子控制器，幾本上會透過使用者狀態去決定是否合格進入模糊牆
- (void)switchViewController {
	
	// 檢查學校是否開放
	NSString *userOrg = [self getUserOrganization];
	if (userOrg) {
		[ColorgyAPI availableOrganization:userOrg success:^(BOOL isAvailable) {
			if (isAvailable) {
				[ColorgyChatAPI checkUserAvailability:^(ChatUser *user) {
					self.chatUser = user;
					
					// 檢查信箱認證，狀態大於等於3跟不等於5的可以進入
					if (self.chatUser.status.intValue >= 3 && self.chatUser.status.intValue != 5) {
						
						// 切換為模糊牆
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
						// 切換為註冊
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
					[self checkCurrentController]; // 秀出現在子控制器
				} failure:^() {
					NSLog(@"checkUserAvaliable error");
					DEBUG_TAG();
					
					// 彈出提醒視窗
					UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失敗Q_Q" message:@"請檢查網路連線是否正常，使用模糊聊需要完整的網路功能" preferredStyle:UIAlertControllerStyleAlert];
					
					[alertController addAction:[UIAlertAction actionWithTitle:@"重試" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
						[self switchViewController]; // 嘗試切換子視窗
					}]];
					
					// 新增重試按鈕
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
						
						[self.refreshButton addTarget:self action:@selector(switchViewController) forControlEvents:UIControlEventTouchUpInside]; // 嘗試切換子視窗
						
						[self.view addSubview:self.refreshButton];
					}]];
					[self presentViewController:alertController animated:YES completion:nil];
					[self checkCurrentController];
				}];

			} else {
				// set view
				[self setupNotYetAvailableView];
			}
		} failure:^{
			
		}];
	}
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIColor

// UIColor產生器
- (UIColor *)UIColorFromRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:(alpha / 100)];
}

@end
