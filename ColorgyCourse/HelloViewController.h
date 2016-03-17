//
//  HelloViewController.h
//  ColorgyCourse
//
//  Created by 張子晏 on 2016/2/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorgyCourse-Swift.h"

@interface HelloViewController : UIViewController<UITextViewDelegate, UIScrollViewDelegate>

@property UIImage *userImage;

@property UIImageView *userImageView;
@property UIImageView *chatIconImageView;
@property UILabel *chatMessageLabel;
@property UIView *buttonView;
@property UIButton *helloButton;
@property UIScrollView *scrollView;

// CleanAskView
@property UIView *cleanAskView;
@property UIView *cleanAskMaskView;
@property UIView *cleanAskAlertView;
@property UITextView *cleanAskTextView;
@property NSString *cleanAskString;
@property NSString *cleanAskDate;
@property UIWindow *currentWindow;
@property UILabel *cleanAskTitleLabel;
@property UILabel *cleanAskMessageLabel;
@property UIButton *cancelButton;
@property UIButton *submitButton;
@property UIView *line1;
@property UIView *line2;
@property UILabel *textNumberCounterLabel;

- (instancetype)initWithInformaion:(AvailableTarget *)information;

@end
