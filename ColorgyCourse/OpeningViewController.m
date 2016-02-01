//
//  OpeningViewController.m
//  Colorgy
//
//  Created by 張子晏 on 2016/1/16.
//  Copyright © 2016年 張子晏. All rights reserved.
//

#import "OpeningViewController.h"
#import "UIImage+GaussianBlurUIImage.h"
#import "NSString+Email.h"
#import "ColorgyChatAPIOC.h"

@implementation OpeningViewController

#pragma mark - LifeCicle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    // nameScrollView Customized
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.contentSize = self.view.bounds.size;
    self.scrollView.backgroundColor = [self UIColorFromRGB:250.0 green:247.0 blue:245.0 alpha:100.0];
    
    // Layout
    [self openingLayout];
    // [self uploadLayout];
    // [self nameLayout];
    // [self cleanAskLayout];
    
    [self registerForUITextFieldTextDidChangeNotification];
    // keyboard and tapGesture
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchViewToReturn)];
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self.scrollView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - UIColor

- (UIColor *)UIColorFromRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:(alpha / 100)];
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

#pragma mark - TouchViewToReturn

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
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - OpeningLayout

- (void)openingLayout {
    
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:YES];
    
    // View Customized
    self.view.backgroundColor = [self UIColorFromRGB:250.0 green:247.0 blue:245.0 alpha:100.0];
    
    // Navigation Customized
    // self.title = @"模糊聊";
    // self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[self UIColorFromRGB:74.0 green:74.0 blue:74.0 alpha:100.0], NSFontAttributeName:[UIFont fontWithName:@"STHeitiTC-Medium" size:17.0]};
    // self.navigationController.navigationBar.tintColor = [self UIColorFromRGB:255.0 green:255.0 blue:255.0 alpha:80.0];
    
    // WelcomeChatIconImageView Cusomized
    self.welcomeChatIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WelcomeChatIcon"]];
    self.welcomeChatIconImageView.frame = CGRectMake(100, 100, 131, 127);
    self.welcomeChatIconImageView.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
    
    [self.view addSubview:self.welcomeChatIconImageView];
    
    // Label Welcome Customized
    NSAttributedString *attributedWelcomeString = [[NSAttributedString alloc] initWithString:@"歡迎光臨模糊聊" attributes:@{NSForegroundColorAttributeName:[self UIColorFromRGB:74.0 green:74.0 blue:74.0 alpha:100.0], NSFontAttributeName: [UIFont fontWithName:@"STHeitiTC-Light" size:24.0]}];
    
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
    self.checkEmailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkEmailButton.frame = CGRectMake(141, 440, 120, 41);
    self.checkEmailButton.backgroundColor = [UIColor clearColor];
    self.checkEmailButton.layer.borderColor = [self UIColorFromRGB:248 green:150 blue:128 alpha:100].CGColor;
    self.checkEmailButton.layer.borderWidth = 2.5;
    self.checkEmailButton.layer.cornerRadius = 2.5;
    self.checkEmailButton.center = CGPointMake(self.view.center.x, self.welcomeDescriptionLabel.center.y + 50);
    
    [self.checkEmailButton setTitle:@"開始認證" forState:UIControlStateNormal];
    [self.checkEmailButton setTitleColor:[self UIColorFromRGB:248 green:150 blue:128 alpha:100] forState:UIControlStateNormal];
    [self.checkEmailButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:20.0]];
    [self.checkEmailButton addTarget:self action:@selector(showCheckEmailAlert) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.checkEmailButton];
}

- (void)removeOpeningLayout {
    [self.welcomeChatIconImageView removeFromSuperview];
    [self.checkEmailButton removeFromSuperview];
    //[self.uploadPhotoButton removeFromSuperview];
    [self.welcomeLabel removeFromSuperview];
    [self.welcomeDescriptionLabel removeFromSuperview];
}

#pragma mark - CheckEmailButtonAction

