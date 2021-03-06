//
//  OpeningViewController.m
//  Colorgy
//
//  Created by 張子晏 on 2016/1/16.
//  Copyright © 2016年 張子晏. All rights reserved.
//
// 核心概念：動態元件的加入與刪除，達成面對不同user status各自狀態。
// 點選開始註冊按鈕後，檢查使用者狀態並對應產生畫面，並可以透過refreshView
// 切換回的一張畫面
// 由六張畫面組成Opening, Check Email, Upload, Upload Preview, Name, CleanAsk

#import "OpeningViewController.h"
#import "UIImage+GaussianBlurUIImage.h"
#import "NSString+Email.h"
#import "ColorgyCourse-Swift.h"
#import "ColorgyChatAPIOC.h"
#import "BlurWallSwitchViewController.h"
#import "UselessView.h"
#import "Flurry.h"

#define DEBUG_TAG() printf("debug+ [%s], line=%d, func=%s\n", __FILE__, __LINE__, __func__)

@implementation OpeningViewController {
    UselessView *uselessView; // 藍色標籤條
}

// 重置註冊畫面
- (void)refreshView {
    [self removeOpeningLayout];
    [self removeCheckEmailLayout];
    [self removeCleanAskLayout];
    [self removeUploadLayout];
    [self removeUploadPreviewLayout];
    [self removeNameLayout];
    [self openingLayout];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:YES];
    
    self.chatApiOC = [[ColorgyChatAPIOC alloc] init];
    
    // nameScrollView Customized
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.contentSize = self.view.bounds.size;
    self.scrollView.backgroundColor = [self UIColorFromRGB:250.0 green:247.0 blue:245.0 alpha:100.0];
    
    // View Customized
    self.view.backgroundColor = [self UIColorFromRGB:250.0 green:247.0 blue:245.0 alpha:100.0];
    
    // Layout
    [self openingLayout];
    // 測試用
    // [self checkEmailLayout];
    // [self uploadLayout];
    // [self uploadPreviewLayout];
    // [self nameLayout];
    // [self cleanAskLayout];
    
    // 註冊文字變動推播
    [self registerForUITextFieldTextDidChangeNotification];
    
    // keyboard and tapGesture
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchViewToReturn)];
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self.scrollView addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
}

#pragma mark - UIColor

- (UIColor *)UIColorFromRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:(alpha / 100)];
}

#pragma mark - StringCounter

// 計算一段string的長度中文為2英文為1
- (NSInteger)stringCounter:(NSString *)string {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5);
    NSData *data = [string dataUsingEncoding:enc];
    
    NSLog(@"length:%lu", (unsigned long)string.length);
    NSLog(@"counter:%lu", [data length] / 2);
    return [data length];
}

// 切字串到目標數量
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

#pragma mark - TouchViewToReturn

// 對畫面點擊後的反應
- (void)touchViewToReturn {
    [self.activeTextField resignFirstResponder];
    [self.activeTextView resignFirstResponder];
}

#pragma mark - KeyboardNotifications

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
// 如果要輸入的位置被鍵盤遮到，會滑動到可視範圍
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + statusBarSize.height, 0.0);
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.bounds;
    
    aRect.size.height -= kbSize.height;
    aRect.size.height -= statusBarSize.height;
    
    NSLog(@"%f", ([UIApplication sharedApplication].statusBarFrame.size.height));
    
    if (CGRectGetMaxY(self.activeTextField.frame) > CGRectGetMaxY(self.activeTextView.frame)) {
        if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, self.activeTextField.frame.origin.y - kbSize.height - statusBarSize.height);
            [self.scrollView setContentOffset:scrollPoint animated:YES];
        }
    } else {
        if (!CGRectContainsPoint(aRect, self.activeTextView.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, CGRectGetMaxY(self.activeTextView.frame) - kbSize.height + 40 - statusBarSize.height);
            [self.scrollView setContentOffset:scrollPoint animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
// 鍵盤藏起，恢復上一動ＸＤ
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - OpeningLayout

- (void)openingLayout {
    
    [self removeOpeningLayout];
    [self removeCheckEmailLayout];
    [self removeCleanAskLayout];
    [self removeUploadLayout];
    [self removeUploadPreviewLayout];
    [self removeNameLayout];
    
    // WelcomeChatIconImageView Cusomized
    self.welcomeChatIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WelcomeChatIcon"]];
    self.welcomeChatIconImageView.frame = CGRectMake(100, 100, 131, 127);
    self.welcomeChatIconImageView.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
    
    [self.view addSubview:self.welcomeChatIconImageView];
    
    // Label Welcome Customized
    NSAttributedString *attributedWelcomeString = [[NSAttributedString alloc] initWithString:@"歡迎光臨模糊聊" attributes:@{NSForegroundColorAttributeName:[self UIColorFromRGB:74.0 green:74.0 blue:74.0 alpha:100.0], NSFontAttributeName:[UIFont fontWithName:@"STHeitiTC-Light" size:24.0]}];
    
    self.welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 254, 315, 25)];
    self.welcomeLabel.attributedText = attributedWelcomeString;
    self.welcomeLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeLabel.center = CGPointMake(self.view.center.x, self.welcomeChatIconImageView.center.y + 100);
    
    [self.view addSubview:self.welcomeLabel];
    
    // Label Description Customized
    NSAttributedString *attributedWelcomeDescriptionString = [[NSAttributedString alloc] initWithString:@"別管長怎樣，就讓我們盡情聊天" attributes:@{NSForegroundColorAttributeName:[self UIColorFromRGB:74.0 green:74.0 blue:74.0 alpha:100.0], NSFontAttributeName: [UIFont fontWithName:@"STHeitiTC-Light" size:14.0]}];
    
    self.welcomeDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 391, 247, 13)];
    self.welcomeDescriptionLabel.attributedText = attributedWelcomeDescriptionString;
    self.welcomeDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeDescriptionLabel.center = CGPointMake(self.view.center.x, self.welcomeLabel.center.y + 30);
    
    [self.view addSubview:self.welcomeDescriptionLabel];
    
    
    // CheckEmailButton Customized
    self.startCheckEmailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startCheckEmailButton.frame = CGRectMake(141, 440, 120, 41);
    self.startCheckEmailButton.backgroundColor = [UIColor clearColor];
    self.startCheckEmailButton.layer.borderColor = [self UIColorFromRGB:248 green:150 blue:128 alpha:100].CGColor;
    self.startCheckEmailButton.layer.borderWidth = 2.5;
    self.startCheckEmailButton.layer.cornerRadius = 2.5;
    self.startCheckEmailButton.center = CGPointMake(self.view.center.x, self.welcomeDescriptionLabel.center.y + 50);
    
    [self.startCheckEmailButton setTitle:@"開始認證" forState:UIControlStateNormal];
    [self.startCheckEmailButton setTitleColor:[self UIColorFromRGB:248 green:150 blue:128 alpha:100] forState:UIControlStateNormal];
    [self.startCheckEmailButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:20.0]];
    [self.startCheckEmailButton addTarget:self action:@selector(startOpening) forControlEvents:UIControlEventTouchUpInside]; // 按下開始認證後的反應
    
    [self.view addSubview:self.startCheckEmailButton];
}

