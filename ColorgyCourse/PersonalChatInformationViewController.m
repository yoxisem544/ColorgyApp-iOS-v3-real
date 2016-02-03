//
// PersonalChatInformationViewController.m
//  ColorgyCourse
//
//  Created by 張子晏 on 2016/2/2.
//  Copyright © 2016年 David. All rights reserved.
//

#import "PersonalChatInformationViewController.h"
#import "ColorgyCourse-Swift.h"
#import "UIImage+GaussianBlurUIImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PersonalChatInformationViewController () {
    UIBarButtonItem *submitBarButtonItem;
    UIScrollView *scrollView;
    UIView *notificationView;
    UIImageView *userImageView;
    UIButton *editUserImageButton;
    UILabel *nameLabel;
    UITextField *nameTextField;
    UILabel *textNumberCounterLabel;
    UIView *checkedView;
    BOOL nameIsOk;
    UIActivityIndicatorView *checkingView;
    UILabel *zodiacLabel;
    UITextField *zodiacTextField;
    UILabel *schoolLabel;
    UITextField *schoolTextField;
    UILabel *addressLabel;
    UITextField *addressTextField;
    UILabel *topicLabel;
    UITextView *topicTextView;
    UILabel *interestingLabel;
    UITextView *interestingTextView;
    UILabel *goodAtThingsLabel;
    UITextView *goodAtThingsTextView;
}

@end

