//
//  HelloViewController.m
//  ColorgyCourse
//
//  Created by 張子晏 on 2016/2/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import "HelloViewController.h"
#import "ColorgyCourse-Swift.h"
#import "LoadingView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HelloViewController () {
    LoadingView *loadingView;
}

@property AvailableTarget *information;

@end

@implementation HelloViewController {
    BOOL hidenTabbar;
    BOOL translucent;
}

- (instancetype)initWithInformaion:(AvailableTarget *)information {
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
    self.tabBarController.tabBarController.hidesBottomBarWhenPushed = YES;
    translucent = self.navigationController.navigationBar.translucent;
    self.navigationController.navigationBar.translucent = YES;
    //    [self performSegueWithIdentifier:@"to chat room" sender:nil];
    // 跳轉
    
    //    [ColorgyChatAPI checkUserAvailability:^(ChatUser *chatUser) {
    //        [ColorgyChatAPI checkHi:chatUser.userId targetId:self.information.id success:^(BOOL can, NSString *who) {
    //            if (who) {
    //                [ColorgyChatAPI getHiList:chatUser.userId success:^(NSArray *hellos) {
    //                    for (Hello *hello in hellos) {
    //                        if ([hello.userId isEqualToString:chatUser.userId] && [hello.targetId isEqualToString:self.information.id]) {
    //                            [ColorgyChatAPI acceptHi:chatUser.userId hiId:hello.id success:^() {
    //                                [ColorgyChatAPI ]
    //                                ChatRoomViewController *vc = [[ChatRoomViewController alloc] init];
    //
    //                                vc.userId = chatUser.userId;
    //                                vc.uuid = [UserSetting UserUUID];
    //                                vc.chatroomId = hello.
    //                            } failure:^() {
    //                                NSLog(@"accept HI 失敗");
    //                            }];
    //                        }
    //                    }
    //                } failure:^() {
    //                    NSLog(@"get hi list failure");
    //                }];
    //            }
    //        } failure:^() {
    //            NSLog(@"check hi 失敗");
    //        }];
    //    } failure:^() {
    //        NSLog(@"check user failure");
    //    }];
    
    
    //    "already said hi" {
    //        // can't say hi, return false
    //        success(canSayHi: false, whoSaidHi: "you already said hi")
    //				} else if json["result"].string == "ok, you can say hi" {
    //                    // can say hi, return true
    //                    success(canSayHi: true, whoSaidHi: nil)
    //                } else if json["result"].string == "target already said hi" {
    //                    success(canSayHi: false, whoSaidHi: "He/She already said hi")
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    hidenTabbar = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (hidenTabbar) {
        [self.tabBarController.tabBar setHidden:NO];
    }
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.translucent = translucent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout

- (void)layout {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
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
    
    // set messageRect
#pragma mark-Warning
    UIImageView *messageRect = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"messageRect2"]];
    //    UIImageView *messageRect = [[UIImageView alloc] init];
    //
    //    messageRect.layer.borderWidth = 1.5;
    //    messageRect.layer.cornerRadius = 3.0;
    //    messageRect.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    messageRect.frame = CGRectMake(0, 0, userImageViewLength - 100, 60);
    messageRect.center = CGPointMake(self.userImageView.frame.size.width / 2, self.userImageView.frame.size.height - 50);
    
    [self.userImageView addSubview:messageRect];
    
    // set message
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 15, messageRect.bounds.size.width - 16, messageRect.bounds.size.height - 20)];
    messageLabel.text = self.information.lastAnswer;
    //    messageLabel.text = @"我是帥哥我是帥哥我是帥哥我是帥哥我是帥哥";
    messageLabel.numberOfLines = 2;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    //messageLabel.backgroundColor = [UIColor yellowColor];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14.0];
    