// 移除畫面
- (void)removeOpeningLayout {
    [self.welcomeChatIconImageView removeFromSuperview];
    [self.startCheckEmailButton removeFromSuperview];
    [self.uploadPhotoButton removeFromSuperview];
    [self.welcomeLabel removeFromSuperview];
    [self.welcomeDescriptionLabel removeFromSuperview];
}

#pragma mark - StartOpening

// 分為0~3種狀態，
// 0代表沒註冊信箱，啟動輸入信箱畫面
// 1已註冊信箱，啟動上傳照片畫面
// 2已上傳照面，啟動名字確認畫面
// 3清晰問畫面
- (void)startOpening {
    self.navigationItem.hidesBackButton = YES;
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:YES];

	[Flurry logEvent:@"v3.0 Chat: User Clicked Start Auth Flow"];
    
    [ColorgyChatAPI checkUserAvailability:^(ChatUser *chatUser) {
        switch (chatUser.status.integerValue) {
            case 0:
                [self showCheckEmailAlert];
                break;
            case 1:
                [self uploadLayout];
                break;
            case 2:
                [self nameLayout];
                break;
            case 3:
                [self cleanAskLayout];
                break;
            default:
                [self openingLayout];
                break;
        }
    } failure:^() {
        NSLog(@"checkUserAvaliability error");
        DEBUG_TAG();
        
        // 提醒彈出視窗
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失敗Q_Q" message:@"請檢查網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }];
}

#pragma mark - CheckEmailButtonAction

// 秀出Alert並輸入視窗並發送信件
- (void)showCheckEmailAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"認證學校信箱" message:@"發送後趕快去收信吧～" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        // 取得Email提示，沒有的話用基本的
        [ColorgyChatAPI GetEmailHints:[UserSetting UserPossibleOrganization] success:^(NSString *response) {
            NSLog(@"%@", response);
            textField.placeholder = response;
        } failure:^() {
            NSLog(@"email hints error use default");
            DEBUG_TAG();
            
            textField.placeholder = @"school_id@school.edu";
        }];
        self.activeTextField = textField;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"發送" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSString *emailString = alertController.textFields.firstObject.text;
        
        // NSString+Email檢查email格式的方法
        if ([emailString isEmail]) {
            self.activeTextField = nil;
            self.loadingView = [[LoadingView alloc] init];
            self.loadingView.loadingString = @"發送中";
            self.loadingView.finishedString = @"發送成功";
            [self.loadingView start];
            self.loadingView.maskView.backgroundColor = [UIColor blackColor];
            self.loadingView.maskView.alpha = 0.75;
            
            // 發送email認證

			[Flurry logEvent:@"v3.0 Chat: User Sent An Email, Waiting For Auth"];
            
            [self.chatApiOC postEmail:emailString success:^(NSDictionary *response) {
                [self.loadingView finished:^() {
                    [self checkEmailLayout];
                }];
            } failure:^() {
                NSLog(@"Email post error");
                DEBUG_TAG();
                
                [self.loadingView dismiss:nil];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失敗Q_Q" message:@"請檢查學校信箱是否正確" preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失敗Q_Q" message:@"請檢查學校信箱是否正確" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Check Email Layout

// 確認Email完成
- (void)checkEmailLayout {
    [self removeCheckEmailLayout];
    
    // View Customized
    self.view.backgroundColor = [self UIColorFromRGB:250.0 green:247.0 blue:245.0 alpha:100.0];
    
    // mask view
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - 49)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.75;
    
    [self.view addSubview:self.maskView];
    
    // alert view
    self.popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 125, 125)];
    self.popView.center = CGPointMake(self.maskView.center.x, self.maskView.center.y - 50);
    self.popView.layer.cornerRadius = 3.54;
    self.popView.layer.backgroundColor = [self UIColorFromRGB:248 green:150 blue:128 alpha:100].CGColor;
    
    [self.view addSubview:self.popView];
    
    // message label
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.popView.bounds.size.width - 20, 38)];
    self.messageLabel.center = CGPointMake(self.popView.center.x, self.popView.center.y + 30);
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.messageLabel];
    
    // email view
    self.emailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WhiteMail"]];
    self.emailImageView.center = CGPointMake(self.popView.center.x, self.popView.center.y - 15);
    
    [self.view addSubview:self.emailImageView];
    
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
    
    [self.checkEmailButton addTarget:self action:@selector(checkEmail) forControlEvents:UIControlEventTouchUpInside]; // 確認驗證
    
    // manual verification button
    self.manualVerificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.manualVerificationButton.frame = CGRectMake(141, 440, 160, 14);
    [self.manualVerificationButton setTitleColor:[self UIColorFromRGB:250 green:247 blue:245 alpha:100] forState:UIControlStateNormal];
    self.manualVerificationButton.center = CGPointMake(self.maskView.center.x, self.popView.center.y + 160);
    
    [self.manualVerificationButton setTitle:@"還是沒收到？" forState:UIControlStateNormal];
    [self.manualVerificationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.manualVerificationButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:14.0]];
    
    [self.maskView addSubview:self.manualVerificationButton];
    
    [self.manualVerificationButton addTarget:self action:@selector(manualVerification) forControlEvents:UIControlEventTouchUpInside]; // 人工驗證按鈕
}