@implementation PersonalChatInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Navigation Customized
     self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[self UIColorFromRGB:74.0 green:74.0 blue:74.0 alpha:100.0], NSFontAttributeName:[UIFont fontWithName:@"STHeitiTC-Medium" size:17.0]};
    [self.navigationController.navigationBar setTintColor:[self UIColorFromRGB:248 green:150 blue:128 alpha:100]];
    [self setTitle:@"個人資料"];
    submitBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submitMethod)];
    self.navigationItem.rightBarButtonItem = submitBarButtonItem;
    
    [ColorgyChatAPI me:^(NSDictionary *response) {
        NSLog(@"%@", response);
        
    } failure:^() {}];
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [self UIColorFromRGB:250 green:247 blue:245 alpha:100];
    [self.view addSubview:scrollView];
    
    // notificationView
    //    notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 48)];
    //    notificationView.backgroundColor = [self UIColorFromRGB:<#(CGFloat)#> green:<#(CGFloat)#> blue:<#(CGFloat)#> alpha:<#(CGFloat)#>]
    
    // userImageview
    CGFloat imageViewLength = 150;
    
    userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - imageViewLength / 2, self.view.bounds.origin.y + 90, imageViewLength, imageViewLength)];
    [userImageView sd_setImageWithURL:[NSURL URLWithString:[UserSetting UserAvatarUrl]]];
    [userImageView.layer setCornerRadius:imageViewLength / 2];
    [userImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [userImageView.layer setBorderWidth:3];
    [userImageView.layer setMasksToBounds:YES];
    [scrollView addSubview:userImageView];
    
    CGFloat buttonHeight = 16;
    
    editUserImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editUserImageButton setFrame:CGRectMake(userImageView.frame.origin.x, CGRectGetMaxY(userImageView.frame) - buttonHeight * 2, userImageView.bounds.size.width, buttonHeight)];
    [editUserImageButton setTitle:@"編輯" forState:UIControlStateNormal];
    [editUserImageButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:16.0]];
    [editUserImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editUserImageButton addTarget:self action:@selector(showPhotoMeunAlert) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:editUserImageButton];
    
    CGFloat sectionY = 30;
    CGFloat marginX = 25;
    CGFloat marginY = 10;
    CGFloat height = 32;
    CGFloat width = self.view.bounds.size.width - marginX * 2;
    CGRect textFieldPaddingRect = CGRectMake(0, 0, 5, 20);
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(userImageView.frame) + 100, width, height)];
    nameLabel.text = @"暱稱";
    nameLabel.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    nameLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17.0];
    [scrollView addSubview:nameLabel];
    
    nameTextField = [[UITextField alloc] initWithFrame: CGRectMake(marginX, CGRectGetMaxY(nameLabel.frame) + marginY, width, height)];
    nameTextField.backgroundColor = [UIColor whiteColor];
    nameTextField.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    nameTextField.text = [UserSetting UserNickyName];
    nameTextField.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0];
    nameTextField.leftView = [[UIView alloc] initWithFrame:textFieldPaddingRect];
    nameTextField.leftViewMode = UITextFieldViewModeAlways;
    [nameTextField.layer setBorderColor:[self UIColorFromRGB:200 green:199 blue:198 alpha:100].CGColor];
    [nameTextField.layer setBorderWidth:1];
    [nameTextField.layer setCornerRadius:3];
    [nameTextField.layer setMasksToBounds:YES];
    [nameTextField setDelegate:self];
    [scrollView addSubview:nameTextField];
    
    [self registerForUITextFieldTextDidChangeNotification];
    
    checkedView = [[UIView alloc] initWithFrame:CGRectMake(nameTextField.frame.size.width - nameTextField.frame.size.height, 0, nameTextField.frame.size.height, nameTextField.frame.size.height)];
    
    checkedView.backgroundColor = [UIColor clearColor];
    
    UIImageView *checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckIcon"]];
    
    checkImageView.center = CGPointMake(checkedView.frame.size.width / 2, checkedView.frame.size.height / 2);
    [checkedView addSubview:checkImageView];
    
    // textNumberCounter Customized
    textNumberCounterLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameTextField.frame.size.width - 50, 30, 45, 30)];
    textNumberCounterLabel.center = CGPointMake(nameTextField.frame.size.width - 50 / 2, nameTextField.frame.size.height / 2);
    textNumberCounterLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:13];
    textNumberCounterLabel.textColor = [self UIColorFromRGB:151 green:151 blue:151 alpha:100];
    textNumberCounterLabel.text = @"0/5";
    
    [nameTextField addSubview:textNumberCounterLabel];
    nameIsOk = NO;
    
    
    zodiacLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(nameTextField.frame) + sectionY, width, 32)];
    zodiacLabel.text = @"星座";
    zodiacLabel.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    zodiacLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17.0];
    [scrollView addSubview:zodiacLabel];
    
    zodiacTextField = [[UITextField alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(zodiacLabel.frame) + marginY, width, height)];
    zodiacTextField.backgroundColor = [UIColor whiteColor];
    zodiacTextField.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    zodiacTextField.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0];
    zodiacTextField.leftView = [[UIView alloc] initWithFrame:textFieldPaddingRect];
    zodiacTextField.leftViewMode = UITextFieldViewModeAlways;
    [zodiacTextField.layer setBorderColor:[self UIColorFromRGB:200 green:199 blue:198 alpha:100].CGColor];
    [zodiacTextField.layer setBorderWidth:1];
    [zodiacTextField.layer setCornerRadius:3];
    [zodiacTextField.layer setMasksToBounds:YES];
    [scrollView addSubview:zodiacTextField];
    
    schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(zodiacTextField.frame) + sectionY, width, 32)];
    schoolLabel.text = @"學校";
    schoolLabel.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    schoolLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17.0];
    [scrollView addSubview:schoolLabel];
    
    schoolTextField = [[UITextField alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(schoolLabel.frame) + marginY, width, height)];
    //schoolTextField.backgroundColor = [UIColor whiteColor];
    schoolTextField.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    schoolTextField.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17.0];
    schoolTextField.placeholder = [UserSetting UserOrganization];
    schoolTextField.enabled = NO;
    schoolTextField.leftView = [[UIView alloc] initWithFrame:textFieldPaddingRect];
    schoolTextField.leftViewMode = UITextFieldViewModeAlways;
    //    [schoolTextField.layer setBorderColor:[self UIColorFromRGB:200 green:199 blue:198 alpha:100].CGColor];
    //    [schoolTextField.layer setBorderWidth:1];
    //    [schoolTextField.layer setCornerRadius:3];
    //    [schoolTextField.layer setMasksToBounds:YES];
    [scrollView addSubview:schoolTextField];
    
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(schoolTextField.frame) + sectionY, width, 32)];
    addressLabel.text = @"居住地";
    addressLabel.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    addressLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17.0];
    [scrollView addSubview:addressLabel];
    
    addressTextField = [[UITextField alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(addressLabel.frame) + marginY, width, height)];
    addressTextField.backgroundColor = [UIColor whiteColor];
    addressTextField.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    addressTextField.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0];
    addressTextField.leftView = [[UIView alloc] initWithFrame:textFieldPaddingRect];
    addressTextField.leftViewMode = UITextFieldViewModeAlways;
    [addressTextField.layer setBorderColor:[self UIColorFromRGB:200 green:199 blue:198 alpha:100].CGColor];
    [addressTextField.layer setBorderWidth:1];
    [addressTextField.layer setCornerRadius:3];
    [addressTextField.layer setMasksToBounds:YES];
    [scrollView addSubview:addressTextField];
    
    topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(addressTextField.frame) + sectionY, width, height)];
    topicLabel.text = @"想聊的話題";
    topicLabel.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    topicLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17.0];
    
    topicTextView = [[UITextView alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(topicLabel.frame) + marginY, width, height * 2.5)];
    topicTextView.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    topicTextView.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0];
    [topicTextView.layer setBorderColor:[self UIColorFromRGB:200 green:199 blue:198 alpha:100].CGColor];
    [topicTextView.layer setBorderWidth:1];
    [topicTextView.layer setCornerRadius:3];
    [topicTextView.layer setMasksToBounds:YES];
    [scrollView addSubview:topicLabel];
    [scrollView addSubview:topicTextView];
    
    interestingLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(topicTextView.frame) + sectionY, width, height)];
    interestingLabel.text = @"現在熱衷的事情";
    interestingLabel.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    interestingLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17.0];
    [scrollView addSubview:interestingLabel];
    
    interestingTextView = [[UITextView alloc] initWithFrame:
                           CGRectMake(marginX, CGRectGetMaxY(interestingLabel.frame) + marginY, width, height  *2.5)];
    interestingTextView.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    interestingTextView.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0];
    [interestingTextView.layer setBorderColor:[self UIColorFromRGB:200 green:199 blue:198 alpha:100].CGColor];
    [interestingTextView.layer setBorderWidth:1];
    [interestingTextView.layer setCornerRadius:3];
    [interestingTextView.layer setMasksToBounds:YES];
    [scrollView addSubview:interestingTextView];
    
    goodAtThingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(interestingTextView.frame) + sectionY, width, height)];
    goodAtThingsLabel.text = @"專精的事情";
    goodAtThingsLabel.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    goodAtThingsLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17.0];
    [scrollView addSubview:goodAtThingsLabel];
    
    goodAtThingsTextView = [[UITextView alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(goodAtThingsLabel.frame) + marginY, width, height * 2.5)];
    goodAtThingsTextView.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    goodAtThingsTextView.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0];
    [goodAtThingsTextView.layer setBorderColor:[self UIColorFromRGB:200 green:199 blue:198 alpha:100].CGColor];
    [goodAtThingsTextView.layer setBorderWidth:1];
    [goodAtThingsTextView.layer setCornerRadius:3];
    [goodAtThingsTextView.layer setMasksToBounds:YES];
    [scrollView addSubview:goodAtThingsTextView];
    
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(goodAtThingsTextView.frame) + 50);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Submit