- (void)showCheckEmailAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"認證學校信箱" message:@"發送後趕快去收信吧～" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"colorgy@gmail.com";
        self.activeTextField = textField;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"發送" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSString *emailString = alertController.textFields.firstObject.text;
        
        if ([emailString isEmail]) {
            // [self removeOpeningLayout];
            self.activeTextField = nil;
            self.loadingView = [[LoadingView alloc] init];
            self.loadingView.loadingString = @"發送中";
            self.loadingView.finishedString = @"發送成功";
            [self.loadingView start];
            self.loadingView.maskView.backgroundColor = [UIColor blackColor];
            self.loadingView.maskView.alpha = 0.75;
            
            // 發送email認證，模擬延遲
            ColorgyChatAPIOC *chatApi = [[ColorgyChatAPIOC alloc] init];
            
            [chatApi postEmail:emailString success:^(NSDictionary *response) {
                NSLog(@"%@", [response valueForKey:@""]);
                [self.loadingView emailCheck];
                [self.loadingView.checkEmailButton addTarget:self action:@selector(checkEmail) forControlEvents:UIControlEventTouchUpInside];
            } failure:^() {
                [self.loadingView dismiss:nil];
                // [self openingLayout];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"傳輸失敗Q_Q" message:@"請檢查網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
            
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                [self.loadingView finished:^() {
            //                    [self.loadingView emailCheck];
            //                    [self.loadingView.checkEmailButton addTarget:self action:@selector(checkEmail) forControlEvents:UIControlEventTouchUpInside];
            //                }];
            //            });
        } else {
            alertController.message = @"信箱錯誤";
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)checkEmail {
    self.loadingView.loadingString = @"驗證中";
    
    [self.loadingView start];
    // 認證信箱
    // 模擬延遲
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loadingView finished:^() {
            [self removeOpeningLayout];
            [self uploadLayout];
        }];
    });
}

#pragma mark - Upload Layout

- (void)uploadLayout {
    // userImageView Customized
    self.userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 142, 142)];
    self.userImageView.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
    self.uploadImage = [UIImage imageNamed:@"2.jpg"];
    self.userImageView.image = [self.uploadImage gaussianBlurImage:self.uploadImage andInputRadius:4];
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
    [self.uploadPhotoButton addTarget:self action:@selector(showPhotoMeunAlert) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.uploadPhotoButton];
}

- (void)removeUploadLayout {
    [self.userImageView removeFromSuperview];
    [self.uploadTitleLabel removeFromSuperview];
    [self.uploadDescriptionLabel removeFromSuperview];
    [self.uploadPhotoButton removeFromSuperview];
}

#pragma mark - UploadButtonAction

- (void)showPhotoMeunAlert {
    // UIAlertController AnctionSheetStyle Initializing
    UIAlertController *photoMeunAlertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [photoMeunAlertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [photoMeunAlertController addAction:[UIAlertAction actionWithTitle:@"使用FB大頭照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // FBImageSticker button tapped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [photoMeunAlertController addAction:[UIAlertAction actionWithTitle:@"從相簿選擇" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // PhotoAlbumr button tapped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        [self openPhotoLibrary];
    }]];
    [photoMeunAlertController addAction:[UIAlertAction actionWithTitle:@"拍攝照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // TakePhoto button tapped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        [self openPhotoCamera];
    }]];
    [self presentViewController:photoMeunAlertController animated:YES completion:nil];
}

- (void)openPhotoLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        UIAlertController *alertError = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"存取相簿失敗" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertError addAction:[UIAlertAction actionWithTitle:@"好吧..." style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }]];
        [self presentViewController:alertError animated:YES completion:nil];
    }
}

- (void)openPhotoCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        UIAlertController *alertError = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"存取相機失敗" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertError addAction:[UIAlertAction actionWithTitle:@"好吧..." style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self dismissViewControllerAnimated:YES completion:^{
            }];
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
    [self uploadPreviewLayout];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"imagePickerControllerDidCancel");
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - Upload Preview
- (void)uploadPreviewLayout {
    // userImageView Customized
    self.userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 142, 142)];
    self.userImageView.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
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