// 移除畫面
- (void)removeCheckEmailLayout {
    [self.maskView removeFromSuperview];
    [self.messageLabel removeFromSuperview];
    [self.checkEmailButton removeFromSuperview];
    [self.popView removeFromSuperview];
    [self.emailImageView removeFromSuperview];
}

#pragma mark - manual verification {

// 人工驗證，打開瀏覽器
- (void)manualVerification {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"使用人工驗證" message:@"我們將帶領你前往人工驗證的網頁，請依照網頁的指示完成人工驗證的步驟！" preferredStyle:UIAlertControllerStyleAlert];
	NSString *accessToken = [UserSetting UserAccessToken];
	NSString *url = [NSString stringWithFormat:@"%@%@", @"https://colorgy.io/user_manual_validation/sso_new_session?access_token=", accessToken];
    [alertController addAction:[UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if ([[UIApplication sharedApplication] canOpenURL:[[NSURL alloc] initWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:url]];
        } else {
            NSLog(@"open url error");
            DEBUG_TAG();
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - check email

- (void)checkEmail {
    self.loadingView.loadingString = @"驗證中";
    self.loadingView.finishedString = @"認證成功";
    [self removeOpeningLayout];
    [self removeCheckEmailLayout];
    [self removeCleanAskLayout];
    [self removeUploadLayout];
    [self removeUploadPreviewLayout];
    [self removeNameLayout];
    
    [self.loadingView start];
    
    // 認證信箱，透過apime更新me，然後檢查UserOrganization是否有值，作為判斷，並更新使用者現在狀態
    [ColorgyChatAPI ColorgyAPIMe:^() {
        if ([UserSetting UserOrganization]) {
            [ColorgyChatAPI checkUserAvailability:^(ChatUser *chatUser) {
                [ColorgyChatAPI updateUserStatus:chatUser.userId status:@"1" success:^() {
                    NSLog(@"updateUserStatus success");
                } failure:^() {
                    NSLog(@"updateUserStatus error");
                }];
            } failure:^() {
                NSLog(@"checkUserAvailability error");
            }];
            [self.loadingView finished:^() {
                [self removeOpeningLayout];
                [self removeCheckEmailLayout];
                [self uploadLayout];
				
				[Flurry logEvent:@"v3.0 Chat: User Finish Email Auth"];
            }];
        } else {
            [self.loadingView dismiss:nil];
            [self checkEmailLayout];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失敗Q_Q" message:@"尚未認證" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    } failure:^() {
        NSLog(@"APIME error");
        DEBUG_TAG();
        
        [self.loadingView dismiss:nil];
        [self checkEmailLayout];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失敗Q_Q" message:@"請檢查網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

#pragma mark - Upload Layout

// 上傳照片畫面
- (void)uploadLayout {
    [self removeOpeningLayout];
    [self removeCheckEmailLayout];
    [self removeCleanAskLayout];
    [self removeUploadLayout];
    [self removeUploadPreviewLayout];
    [self removeNameLayout];
    
    // userImageView Customized
    self.userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 142, 142)];
    self.userImageView.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
    self.userImageView.backgroundColor = [UIColor whiteColor];
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.borderWidth = 3;
    self.userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImageView.layer.cornerRadius = self.userImageView.bounds.size.width / 2;
    [self.view addSubview:self.userImageView];
    
    // uploadTitleLabel Customized
    NSAttributedString *attributedUploadTitleString = [[NSAttributedString alloc] initWithString:@"展開一段冒險" attributes:@{NSForegroundColorAttributeName:[self UIColorFromRGB:74.0 green:74.0 blue:74.0 alpha:100.0], NSFontAttributeName: [UIFont fontWithName:@"STHeitiTC-Light" size:24.0]}];
    
    self.uploadTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 254, 315, 25)];
    self.uploadTitleLabel.attributedText = attributedUploadTitleString;
    self.uploadTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.uploadTitleLabel.center = CGPointMake(self.view.center.x, self.userImageView.center.y + 100);
    
    [self.view addSubview:self.uploadTitleLabel];
    
    // uploadDescriptionLabel Customized
    NSAttributedString *attributedUploadDescriptionString = [[NSAttributedString alloc] initWithString:@"所有頭貼經過模糊處理，唯有越聊越清晰～" attributes:@{NSForegroundColorAttributeName:[self UIColorFromRGB:74.0 green:74.0 blue:74.0 alpha:100.0], NSFontAttributeName: [UIFont fontWithName:@"STHeitiTC-Light" size:14.0]}];
    
    self.uploadDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 391, 320, 13)];
    self.uploadDescriptionLabel.attributedText = attributedUploadDescriptionString;
    self.uploadDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.uploadDescriptionLabel.center = CGPointMake(self.view.center.x, self.uploadTitleLabel.center.y + 30);
    
    [self.view addSubview:self.uploadDescriptionLabel];
    
    // UploadPhotoButton Customized
    self.uploadPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.uploadPhotoButton.frame = CGRectMake(141, 440, 120, 41);
    self.uploadPhotoButton.backgroundColor = [UIColor clearColor];
    self.uploadPhotoButton.layer.borderColor = [self UIColorFromRGB:248 green:150 blue:128 alpha:100].CGColor;
    self.uploadPhotoButton.layer.borderWidth = 2.5;
    self.uploadPhotoButton.layer.cornerRadius = 2.5;
    self.uploadPhotoButton.center = CGPointMake(self.view.center.x, self.uploadDescriptionLabel.center.y + 50);
    
    [self.uploadPhotoButton setTitle:@"上傳頭貼" forState:UIControlStateNormal];
    [self.uploadPhotoButton setTitleColor:[self UIColorFromRGB:248 green:150 blue:128 alpha:100] forState:UIControlStateNormal];
    [self.uploadPhotoButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:16.0]];
    [self.uploadPhotoButton addTarget:self action:@selector(showPhotoMeunAlert) forControlEvents:UIControlEventTouchUpInside]; // 秀出選擇方法
    
    [self.view addSubview:self.uploadPhotoButton];
	
	[Flurry logEvent:@"v3.0 Chat: User On Upload Photo View"];
}