- (void)submitMethod {
    
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
    
    [self dismissCheck];
    
    if (textField == nameTextField) {
        textNumberCounterLabel.text = [NSString stringWithFormat:@"%ld/5", [self stringCounter:nameTextField.text] / 2];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.activeTextField = nil;
    
    if (textField == nameTextField) {
        [self dismissCheck];
        nameTextField.text = [self stringCounterTo:nameTextField.text number:10];
        
        // 檢查名字 尚需修改
        if (nameTextField.text.length) {
            [self showChecking];
            [ColorgyChatAPI checkNameExists:nameTextField.text success:^(NSDictionary *response) {
                if ([[response valueForKey:@"result"] isEqualToString:@"ok"]) {
                    [self showCheck];
                } else {
                    [self dismissCheck];
                }
            } failure:^() {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"傳輸失敗Q_Q" message:@"請網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
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
    if (nameTextField.markedTextRange) {
        return;
    }
    if (self.activeTextField == nameTextField) {
        NSString *string = nameTextField.text;
        
        if ([self stringCounter:string] > 10) {
            nameTextField.text = [self stringCounterTo:string number:10];
        }
        textNumberCounterLabel.text = [NSString stringWithFormat:@"%ld/5", [self stringCounter:nameTextField.text] / 2];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - CheckView

- (void)showChecking {
    checkingView = [[UIActivityIndicatorView alloc] initWithFrame:checkedView.frame];
    
    [checkingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [checkingView startAnimating];
    [textNumberCounterLabel removeFromSuperview];
    [checkedView removeFromSuperview];
    [nameTextField addSubview:checkingView];
    nameIsOk = YES;
}

- (void)showCheck {
    [checkingView removeFromSuperview];
    [textNumberCounterLabel removeFromSuperview];
    [nameTextField addSubview:checkedView];
    nameIsOk = YES;
}

- (void)dismissCheck {
    [checkingView removeFromSuperview];
    [checkedView removeFromSuperview];
    [nameTextField addSubview:textNumberCounterLabel];
    nameIsOk = NO;
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
//    [photoMeunAlertController addAction:[UIAlertAction actionWithTitle:@"使用FB大頭照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        
//        // FBImageSticker button tapped.
//        [self dismissViewControllerAnimated:YES completion:^{
//        }];
//        [self removeUploadLayout];
//        [self uploadPreviewLayout];
//        UIActivityIndicatorView *indView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [indView startAnimating];
//        indView.center = CGPointMake(self.userImageView.bounds.size.width / 2, self.userImageView.bounds.size.height / 2);
//        [userImageView addSubview:indView];
//        [self downloadImageAtURL:[UserSetting UserAvatarUrl] withHandler:^(UIImage *image) {
//            self.uploadImage = image;
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                self.userImageView.image = [image gaussianBlurImage:image andInputRadius:4];
//                [indView removeFromSuperview];
//                [self.userImageView setNeedsLayout];
//            });
//        }];
//    }]];
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
    userImageView.image = [self.uploadImage gaussianBlurImage:self.uploadImage andInputRadius:4];;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"imagePickerControllerDidCancel");
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UIImage Resize

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize {
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

#pragma mark - UIColor

- (UIColor *)UIColorFromRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:(alpha / 100)];
}

@end
