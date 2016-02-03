//
// PersonalChatInformationViewController.m
//  ColorgyCourse
//
//  Created by 張子晏 on 2016/2/2.
//  Copyright © 2016年 David. All rights reserved.
//

#import "PersonalChatInformationViewController.h"
#import "ColorgyCourse-Swift.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PersonalChatInformationViewController () {
    UIScrollView *scrollView;
    UIView *notificationView;
    UIImageView *userImageView;
    UIButton *editUserImageButton;
    UILabel *nameLabel;
    UITextField *nameTextField;
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
    editUserImageButton.backgroundColor = [UIColor blackColor];
    [editUserImageButton setFrame:CGRectMake(userImageView.frame.origin.x, CGRectGetMaxY(userImageView.frame) - buttonHeight, userImageView.bounds.size.width, buttonHeight)];
    [editUserImageButton setTitle:@"編輯" forState:UIControlStateNormal];
    [editUserImageButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:16.0]];
    [editUserImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scrollView addSubview:editUserImageButton];
    
    CGFloat sectionY = 30;
    CGFloat marginX = 25;
    CGFloat marginY = 10;
    CGFloat height = 32;
    CGFloat width = self.view.bounds.size.width - marginX * 2;
    CGRect textFieldPaddingRect = CGRectMake(0, 0, 5, 20);
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(userImageView.frame) + 150, width, height)];
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
    [scrollView addSubview:nameTextField];
    
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

#pragma mark - UIColor

- (UIColor *)UIColorFromRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:(alpha / 100)];
}

@end