// 清除畫面
- (void)removeUploadLayout {
    [self.userImageView removeFromSuperview];
    [self.uploadTitleLabel removeFromSuperview];
    [self.uploadDescriptionLabel removeFromSuperview];
    [self.uploadPhotoButton removeFromSuperview];
}

#pragma mark - UploadButtonAction

// ActionSheet 選擇照片方法，fb頭貼，相片選取器，拍照
- (void)showPhotoMeunAlert {
    
    // UIAlertController AnctionSheetStyle Initializing
    UIAlertController *photoMeunAlertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [photoMeunAlertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
    }]];
    
    [photoMeunAlertController addAction:[UIAlertAction actionWithTitle:@"使用FB大頭照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // FBImageSticker button tapped.
        [self removeUploadLayout];
        [self uploadPreviewLayout];
        UIActivityIndicatorView *indView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indView startAnimating];
        indView.center = CGPointMake(self.userImageView.bounds.size.width / 2, self.userImageView.bounds.size.height / 2);
        [self.userImageView addSubview:indView];
        
        // 下載Colorgy庫存照片
        [self downloadImageAtURL:[UserSetting UserAvatarUrl] withHandler:^(UIImage *image) {
            self.uploadImage = image;
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.userImageView.image = [image gaussianBlurImage:image andInputRadius:4];
                [indView removeFromSuperview];
                [self.userImageView setNeedsLayout];
            });
        }];
    }]];
    
    [photoMeunAlertController addAction:[UIAlertAction actionWithTitle:@"從相簿選擇" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // PhotoAlbumr button tapped.
        [self openPhotoLibrary];
    }]];
    
    [photoMeunAlertController addAction:[UIAlertAction actionWithTitle:@"拍攝照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openPhotoCamera];
    }]];
    [self presentViewController:photoMeunAlertController animated:YES completion:nil];
}

// 開起相簿
- (void)openPhotoLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        NSLog(@"open imagepicker error");
        DEBUG_TAG();
        UIAlertController *alertError = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"存取相簿失敗，請去設定給予Colorgy Course存取相簿的權限" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertError addAction:[UIAlertAction actionWithTitle:@"好吧..." style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alertError animated:YES completion:nil];
    }
}

// 開啟相機
- (void)openPhotoCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        NSLog(@"open camera error");
        DEBUG_TAG();
        
        UIAlertController *alertError = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"存取相機失敗" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertError addAction:[UIAlertAction actionWithTitle:@"好吧..." style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        }]];
        [self presentViewController:alertError animated:YES completion:nil];
    }
}

#pragma mark - ImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    self.uploadImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.uploadImage = [self reSizeImage:self.uploadImage toSize:CGSizeMake(512, 512)];
    [self removeUploadLayout];
    [self removeUploadPreviewLayout];
    [self uploadPreviewLayout];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"imagePickerControllerDidCancel");
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - Upload Preview

//上傳預覽畫面
- (void)uploadPreviewLayout {
    [self removeOpeningLayout];
    [self removeCheckEmailLayout];
    [self removeCleanAskLayout];
    [self removeUploadLayout];
    [self removeUploadPreviewLayout];
    [self removeNameLayout];
    
    // userImageView Customized
    self.userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 142, 142)];
    self.userImageView.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
    self.userImageView.backgroundColor = [UIColor whiteColor];
    self.userImageView.image = [self.uploadImage gaussianBlurImage:self.uploadImage andInputRadius:4];
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.borderWidth = 3;
    self.userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImageView.layer.cornerRadius = self.userImageView.bounds.size.width / 2;
    [self.view addSubview:self.userImageView];
    
    // uploadTitleLabel Customized
    NSAttributedString *attributedUploadTitleString = [[NSAttributedString alloc] initWithString:@"真好看" attributes:@{NSForegroundColorAttributeName:[self UIColorFromRGB:74.0 green:74.0 blue:74.0 alpha:100.0], NSFontAttributeName: [UIFont fontWithName:@"STHeitiTC-Light" size:24.0]}];
    
    self.uploadTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 254, 315, 25)];
    self.uploadTitleLabel.attributedText = attributedUploadTitleString;
    self.uploadTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.uploadTitleLabel.center = CGPointMake(self.view.center.x, self.userImageView.center.y + 100);
    
    [self.view addSubview:self.uploadTitleLabel];
    
    // uploadDescriptionLabel Customized
    NSAttributedString *attributedUploadDescriptionString = [[NSAttributedString alloc] initWithString:@"模糊的你有顆美麗的心" attributes:@{NSForegroundColorAttributeName:[self UIColorFromRGB:74.0 green:74.0 blue:74.0 alpha:100.0], NSFontAttributeName: [UIFont fontWithName:@"STHeitiTC-Light" size:14.0]}];
    
    self.uploadDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 391, 320, 13)];
    self.uploadDescriptionLabel.attributedText = attributedUploadDescriptionString;
    self.uploadDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.uploadDescriptionLabel.center = CGPointMake(self.view.center.x, self.uploadTitleLabel.center.y + 30);
    
    [self.view addSubview:self.uploadDescriptionLabel];
    
    // UploadPhotoButton Customized
    self.uploadPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.uploadPhotoButton.frame = CGRectMake(141, 440, 120, 41);
    self.uploadPhotoButton.backgroundColor = [UIColor clearColor];
    self.uploadPhotoButton.layer.borderColor = [self UIColorFromRGB:151 green:151 blue:151 alpha:100].CGColor;
    self.uploadPhotoButton.layer.borderWidth = 2.5;
    self.uploadPhotoButton.layer.cornerRadius = 2.5;
    self.uploadPhotoButton.center = CGPointMake(self.view.center.x - self.uploadPhotoButton.bounds.size.width / 2 - 5, self.uploadDescriptionLabel.center.y + 50);
    
    [self.uploadPhotoButton setTitle:@"重新選取" forState:UIControlStateNormal];
    [self.uploadPhotoButton setTitleColor:[self UIColorFromRGB:151 green:151 blue:151 alpha:100] forState:UIControlStateNormal];
    [self.uploadPhotoButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:16.0]];
    [self.uploadPhotoButton addTarget:self action:@selector(showPhotoMeunAlert) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.uploadPhotoButton];
    
    // UploadSbmitButton Customized
    self.uploadSubmitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.uploadSubmitButton.frame = CGRectMake(141, 440, 120, 41);
    self.uploadSubmitButton.backgroundColor = [UIColor clearColor];
    self.uploadSubmitButton.layer.borderColor = [self UIColorFromRGB:248 green:150 blue:128 alpha:100].CGColor;
    self.uploadSubmitButton.layer.borderWidth = 2.5;
    self.uploadSubmitButton.layer.cornerRadius = 2.5;
    self.uploadSubmitButton.center = CGPointMake(self.view.center.x + self.uploadSubmitButton.bounds.size.width / 2 + 5, self.uploadDescriptionLabel.center.y + 50);
    
    [self.uploadSubmitButton setTitle:@"確認使用" forState:UIControlStateNormal];
    [self.uploadSubmitButton setTitleColor:[self UIColorFromRGB:248 green:150 blue:128 alpha:100] forState:UIControlStateNormal];
    [self.uploadSubmitButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:16.0]];
    [self.uploadSubmitButton addTarget:self action:@selector(uploadingImage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.uploadSubmitButton];
}