#pragma mark-Warning
    //    [messageLabel sizeToFit];
    
    //    messageRect.frame = CGRectMake(0, 0, messageLabel.bounds.size.width + 25, 60);
    //    messageRect.center = CGPointMake(self.userImageView.frame.size.width / 2, self.userImageView.frame.size.height - 50);
    
    [messageRect addSubview:messageLabel];
    
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
        [ColorgyChatAPI checkHi:chatUser.userId targetId:self.information.id success:^(BOOL can, NSString *who, NSString *chatroomId) {
            if (can) {
                [self.helloButton setTitle:@"打招呼" forState:UIControlStateNormal];
                [self.helloButton addTarget:self action:@selector(helloAction) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [self.helloButton setTitle:@"已打招呼" forState:UIControlStateNormal];
                [self.buttonView addSubview:self.helloButton];
            }
        } failure:^() {
            NSLog(@"check hi 失敗");
        }];
    } failure:^() {
        NSLog(@"check user 失敗");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失敗Q_Q" message:@"請網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
    // scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, userImageViewLength, self.view.bounds.size.width, self.view.bounds.size.height - userImageViewLength - self.buttonView.bounds.size.height)];
    self.scrollView.contentSize = CGSizeMake(1000, 1000);
    self.scrollView.backgroundColor = [self UIColorFromRGB:250 green:247 blue:245 alpha:100];
    [self.view addSubview:self.scrollView];
    
    [self scrollViewLayout];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 24, 40)];
    
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    //    backButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
}

- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewLayout {
    CGFloat marginY = 10;
    CGFloat marginX = 30;
    UIView *aboutView = [[UIView alloc] initWithFrame:CGRectMake(marginX, marginY, self.scrollView.bounds.size.width - 2 * marginX, 44)];
    aboutView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:aboutView];
    CGFloat paddingX = 40;
    CGFloat paddingY = 10;
    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingX, paddingY, aboutView.bounds.size.width - 2 * paddingX, 15)];
    aboutLabel.center = CGPointMake(aboutView.bounds.size.width / 2, aboutView.bounds.size.height / 2);
    
    NSString *aboutLabelString = nil;
    
    if ([self.information.aboutSchool length]) {
        aboutLabelString = self.information.aboutSchool;
    }
    if ([self.information.aboutHabitancy length]) {
        aboutLabelString = [aboutLabelString stringByAppendingString:@" . "];
        aboutLabelString = [aboutLabelString stringByAppendingString:self.information.aboutHabitancy];
    }
    if ([self.information.aboutHoroscope length]) {
        aboutLabelString = [aboutLabelString stringByAppendingString:@" . "];
        aboutLabelString = [aboutLabelString stringByAppendingString:self.information.aboutHoroscope];
    }
    
    //    if (self.information.organizationCode) {
    //        organizationCodeLabel.text = self.information.organizationCode;
    //    } else {
    aboutLabel.text = aboutLabelString;
    aboutLabel.textAlignment = NSTextAlignmentCenter;
    //    }
    aboutLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14.0];
    aboutLabel.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    aboutLabel.minimumScaleFactor = 0.6;
    aboutLabel.adjustsFontSizeToFitWidth = YES;
    [aboutView addSubview:aboutLabel];
    
    // about infromation layout
    UIView *aboutInformationView = [[UIView alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(aboutView.frame) + marginY, aboutView.bounds.size.width, 100)];
    
    aboutInformationView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:aboutInformationView];
    //
    //    self.information.aboutConversation = @"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
    //    self.information.aboutExpertise = @"我愛打飛機我愛打飛機我愛打飛機我愛打飛機我愛打飛機我愛打飛機我愛打飛機我愛打飛機我愛打飛機我愛打飛機我愛打飛機我愛打飛機";
    //    self.information.aboutPassion = @"我熱衷看ㄆ我熱衷看ㄆ我熱衷看ㄆ我熱衷看ㄆ我熱衷看ㄆ我熱衷看ㄆ我熱衷看ㄆ我熱衷看ㄆ我熱衷看ㄆ我熱衷看ㄆ我熱衷看ㄆ我熱衷看ㄆ";
    CGFloat sectionY = 30;
    CGFloat currentY = paddingY; // 計算現在偏移位置
    
    
    // 檢查有無留下資料
    if (self.information.aboutConversation.length || self.information.aboutPassion.length || self.information.aboutExpertise.length) {
        
        // 檢查各個about有的話會顯示，沒有的話會自動隱藏
        if (self.information.aboutExpertise.length) {
            UILabel *aboutExpertiseTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingX, currentY + 10, aboutView.bounds.size.width - 2 * paddingX, 15)];
            
            aboutExpertiseTitleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:13.0];
            aboutExpertiseTitleLabel.textColor = [self UIColorFromRGB:248 green:150 blue:128 alpha:100];
            aboutExpertiseTitleLabel.text = @"專精的事情";
            //            aboutExpertiseTitleLabel.backgroundColor = [UIColor yellowColor];
            [aboutInformationView addSubview:aboutExpertiseTitleLabel];
            currentY = CGRectGetMaxY(aboutExpertiseTitleLabel.frame);
            currentY += paddingY;
            UILabel *aboutExpertiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingX, currentY, aboutView.bounds.size.width - 2 * paddingX, 15)];
            
            aboutExpertiseLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:15.0];
            aboutExpertiseLabel.textColor = [self UIColorFromRGB:151 green:151 blue:151 alpha:100];
            aboutExpertiseLabel.text = self.information.aboutExpertise;
            aboutExpertiseLabel.numberOfLines = 0;
            [aboutExpertiseLabel sizeToFit];
            //            aboutExpertiseLabel.backgroundColor = [UIColor blueColor];
            [aboutInformationView addSubview:aboutExpertiseLabel];
            currentY = CGRectGetMaxY(aboutExpertiseLabel.frame);
            currentY += sectionY;
        }
        
        if (self.information.aboutPassion.length) {
            UILabel *aboutPassionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingX, currentY, aboutView.bounds.size.width - 2 * paddingX, 15)];
            aboutPassionTitleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:13.0];
            aboutPassionTitleLabel.textColor = [self UIColorFromRGB:248 green:150 blue:128 alpha:100];
            aboutPassionTitleLabel.text = @"最近熱衷的事物";
            [aboutInformationView addSubview:aboutPassionTitleLabel];
            currentY = CGRectGetMaxY(aboutPassionTitleLabel.frame);
            currentY += paddingY;
            UILabel *aboutPassionLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingX, currentY, aboutView.bounds.size.width - 2 * paddingX, 15)];
            
            aboutPassionLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:15.0];
            aboutPassionLabel.textColor = [self UIColorFromRGB:151 green:151 blue:151 alpha:100];
            aboutPassionLabel.numberOfLines = 0;
            aboutPassionLabel.text = self.information.aboutPassion;
            [aboutPassionLabel sizeToFit];
            [aboutInformationView addSubview:aboutPassionLabel];
            currentY = CGRectGetMaxY(aboutPassionLabel.frame);
            currentY += sectionY;
        }
        
        if (self.information.aboutConversation.length) {
            UILabel *aboutConversationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingX, currentY, aboutView.bounds.size.width - 2 * paddingX, 15)];
            aboutConversationTitleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:13.0];
            aboutConversationTitleLabel.textColor = [self UIColorFromRGB:248 green:150 blue:128 alpha:100];
            aboutConversationTitleLabel.text = @"想聊的話題";
            [aboutInformationView addSubview:aboutConversationTitleLabel];
            currentY = CGRectGetMaxY(aboutConversationTitleLabel.frame);
            currentY += paddingY;
            UILabel *aboutConversationLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingX, currentY, aboutView.bounds.size.width - 2 * paddingX, 15)];
            
            aboutConversationLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:15.0];
            aboutConversationLabel.textColor = [self UIColorFromRGB:151 green:151 blue:151 alpha:100];
            aboutConversationLabel.text = self.information.aboutConversation;
            aboutConversationLabel.numberOfLines = 0;
            [aboutConversationLabel sizeToFit];
            [aboutInformationView addSubview:aboutConversationLabel];
            currentY = CGRectGetMaxY(aboutConversationLabel.frame);
            currentY += sectionY;
        }
    } else {
        UIImageView *showNoneInfotmationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonalInformationNone"]];
        
        showNoneInfotmationImageView.center = CGPointMake(aboutInformationView.bounds.size.width / 2, aboutInformationView.bounds.size.height / 2);
        [aboutInformationView addSubview:showNoneInfotmationImageView];
        
        UILabel *noneInformationLabel = [[UILabel alloc] initWithFrame:CGRectMake(showNoneInfotmationImageView.center.x - 60, CGRectGetMaxY(showNoneInfotmationImageView.frame) + 5, 120, 15)];
        
        noneInformationLabel.text = @"神秘的他沒留下簡介";
        noneInformationLabel.textColor = [self UIColorFromRGB:151 green:151 blue:151 alpha:100];
        noneInformationLabel.textAlignment = NSTextAlignmentCenter;
        noneInformationLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:11.0];
        [aboutInformationView addSubview:noneInformationLabel];
        
        currentY = aboutInformationView.bounds.size.height;
    }
    
    aboutInformationView.frame = CGRectMake(marginX, CGRectGetMaxY(aboutView.frame) + marginY, aboutView.bounds.size.width, currentY);
    currentY += marginY;
    self.scrollView.contentSize = CGSizeMake(10, CGRectGetMaxY(aboutInformationView.frame) + marginY);
}