- (void)uploadingImage {
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
    ColorgyChatAPIOC *chatApi = [[ColorgyChatAPIOC alloc] init];
    CGRect chopRect = CGRectMake(0, 0, self.uploadImage.size.width, self.uploadImage.size.height);
    
    [chatApi patchUserImage:self.uploadImage chopRect:chopRect success:^(NSDictionary *response) {
        NSLog(@"%@", [response valueForKey:@"avatar_url"]);
        [self.loadingView finished:^() {
            [self nameLayout];
        }];
    } failure:^() {
        [self.loadingView dismiss:^() {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"傳輸失敗Q_Q" message:@"請檢查網路連線是否正常" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil, nil];
            
            [alertView show];
            [self uploadPreviewLayout];
        }];
    }];
    
    // 測試用需要刪除
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self.loadingView finished:^(){
    //            [self nameLayout];
    //        }];
    //    });
}

#pragma mark - UIImage Resize

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize {
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

#pragma mark - NameLayout

- (void)nameLayout {
    self.nameIsOk = NO;
    
    [self.view addSubview:self.scrollView];
    [self.tabBarController.tabBar setHidden:YES];
    
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
    self.nameTextField.placeholder = @"五字以內";
    
    [self.scrollView addSubview:self.nameTextField];
    
    //[self.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    
    self.nameTextField.leftView = paddingView;
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.checkView = [[UIView alloc] initWithFrame:CGRectMake(self.nameTextField.frame.size.width - self.nameTextField.frame.size.height, 0, self.nameTextField.frame.size.height, self.nameTextField.frame.size.height)];
    
    self.checkView.backgroundColor = [UIColor clearColor];
    
    UIImageView *checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckIcon"]];
    
    checkImageView.center = CGPointMake(self.checkView.frame.size.width / 2, self.checkView.frame.size.height / 2);
    [self.checkView addSubview:checkImageView];
    
    // textNumberCunter Customized
    self.textNumberCounterLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameTextField.frame.size.width - 50, 30, 45, 30)];
    self.textNumberCounterLabel.center = CGPointMake(self.nameTextField.frame.size.width - 50 / 2, self.nameTextField.frame.size.height / 2);
    self.textNumberCounterLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:13];
    self.textNumberCounterLabel.textColor = [self UIColorFromRGB:151 green:151 blue:151 alpha:100];
    self.textNumberCounterLabel.text = @"0/5";
    
    [self.nameTextField addSubview:self.textNumberCounterLabel];
    
    // SubmitNameButtom Customized
    self.submitNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitNameButton.frame = CGRectMake(141, 440, 96, 32);
    self.submitNameButton.backgroundColor = [UIColor clearColor];
    self.submitNameButton.layer.borderColor = [self UIColorFromRGB:248 green:150 blue:128 alpha:100].CGColor;
    self.submitNameButton.layer.borderWidth = 2.5;
    self.submitNameButton.layer.cornerRadius = 2.5;
    self.submitNameButton.center = CGPointMake(self.view.center.x, self.nameTextField.center.y + 80);
    
    [self.scrollView addSubview:self.submitNameButton];
    
    // SubmitNameButtom Customized
    [self.submitNameButton setTitle:@"下一題" forState:UIControlStateNormal];
    [self.submitNameButton setTitleColor:[self UIColorFromRGB:248 green:150 blue:128 alpha:100] forState:UIControlStateNormal];
    [self.submitNameButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:16.0]];
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

- (void)removeNameLayout {
    [self.nameDescriptionLabel removeFromSuperview];
    [self.nameTextField removeFromSuperview];
    [self.submitNameButton removeFromSuperview];
    [self.scrollView removeFromSuperview];
    [self.progressBarView1 removeFromSuperview];
}