- (void)removeUploadPreviewLayout {
    [self.userImageView removeFromSuperview];
    [self.uploadTitleLabel removeFromSuperview];
    [self.uploadDescriptionLabel removeFromSuperview];
    [self.uploadPhotoButton removeFromSuperview];
    [self.uploadSubmitButton removeFromSuperview];
}

#pragma mark - UploadingImage

// 上傳照片，並更新使用者狀態到2
- (void)uploadingImage {
	
	[Flurry logEvent:@"v3.0 Chat: User Upload A New Blur Photo"];
	
    NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"image.png"];
    NSData *data = UIImagePNGRepresentation(self.uploadImage);
    [data writeToFile:path atomically:YES];
    
    NSLog(@"%f, %f", self.uploadImage.size.width, self.uploadImage.size.height);
    
    // clear view
    [self removeUploadPreviewLayout];
    
    self.loadingView = [[LoadingView alloc] init];
    self.loadingView.loadingString = @"上傳中";
    self.loadingView.finishedString = @"成功";
    [self.loadingView start];
    
    // 這裡上傳
    CGRect chopRect = CGRectMake(0, 0, self.uploadImage.size.width, self.uploadImage.size.height);
    
    [self.chatApiOC patchUserImage:self.uploadImage chopRect:chopRect success:^(NSDictionary *response) {
        NSLog(@"%@", [response valueForKey:@"avatar_url"]);
        [ColorgyChatAPI checkUserAvailability:^(ChatUser *chatUser) {
            [ColorgyChatAPI updateUserStatus:chatUser.userId status:@"2" success:^() {
                NSLog(@"updateUserStatus success");
            } failure:^() {
                NSLog(@"updateUserStatus error");
            }];
        } failure:^() {
            NSLog(@"checkUserAvailability error");
        }];
        [self.loadingView finished:^() {
            [self nameLayout];
        }];
    } failure:^() {
        NSLog(@"upload image error");
        DEBUG_TAG();
        
        [self.loadingView dismiss:^() {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"頭貼傳輸失敗Q_Q" message:@"請檢查網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
            [self uploadPreviewLayout];
        }];
    }];
}

#pragma mark - UIImage Resize