#pragma mark - Hello Action
- (void)helloAction {
    
    // 檢查使用者
    [ColorgyChatAPI checkUserAvailability:^(ChatUser *chatUser) {
        
        // 檢查是否回答最新問題
        [ColorgyChatAPI checkAnsweredLatestQuestion:chatUser.userId success:^(BOOL answered) {
            if (answered) {
                
                // 已回答
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"打招呼" message:@"簡單地跟對方問候ㄧ下吧～" preferredStyle:UIAlertControllerStyleAlert];
                
                [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                }];
                
                [alertView addAction:[UIAlertAction actionWithTitle:@"離開" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }]];
                
                [alertView addAction:[UIAlertAction actionWithTitle:@"發送" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    
                    // say hi
                    [ColorgyChatAPI sayHi:chatUser.userId targetId:self.information.id message:alertView.textFields.firstObject.text success:^() {
                        [self.helloButton setTitle:@"已打招呼" forState:UIControlStateNormal];
                        [self.helloButton removeTarget:self action:@selector(helloAction) forControlEvents:UIControlEventTouchUpInside];
                        loadingView = [[LoadingView alloc] initJustFinished];
                        [loadingView justFinished];
                    } failure:^() {
                        [loadingView dismiss:NULL];
                        NSLog(@"打招呼失敗");
                    }];
                    
                    // Cheack hi 檢查對方說hi了嗎？
                    [ColorgyChatAPI getHiList:chatUser.userId success:^(NSArray *hellos) {
                        for (Hello *hello in hellos) {
                            NSLog(@"\nhello.userId: %@\nchatUser.userId: %@\nhello.targertId: %@\n, informationId: %@", hello.userId, chatUser.userId, hello.targetId, self.information.id);
                            
                            // 逐條檢查hi list
                            if ([hello.targetId isEqualToString:chatUser.userId] && [hello.userId isEqualToString:self.information.id]) {
                                
                                // 接受hi
                                [ColorgyChatAPI acceptHiWithHistoryChatroomId:chatUser.userId hiId:hello.id success:^(NSString *chatroomId) {
                                    
                                    // 對方說了，提醒，並打開聊天
                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"恭喜你們呼像打招呼啦！" message:@"趕快開始跟對方聊天吧！" preferredStyle:UIAlertControllerStyleAlert];
                                    
                                    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                    }]];
                                    
                                    [alertController addAction:[UIAlertAction actionWithTitle:@"前往聊天" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                                        [ColorgyChatAPI getHistoryTarget:chatUser.userId complete:^(NSArray *chatrooms) {
                                            for (HistoryChatroom *chatroom in chatrooms) {
                                                if ([chatroom.chatroomId isEqualToString:chatroomId]) {
                                                    // 跳轉
                                                    ChatRoomViewController *vc = [[ChatRoomViewController alloc] init];
                                                    
                                                    vc.userId = chatUser.userId;
                                                    vc.uuid = [UserSetting UserUUID];
                                                    vc.accessToken = [UserSetting UserAccessToken];
                                                    vc.historyChatroom = chatroom;
                                                    vc.chatroomId = chatroomId;
                                                    
                                                    hidenTabbar = NO;
                                                    
                                                    [self.navigationController pushViewController:vc animated:YES];
                                                    
                                                    break;
                                                }
                                            }
                                        }];
                                    }]];
                                    [self presentViewController:alertController animated:YES completion:nil];
                                } failure:^() {
                                    NSLog(@"acceptHiWithChatroomId error");
                                }];
                                break;
                            }
                        }
                    } failure:^() {
                        NSLog(@"get hi list failure");
                    }];
                }]];
                
                [self presentViewController:alertView animated:YES completion:nil];
            } else {
                
                // 尚未回答
                NSLog(@"尚未回答");
                // 取得清晰問
                [ColorgyChatAPI getQuestion:^(NSString *date, NSString *question) {
                    self.cleanAskDate = date;
                    self.cleanAskString = question;
                    if (self.cleanAskString && !answered) {
                        if ([self.cleanAskString length]) {
                            [self cleanAskViewLayout];
                        }
                    }
                } failure:^() {
                    NSLog(@"getQuestion error");
                }];
            }
        } failure:^() {
            
            // 檢查使用者失敗
            NSLog(@"檢查是否回答最新問題");
        }];
    } failure:^() {
        NSLog(@"檢查使用者失敗");
        
        // 檢查使用者失敗，可能無此帳號，或是網路出問題
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失敗Q_Q" message:@"請網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

#pragma mark - cleanAskView

#pragma mark - cleanAskView

- (void)cleanAskViewLayout {
    
    //    if (self.cleanAskString) {
    //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"每日清晰問" message:self.cleanAskString preferredStyle:UIAlertControllerStyleAlert];
    //
    //        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];
    //        [alertController addAction:[UIAlertAction actionWithTitle:@"發送" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    //            [ColorgyChatAPI checkUserAvailability:^(ChatUser *chatUser) {
    //                [ColorgyChatAPI answerQuestion:chatUser.userId answer:alertController.textFields.firstObject.text date:self.questionDate success:^() {
    //                } failure:^() {
    //                    NSLog(@"answerQuestion error");
    //                }];
    //            } failure:^() {
    //                NSLog(@"check user error");
    //
    //                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失敗Q_Q" message:@"請網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
    //
    //                [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    //                }]];
    //                [self presentViewController:alertController animated:YES completion:nil];
    //            }];
    //        }]];
    //        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    //        }];
    //
    //        [self presentViewController:alertController animated:YES completion:nil];
    //    }
    
    // currentWindow
    self.currentWindow = [UIApplication sharedApplication].keyWindow;
    // cleanAskMaskView
    self.cleanAskMaskView = [[UIView alloc] initWithFrame:self.currentWindow.bounds];
    self.cleanAskMaskView.backgroundColor = [UIColor blackColor];
    self.cleanAskMaskView.alpha = 0.75;
    [self.currentWindow addSubview:self.cleanAskMaskView];
    // cleanAskAertView
    self.cleanAskAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.currentWindow.bounds.size.width - 100, 216)];
    self.cleanAskAlertView.center = self.currentWindow.center;
    self.cleanAskAlertView.layer.cornerRadius = 12.5;
    self.cleanAskAlertView.backgroundColor = [UIColor whiteColor];
    [self.currentWindow addSubview:self.cleanAskAlertView];
    // cleanAskTitleLabel
    self.cleanAskTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.cleanAskAlertView.bounds.size.width - 50, 18)];
    NSAttributedString *attributedCleanAskTitleString = [[NSAttributedString alloc] initWithString:@"每日清晰問" attributes:@{NSForegroundColorAttributeName:[self UIColorFromRGB:0.0 green:0.0 blue:0.0 alpha:100.0], NSFontAttributeName:[UIFont fontWithName:@"STHeitiTC-Medium" size:17.0]}];
    self.cleanAskTitleLabel.attributedText = attributedCleanAskTitleString;
    self.cleanAskTitleLabel.textColor = [self UIColorFromRGB:0.0 green:0.0 blue:0.0 alpha:100.0];
    self.cleanAskTitleLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:17.0];
    self.cleanAskTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.cleanAskTitleLabel.center = CGPointMake(self.cleanAskAlertView.bounds.size.width / 2, 30);
    [self.cleanAskAlertView addSubview:self.cleanAskTitleLabel];
    // cleanAskMessageLabel
    self.cleanAskMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.cleanAskAlertView.bounds.size.width - 30, 17)];
    self.cleanAskMessageLabel.center = CGPointMake(self.cleanAskAlertView.bounds.size.width / 2, self.cleanAskTitleLabel.center.y + 35);
    self.cleanAskMessageLabel.numberOfLines = 0;
    self.cleanAskMessageLabel.textAlignment = NSTextAlignmentCenter;
    NSAttributedString *attributedCleanAskMessageString;
    if (self.cleanAskString) {
        attributedCleanAskMessageString = [[NSAttributedString alloc] initWithString:self.cleanAskString attributes:@{NSForegroundColorAttributeName:[self UIColorFromRGB:151.0 green:151.0 blue:151.0 alpha:100.0], NSFontAttributeName:[UIFont fontWithName:@"STHeitiTC-Light" size:14.0]}];
    }
    
    self.cleanAskMessageLabel.attributedText = attributedCleanAskMessageString;
    [self.cleanAskAlertView addSubview:self.cleanAskMessageLabel];
    // cleanAskTextView
    self.cleanAskTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.cleanAskAlertView.frame.size.width - 60, 62)];
    self.cleanAskTextView.center = CGPointMake(self.cleanAskAlertView.bounds.size.width / 2, CGRectGetMaxY(self.cleanAskMessageLabel.frame) + self.cleanAskTextView.frame.size.height / 2 + 20);
    [self.cleanAskAlertView addSubview:self.cleanAskTextView];
    self.cleanAskTextView.layer.borderWidth = 1;
    self.cleanAskTextView.layer.cornerRadius = 3;
    //    self.cleanAskTextView.textAlignment = NSTextAlignmentCenter;
    self.cleanAskTextView.layer.borderColor = [self UIColorFromRGB:200 green:199 blue:198 alpha:100].CGColor;
    self.cleanAskTextView.delegate = self;
    
    CGSize size;
    if (self.cleanAskString) {
        [self.cleanAskString sizeWithAttributes:@{NSForegroundColorAttributeName:[self UIColorFromRGB:151.0 green:151.0 blue:151.0 alpha:100.0], NSFontAttributeName: [UIFont fontWithName:@"STHeitiTC-Light" size:17.0]}];
        
        if (size.width >= self.cleanAskMessageLabel.frame.size.width) {
            [self.cleanAskMessageLabel sizeToFit];
        }
    }
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.cancelButton.frame = CGRectMake(0, CGRectGetHeight(self.cleanAskAlertView.frame) - 45, self.cleanAskAlertView.frame.size.width / 2, 45);
    self.submitButton.frame = CGRectMake(CGRectGetWidth(self.cleanAskAlertView.frame) / 2, CGRectGetHeight(self.cleanAskAlertView.frame) - 45, self.cleanAskAlertView.frame.size.width / 2, 45);
    //    cancelButton.backgroundColor = [UIColor orangeColor];
    //    submitButton.backgroundColor = [UIColor blueColor];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.submitButton setTitle:@"發送" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[self UIColorFromRGB:151 green:151 blue:151 alpha:100] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[self UIColorFromRGB:248 green:150 blue:128 alpha:100] forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Medium" size:17]];
    [self.submitButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Medium" size:17]];
    
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.cancelButton.bounds byRoundingCorners:(UIRectCornerBottomLeft) cornerRadii:CGSizeMake(12.5, 12.5)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.cancelButton.bounds;
    maskLayer.path = maskPath.CGPath;
    self.cancelButton.layer.mask = maskLayer;
    
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.submitButton.bounds byRoundingCorners:(UIRectCornerBottomRight) cornerRadii:CGSizeMake(12.5, 12.5)];
    
    maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.submitButton.bounds;
    maskLayer.path = maskPath.CGPath;
    self.submitButton.layer.mask = maskLayer;
    
    [self.cleanAskAlertView addSubview:self.cancelButton];
    [self.cleanAskAlertView addSubview:self.submitButton];
    
    [self.cancelButton addTarget:self action:@selector(removeCleanAskViewLayout) forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton addTarget:self action:@selector(answerQuestion) forControlEvents:UIControlEventTouchUpInside];
    
    self.line1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.cancelButton.frame), CGRectGetMinY(self.cancelButton.frame), self.cleanAskAlertView.frame.size.width, 1)];
    [self.line1 setBackgroundColor:[self UIColorFromRGB:139 green:138 blue:138 alpha:100]];
    [self.cleanAskAlertView addSubview:self.line1];
    
    self.line2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.cleanAskAlertView.frame) / 2, CGRectGetMinY(self.cancelButton.frame), 0.5, self.cancelButton.frame.size.height)];
    [self.line2 setBackgroundColor:[self UIColorFromRGB:139 green:138 blue:138 alpha:100]];
    [self.cleanAskAlertView addSubview:self.line2];
    
    // textNumberCunter Customized
    self.textNumberCounterLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.cleanAskTextView.bounds.size.width - 45, self.cleanAskTextView.bounds.size.height - 30, 45, 30)];
    self.textNumberCounterLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:13];
    self.textNumberCounterLabel.textColor = [self UIColorFromRGB:151 green:151 blue:151 alpha:100];
    self.textNumberCounterLabel.text = @"0/20";
    [self.cleanAskTextView addSubview:self.textNumberCounterLabel];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(finishTextView)];
    
    [self.cleanAskMaskView addGestureRecognizer:tapGestureRecognizer];
}