#pragma mark - CheckView

- (void)showCheck {
    [self.textNumberCounterLabel removeFromSuperview];
    [self.nameTextField addSubview:self.checkView];
    self.nameIsOk = YES;
}

- (void)dismissCheck {
    [self.checkView removeFromSuperview];
    [self.nameTextField addSubview:self.textNumberCounterLabel];
    self.nameIsOk = NO;
}

#pragma mark - submitName

- (void)submitName {
    if (self.nameIsOk && self.nameTextField.text.length) {
        // 上傳名字
        // CleanAskLayout
        [self removeNameLayout];
        [self cleanAskLayout];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
    
    [self dismissCheck];
    
    if (textField == self.nameTextField) {
        self.textNumberCounterLabel.text = [NSString stringWithFormat:@"%ld/5", [self stringCounter:self.nameTextField.text] / 2];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.activeTextField = nil;
    
    if (textField == self.nameTextField) {
        [self dismissCheck];
        self.nameTextField.text = [self stringCounterTo:self.nameTextField.text number:10];
        
        // 檢查名字 尚需修改
        if (self.nameTextField.text.length) {
            if (/* DISABLES CODE */ (YES)) {
                [self showCheck];
            } else {
                [self dismissCheck];
            }
        }
    }
    return YES;
}

//- (void)textFieldDidChange:(UITextField *)textField {
//    if (textField == self.nameTextField) {
//        self.activeTextField = self.nameTextField;
//        self.nameTextField.text = [self stringCounterTo:self.nameTextField.text number:10.0];
//        self.textNumberCounterLabel.text = [NSString stringWithFormat:@"%ld/5", [self stringCounter:self.nameTextField.text] / 2];
//    }
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.nameTextField) {
        if (!string.length || textField.markedTextRange) {
            return YES;
        }
        
        NSString *tempString  = self.nameTextField.text;
        NSString *checkString;
        
        tempString = [tempString stringByAppendingString:string];
        checkString = [[NSString alloc] initWithString:tempString];
        
        tempString = [self stringCounterTo:tempString number:10];
        //self.textNumberCounterLabel.text = [NSString stringWithFormat:@"%ld/5", [self stringCounter:tempString] / 2];
        if (checkString.length != tempString.length) {
            //[self.nameTextField resignFirstResponder];
            
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

- (void)textChange:(NSNotification *)noti {
    if (self.nameTextField.markedTextRange) {
        return;
    }
    if (self.activeTextField == self.nameTextField) {
        NSString *string = self.nameTextField.text;
        
        if ([self stringCounter:string] > 10) {
            self.nameTextField.text = [self stringCounterTo:string number:10];
        }
        self.textNumberCounterLabel.text = [NSString stringWithFormat:@"%ld/5", [self stringCounter:self.nameTextField.text] / 2];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - CleanAskLayout

- (void)cleanAskLayout {
    
    [self.view addSubview:self.scrollView];
    
    [self.tabBarController.tabBar setHidden:YES];
    
    // 取得問題
    self.questionString = @"你喜歡的電影或是類型？";
    
    // CleanSakQuestionLabel Customized
    self.cleanAskQuestionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 60, 18)];
    self.cleanAskQuestionLabel.center = CGPointMake(self.view.center.x, self.view.center.y - 120);
    self.cleanAskQuestionLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17.0];
    self.cleanAskQuestionLabel.textColor = [self UIColorFromRGB:151 green:151 blue:151 alpha:100];
    self.cleanAskQuestionLabel.text = self.questionString;
    self.cleanAskQuestionLabel.textAlignment = NSTextAlignmentCenter;
    self.cleanAskQuestionLabel.numberOfLines = 0;
    
    CGSize size = [self.questionString sizeWithAttributes:@{NSForegroundColorAttributeName:[self UIColorFromRGB:151.0 green:151.0 blue:151.0 alpha:100.0], NSFontAttributeName: [UIFont fontWithName:@"STHeitiTC-Light" size:17.0]}];
    
    if (size.width >= self.cleanAskQuestionLabel.frame.size.width) {
        [self.cleanAskQuestionLabel sizeToFit];
    }
    
    [self.scrollView addSubview:self.cleanAskQuestionLabel];
    
    // cleanAskReplyTextView Customized
    self.cleanAskReplyTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 60 , 73)];
    //self.cleanAskReplyTextView.text = @"我是浪漫人，只看浪漫電影。只看浪漫電影。";
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
    self.textNumberCounterLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cleanAskReplyTextView.frame) - 45, CGRectGetMaxY(self.cleanAskReplyTextView.frame) - 30, 45, 30)];
    self.textNumberCounterLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:13];
    self.textNumberCounterLabel.textColor = [self UIColorFromRGB:151 green:151 blue:151 alpha:100];
    self.textNumberCounterLabel.text = @"0/20";
    
    [self.scrollView addSubview:self.textNumberCounterLabel];
    
    // openChatButton Customized
    self.openChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openChatButton.frame = CGRectMake(141, 440, 96, 32);
    self.openChatButton.backgroundColor = [UIColor clearColor];
    self.openChatButton.layer.borderColor = [self UIColorFromRGB:248 green:150 blue:128 alpha:100].CGColor;
    self.openChatButton.layer.borderWidth = 2.5;
    self.openChatButton.layer.cornerRadius = 2.5;
    self.openChatButton.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.cleanAskReplyTextView.frame) + 50);
    
    [self.openChatButton setTitle:@"開始聊" forState:UIControlStateNormal];
    [self.openChatButton setTitleColor:[self UIColorFromRGB:248 green:150 blue:128 alpha:100] forState:UIControlStateNormal];
    [self.openChatButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:16.0]];
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
    
    // CleanAskTitleLabel Customized
    //    self.cleanAskTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 315, 18)];
    //    self.cleanAskTitleLabel.textAlignment = NSTextAlignmentCenter;
    //    self.cleanAskTitleLabel.center = CGPointMake(self.view.center.x, self.progressBarView2.center.y - self.progressBarView2.bounds.size.height / 2 - self.cleanAskTitleLabel.bounds.size.height / 2);
    //
    //    NSAttributedString *attributedcleanAskTitleString = [[NSAttributedString alloc] initWithString:@"每日清晰問，讓大家更了解你" attributes:@{NSForegroundColorAttributeName:[self UIColorFromRGB:151.0 green:151.0 blue:151.0 alpha:100.0], NSFontAttributeName: [UIFont fontWithName:@"STHeitiTC-Light" size:17.0]}];
    //
    //    self.cleanAskTitleLabel.attributedText = attributedcleanAskTitleString;
    //
    //    [self.view addSubview:self.cleanAskTitleLabel];
}

- (void)removeCleanAskLayout {
    [self.cleanAskQuestionLabel removeFromSuperview];
    [self.cleanAskReplyTextView removeFromSuperview];
    [self.scrollView removeFromSuperview];
    [self.openChatButton removeFromSuperview];
    [self.textNumberCounterLabel removeFromSuperview];
    [self.cleanAskTitleLabel removeFromSuperview];
    [self.progressBarView2 removeFromSuperview];
}

#pragma mark - openChatButtonAction

- (void)openChatButtonAcion {
    if (self.cleanAskReplyTextView.text.length) {
        // 開啟模糊牆
        [self.navigationController.navigationBar setHidden:YES];
        [self.tabBarController.tabBar setHidden:NO];
        [self.navigationController popViewControllerAnimated:NO];
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

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    self.activeTextView = nil;
    
    if (textView == self.cleanAskReplyTextView) {
        self.cleanAskReplyTextView.text = [self stringCounterTo:textView.text number:40.0];
    }
    
    return YES;
}

@end