// 照片裁切
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize {
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

#pragma mark - NameLayout

// 名字確認畫面
- (void)nameLayout {

	[Flurry logEvent:@"v3.0 Chat: User On Naming Nick Name View"];
	
    [self.tabBarController.tabBar setHidden:YES];
    
    [self removeOpeningLayout];
    [self removeCheckEmailLayout];
    [self removeCleanAskLayout];
    [self removeUploadLayout];
    [self removeUploadPreviewLayout];
    [self removeNameLayout];
    
    self.nameIsOk = NO;
    
    [self.view addSubview:self.scrollView];
    
    // nameDescriptionLabel Customized
    self.nameDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 315, 18)];
    self.nameDescriptionLabel.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
    self.nameDescriptionLabel.backgroundColor = [UIColor clearColor];
    self.nameDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    
    NSAttributedString *attributedNameDescriptionString = [[NSAttributedString alloc] initWithString:@"為自己取ㄧ個閃亮亮的名字吧！" attributes:@{NSForegroundColorAttributeName:[self UIColorFromRGB:74.0 green:74.0 blue:74.0 alpha:100.0], NSFontAttributeName: [UIFont fontWithName:@"STHeitiTC-Light" size:17.0]}];
    
    self.nameDescriptionLabel.attributedText = attributedNameDescriptionString;
    
    
    [self.scrollView addSubview:self.nameDescriptionLabel];
    
    // NameTextField Customized
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 60, 47)];
    self.nameTextField.center = CGPointMake(self.view.center.x, self.nameDescriptionLabel.center.y + 50);
    self.nameTextField.backgroundColor = [UIColor whiteColor];
    self.nameTextField.layer.borderColor = [self UIColorFromRGB:200 green:199 blue:198 alpha:100].CGColor;
    self.nameTextField.layer.borderWidth = 1.0;
    self.nameTextField.layer.cornerRadius = 3.0;
    self.nameTextField.delegate = self;
    self.nameTextField.font = [UIFont fontWithName:@"STHeitiTC-Light" size:15.0];
    self.nameTextField.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    self.nameTextField.placeholder = @"八字以內";
    
    [self.scrollView addSubview:self.nameTextField];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    
    self.nameTextField.leftView = paddingView;
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.checkedView = [[UIView alloc] initWithFrame:CGRectMake(self.nameTextField.frame.size.width - self.nameTextField.frame.size.height, 0, self.nameTextField.frame.size.height, self.nameTextField.frame.size.height)];
    
    self.checkedView.backgroundColor = [UIColor clearColor];
    
    UIImageView *checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckIcon"]];
    
    checkImageView.center = CGPointMake(self.checkedView.frame.size.width / 2, self.checkedView.frame.size.height / 2);
    [self.checkedView addSubview:checkImageView];
    
    // textNumberCounter Customized
    self.textNumberCounterLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameTextField.frame.size.width - 50, 30, 45, 30)];
    self.textNumberCounterLabel.center = CGPointMake(self.nameTextField.frame.size.width - 50 / 2, self.nameTextField.frame.size.height / 2);
    self.textNumberCounterLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:13];
    self.textNumberCounterLabel.textColor = [self UIColorFromRGB:151 green:151 blue:151 alpha:100];
    self.textNumberCounterLabel.text = @"0/8";
    
    [self.nameTextField addSubview:self.textNumberCounterLabel];
    
    // SubmitNameButtom Customized
    self.submitNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitNameButton.frame = CGRectMake(141, 440, 120, 41);
    self.submitNameButton.backgroundColor = [UIColor clearColor];
    self.submitNameButton.layer.borderColor = [self UIColorFromRGB:248 green:150 blue:128 alpha:100].CGColor;
    self.submitNameButton.layer.borderWidth = 2.5;
    self.submitNameButton.layer.cornerRadius = 2.5;
    self.submitNameButton.center = CGPointMake(self.view.center.x, self.nameTextField.center.y + 80);
    
    [self.scrollView addSubview:self.submitNameButton];
    
    // SubmitNameButtom Customized
    [self.submitNameButton setTitle:@"下一題" forState:UIControlStateNormal];
    [self.submitNameButton setTitleColor:[self UIColorFromRGB:248 green:150 blue:128 alpha:100] forState:UIControlStateNormal];
    [self.submitNameButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:20.0]];
    [self.submitNameButton addTarget:self action:@selector(submitName) forControlEvents:UIControlEventTouchUpInside];
    
    // ProgressImageView1 Customized
    self.progressBarView1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 76, self.view.bounds.size.width, 76)];
    self.progressBarView1.backgroundColor = [UIColor whiteColor];
    
    UIImageView *progressBarImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ProgressBar1"]];
    
    progressBarImageView1.center = CGPointMake(self.progressBarView1.frame.size.width / 2, self.progressBarView1.frame.size.height / 2);
    self.progressBarView1.backgroundColor = [UIColor whiteColor];
    [self.progressBarView1 addSubview:progressBarImageView1];
    [self.view addSubview:self.progressBarView1];
}

// 移除畫面
- (void)removeNameLayout {
    [self.nameDescriptionLabel removeFromSuperview];
    [self.nameTextField removeFromSuperview];
    [self.submitNameButton removeFromSuperview];
    [self.scrollView removeFromSuperview];
    [self.progressBarView1 removeFromSuperview];
}

#pragma mark - CheckView

// 檢查名子的轉圈圈
- (void)showChecking {
    self.checkingView = [[UIActivityIndicatorView alloc] initWithFrame:self.checkedView.frame];
    
    [self.checkingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.checkingView startAnimating];
    [self.textNumberCounterLabel removeFromSuperview];
    [self.checkedView removeFromSuperview];
    [self.nameTextField addSubview:self.checkingView];
    self.nameIsOk = YES;
}

// 確認可用的勾勾
- (void)showCheck {
    [self.checkingView removeFromSuperview];
    [self.textNumberCounterLabel removeFromSuperview];
    [self.nameTextField addSubview:self.checkedView];
    self.nameIsOk = YES;
}

// 移除檢查
- (void)dismissCheck {
    [self.checkingView removeFromSuperview];
    [self.checkedView removeFromSuperview];
    [self.nameTextField addSubview:self.textNumberCounterLabel];
    self.nameIsOk = NO;
}

#pragma mark - submitName