- (void)finishTextView {
    [self.cleanAskTextView resignFirstResponder];
}

- (void)removeCleanAskViewLayout {
    [self.cleanAskView removeFromSuperview];
    [self.cleanAskMaskView removeFromSuperview];
    [self.cleanAskAlertView removeFromSuperview];
    [self.cleanAskTextView removeFromSuperview];
    [self.currentWindow removeFromSuperview];
    [self.cleanAskTitleLabel removeFromSuperview];
    [self.cleanAskMessageLabel removeFromSuperview];
    [self.cancelButton removeFromSuperview];
    [self.submitButton removeFromSuperview];
    [self.line1 removeFromSuperview];
    [self.line2 removeFromSuperview];
    [self.textNumberCounterLabel removeFromSuperview];
}

- (void)answerQuestion {
    [self removeCleanAskViewLayout];
    [ColorgyChatAPI checkUserAvailability:^(ChatUser *chatUser) {
        [ColorgyChatAPI answerQuestion:chatUser.userId answer:self.cleanAskTextView.text date:self.cleanAskDate success:^() {
        } failure:^() {
            NSLog(@"answerQuestion error");
        }];
    } failure:^() {
        NSLog(@"check user error");
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失敗Q_Q" message:@"請網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == self.cleanAskTextView) {
        self.textNumberCounterLabel.text = [NSString stringWithFormat:@"%ld/20", [self stringCounter:textView.text] / 2];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.cleanAskTextView) {
        if (!self.cleanAskTextView.markedTextRange) {
            self.cleanAskTextView.text = [self stringCounterTo:textView.text number:40.0];
            self.textNumberCounterLabel.text = [NSString stringWithFormat:@"%ld/20", [self stringCounter:textView.text] / 2];
        }
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView == self.cleanAskTextView) {
        self.cleanAskTextView.text = [self stringCounterTo:textView.text number:40.0];
    }
    
    return YES;
}

#pragma mark - StringCounter

- (NSInteger)stringCounter:(NSString *)string {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5);
    NSData *data = [string dataUsingEncoding:enc];
    
    NSLog(@"length:%lu", (unsigned long)string.length);
    NSLog(@"counter:%lu", [data length] / 2);
    return [data length];
}

- (NSString *)stringCounterTo:(NSString *)string number:(CGFloat)number {
    NSString *tempString;
    
    for (NSInteger i = 0; i < string.length; ++i) {
        tempString = [string substringToIndex:string.length - i];
        
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5);
        NSData *data = [tempString dataUsingEncoding:enc];
        
        if ([data length] <= number) {
            break;
        }
    }
    return tempString;
}

#pragma mark - UIColor

- (UIColor *)UIColorFromRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:(alpha / 100)];
}

@end