// 確認名字，並更新狀態到3
- (void)submitName {

	[Flurry logEvent:@"v3.0 Chat: User Submit A Nick Name"];
	
    // 檢查名字
    
    if (self.nameIsOk) {
        // 上傳名字
        [ColorgyChatAPI checkUserAvailability:^(ChatUser *user) {
            [ColorgyChatAPI updateName:self.nameTextField.text userId:user.userId success:^() {
                [ColorgyChatAPI checkUserAvailability:^(ChatUser *chatUser) {
                    [ColorgyChatAPI updateUserStatus:chatUser.userId status:@"3" success:^() {
                        NSLog(@"updateUserStatus success");
                    } failure:^() {
                        DEBUG_TAG();
                        NSLog(@"updateUserStatus error");
                    }];
                } failure:^() {
                    DEBUG_TAG();
                    NSLog(@"checkUserAvailability error");
                }];
                // CleanAskLayout
                [self removeNameLayout];
                [self cleanAskLayout];
            } failure:^() {
                DEBUG_TAG();
                NSLog(@"update name error");
            }];
            [ColorgyChatAPI updateFromCore:^() {} failure:^() {
                DEBUG_TAG();
                NSLog(@"update core error");
            }];
        } failure:^() {
            NSLog(@"check user error");
            DEBUG_TAG();
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失敗Q_Q" message:@"請網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    } else {
        [self showChecking];
        [ColorgyChatAPI checkNameExists:self.nameTextField.text success:^(NSString *status) {
            if ([status isEqualToString:@"ok"]) {
                [self showCheck];
                if (self.nameIsOk) {
                    // 上傳名字
                    [ColorgyChatAPI checkUserAvailability:^(ChatUser *user) {
                        [ColorgyChatAPI updateName:self.nameTextField.text userId:user.userId success:^() {
                            [ColorgyChatAPI checkUserAvailability:^(ChatUser *chatUser) {
                                [ColorgyChatAPI updateUserStatus:chatUser.userId status:@"3" success:^() {
                                    NSLog(@"updateUserStatus success");
                                } failure:^() {
                                    NSLog(@"updateUserStatus error");
                                }];
                            } failure:^() {
                                NSLog(@"checkUserAvailability error");
                            }];
                            // CleanAskLayout
                            [self removeNameLayout];
                            [self cleanAskLayout];
                        } failure:^() {
                            NSLog(@"update name error");
                        }];
                        [ColorgyChatAPI updateFromCore:^() {} failure:^() {
                            NSLog(@"update core error");
                        }];
                    } failure:^() {
                        NSLog(@"check user error");
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失敗Q_Q" message:@"請網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
                        
                        [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                        }]];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }];
                }
            } else {
                [self dismissCheck];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"名字無法使用" message:@"請想個新的吧！！" preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
        } failure:^() {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"傳輸失敗Q_Q" message:@"請檢查網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }
}

#pragma mark - UITextFieldDelegate

// 檢查名字長度
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
    
    [self dismissCheck];
    
    if (textField == self.nameTextField) {
        self.textNumberCounterLabel.text = [NSString stringWithFormat:@"%ld/8", [self stringCounter:self.nameTextField.text] / 2];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.activeTextField = nil;
    
    if (textField == self.nameTextField) {
        [self dismissCheck];
        self.nameTextField.text = [self stringCounterTo:self.nameTextField.text number:16];
        
        // 檢查名字 尚需修改
        if (self.nameTextField.text.length) {
            [self showChecking];
            [ColorgyChatAPI checkNameExists:self.nameTextField.text success:^(NSString *status) {
                if ([status isEqualToString:@"ok"]) {
                    [self showCheck];
                } else {
                    [self dismissCheck];
                }
            } failure:^() {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"傳輸失敗Q_Q" message:@"請檢查網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
        }
    }
    return YES;
}

// 裁切名字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.nameTextField) {
        if (!string.length || textField.markedTextRange) {
            return YES;
        }
        
        NSString *tempString  = self.nameTextField.text;
        NSString *checkString;
        
        tempString = [tempString stringByAppendingString:string];
        checkString = [[NSString alloc] initWithString:tempString];
        
        tempString = [self stringCounterTo:tempString number:16];
        if (checkString.length != tempString.length) {
            
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - UITextFieldTextDidChangeNotification

- (void)registerForUITextFieldTextDidChangeNotification {
    
    // UITextFieldTextDidChangeNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:)name:@"UITextFieldTextDidChangeNotification" object:nil];
}

// 檢查名字並裁切
- (void)textChange:(NSNotification *)noti {
    if (self.nameTextField.markedTextRange) {
        return;
    }
    if (self.activeTextField == self.nameTextField) {
        NSString *string = self.nameTextField.text;
        
        if ([self stringCounter:string] > 10) {
            self.nameTextField.text = [self stringCounterTo:string number:16];
        }
        self.textNumberCounterLabel.text = [NSString stringWithFormat:@"%ld/8", [self stringCounter:self.nameTextField.text] / 2];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - CleanAskLayout

// 清晰問畫面
- (void)cleanAskLayout {

	[Flurry logEvent:@"v3.0 Chat: User First Time On Answered Everyday Question"];
	
    [self removeOpeningLayout];
    [self removeCheckEmailLayout];
    [self removeCleanAskLayout];
    [self removeUploadLayout];
    [self removeUploadPreviewLayout];
    [self removeNameLayout];
    
    [ColorgyChatAPI getQuestion:^(NSString *date, NSString *question) {
        self.questionString = question;
        self.cleanAskQuestionLabel.text = self.questionString;
        self.questionDate = date;
        
        CGSize size = [self.questionString sizeWithAttributes:@{NSForegroundColorAttributeName:[self UIColorFromRGB:151.0 green:151.0 blue:151.0 alpha:100.0], NSFontAttributeName: [UIFont fontWithName:@"STHeitiTC-Light" size:17.0]}];
        
        if (size.width >= self.cleanAskQuestionLabel.frame.size.width) {
            [self.cleanAskQuestionLabel sizeToFit];
        }
    } failure:^() {
        NSLog(@"get question error");
        DEBUG_TAG();
    }];
    
    [self.view addSubview:self.scrollView];
    [self.tabBarController.tabBar setHidden:YES];
    
    // CleanSakQuestionLabel Customized
    self.cleanAskQuestionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 60, 18)];
    self.cleanAskQuestionLabel.center = CGPointMake(self.view.center.x, self.view.center.y - 120);
    self.cleanAskQuestionLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17.0];
    self.cleanAskQuestionLabel.textColor = [self UIColorFromRGB:151 green:151 blue:151 alpha:100];
    self.cleanAskQuestionLabel.textAlignment = NSTextAlignmentCenter;
    self.cleanAskQuestionLabel.numberOfLines = 0;
    
    [self.scrollView addSubview:self.cleanAskQuestionLabel];
    
    // cleanAskReplyTextView Customized
    self.cleanAskReplyTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 60 , 73)];
    self.cleanAskReplyTextView.backgroundColor = [self UIColorFromRGB:255 green:255 blue:255 alpha:100];
    self.cleanAskReplyTextView.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16];
    self.cleanAskReplyTextView.layer.borderColor = [self UIColorFromRGB:200 green:199 blue:198 alpha:100].CGColor;
    self.cleanAskReplyTextView.layer.borderWidth = 1.0;
    self.cleanAskReplyTextView.layer.cornerRadius = 3.0;
    self.cleanAskReplyTextView.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.cleanAskQuestionLabel.frame) + 60);
    self.cleanAskReplyTextView.textContainer.maximumNumberOfLines = 2;
    self.cleanAskReplyTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    self.cleanAskReplyTextView.textContainer.lineFragmentPadding = 10;
    self.cleanAskReplyTextView.delegate = self;
    
    [self.scrollView addSubview:self.cleanAskReplyTextView];
    
    // textNumberCunter Customized
    self.textNumberCounterLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.cleanAskReplyTextView.bounds.size.width - 45, self.cleanAskReplyTextView.bounds.size.height - 30, 45, 30)];
    self.textNumberCounterLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:13];
    self.textNumberCounterLabel.textColor = [self UIColorFromRGB:151 green:151 blue:151 alpha:100];
    self.textNumberCounterLabel.text = @"0/20";
    
    [self.cleanAskReplyTextView addSubview:self.textNumberCounterLabel];
    
    // openChatButton Customized
    self.openChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openChatButton.frame = CGRectMake(141, 440, 120, 41);
    self.openChatButton.backgroundColor = [UIColor clearColor];
    self.openChatButton.layer.borderColor = [self UIColorFromRGB:248 green:150 blue:128 alpha:100].CGColor;
    self.openChatButton.layer.borderWidth = 2.5;
    self.openChatButton.layer.cornerRadius = 2.5;
    self.openChatButton.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.cleanAskReplyTextView.frame) + 50);
    
    [self.openChatButton setTitle:@"開始聊" forState:UIControlStateNormal];
    [self.openChatButton setTitleColor:[self UIColorFromRGB:248 green:150 blue:128 alpha:100] forState:UIControlStateNormal];
    [self.openChatButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:20.0]];
    [self.openChatButton addTarget:self action:@selector(openChatButtonAcion) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.openChatButton];
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(self.openChatButton.frame) + CGRectGetMaxY(self.cleanAskTitleLabel.frame));
    
    // ProgressImageView2 Customized
    
    self.progressBarView2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 76, self.view.bounds.size.width, 76)];
    self.progressBarView2.backgroundColor = [UIColor whiteColor];
    
    UIImageView *progressBarImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ProgressBar2"]];
    
    progressBarImageView2.center = CGPointMake(self.progressBarView2.frame.size.width / 2, self.progressBarView2.frame.size.height / 2);
    self.progressBarView2.backgroundColor = [UIColor whiteColor];
    [self.progressBarView2 addSubview:progressBarImageView2];
    [self.view addSubview:self.progressBarView2];
    
    NSLog(@"%f", CGRectGetMinY(self.progressBarView2.frame));
    
    uselessView = [[UselessView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, CGRectGetMinY(self.progressBarView2.frame) - 50, self.view.bounds.size.width, 50) withMessage:@"每日清晰問：從你的回答，讓大家更了解你！"];
    
    [self.view addSubview:uselessView];
}

// 畫面清除
- (void)removeCleanAskLayout {
    [self.cleanAskQuestionLabel removeFromSuperview];
    [self.cleanAskReplyTextView removeFromSuperview];
    [self.scrollView removeFromSuperview];
    [self.openChatButton removeFromSuperview];
    [self.textNumberCounterLabel removeFromSuperview];
    [self.cleanAskTitleLabel removeFromSuperview];
    [self.progressBarView2 removeFromSuperview];
    [uselessView removeFromSuperview];
}

#pragma mark - openChatButtonAction

// 開始聊，更新狀態到4，透過BlurWallSwitchView的switch方法切換
- (void)openChatButtonAcion {
    if (self.cleanAskReplyTextView.text.length) {

		[Flurry logEvent:@"v3.0 Chat: User Answered Everyday Question"];
		
        [ColorgyChatAPI checkUserAvailability:^(ChatUser *chatUser) {
            [ColorgyChatAPI answerQuestion:chatUser.userId answer:self.cleanAskReplyTextView.text date:self.questionDate success:^() {
                [ColorgyChatAPI checkUserAvailability:^(ChatUser *chatUser) {
                    [ColorgyChatAPI updateUserStatus:chatUser.userId status:@"4" success:^() {
                        NSLog(@"updateUserStatus success");
                        // 開啟模糊牆
                        [self removeCleanAskLayout];
                        [self.view removeFromSuperview];
                        [self.navigationController.navigationBar setHidden:YES];
                        [self.tabBarController.tabBar setHidden:NO];
                        [(BlurWallSwitchViewController *)self.parentViewController switchViewController];
                    } failure:^() {
                        NSLog(@"updateUserStatus error");
                        // 開啟模糊牆
                        [self removeCleanAskLayout];
                        [self.view removeFromSuperview];
                        [self.navigationController.navigationBar setHidden:YES];
                        [self.tabBarController.tabBar setHidden:NO];
                        [(BlurWallSwitchViewController *)self.parentViewController switchViewController];
                    }];
                } failure:^() {
                    NSLog(@"checkUserAvailability error");
                    DEBUG_TAG();
                }];
            } failure:^() {
                NSLog(@"get answer error");
                DEBUG_TAG();
            }];
        } failure:^() {
            NSLog(@"check user availability error");
            DEBUG_TAG();
        }];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.activeTextView = textView;
    
    if (textView == self.cleanAskReplyTextView) {
        self.textNumberCounterLabel.text = [NSString stringWithFormat:@"%ld/20", [self stringCounter:textView.text] / 2];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.activeTextView = textView;
    
    if (textView == self.cleanAskReplyTextView) {
        if (!self.cleanAskReplyTextView.markedTextRange) {
            self.cleanAskReplyTextView.text = [self stringCounterTo:textView.text number:40.0];
            self.textNumberCounterLabel.text = [NSString stringWithFormat:@"%ld/20", [self stringCounter:textView.text] / 2];
        }
    }
}

// 檢查長度並裁切
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    self.activeTextView = nil;
    
    if (textView == self.cleanAskReplyTextView) {
        self.cleanAskReplyTextView.text = [self stringCounterTo:textView.text number:40.0];
    }
    
    return YES;
}

#pragma mark - Lazy Loading Image

// 下載圖片
- (void)downloadImageAtURL:(NSString *)imageURL withHandler:(void(^)(UIImage *image))handler {
    NSURL *urlString = [NSURL URLWithString:imageURL];
    
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    dispatch_async(queue, ^{
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:urlString options:NSDataReadingUncached error:&error];
        
        if (!error) {
            UIImage *downloadedImage = [UIImage imageWithData:data];
            // Add the image to the cache
            handler(downloadedImage); // pass back the image in a block
        } else {
            NSLog(@"%@", [error localizedDescription]);
            handler(nil); // pass back nil in the block
        }
    });
}

@end
