//
//  OpeningViewController.h
//  Colorgy
//
//  Created by 張子晏 on 2016/1/16.
//  Copyright © 2016年 張子晏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface OpeningViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate>

// opening layout
@property UIImageView *welcomeChatIconImageView;
@property UIButton *checkEmailButton;
@property UILabel *welcomeLabel;
@property UILabel *welcomeDescriptionLabel;

// name layout
@property UILabel *nameDescriptionLabel;
@property UITextField *nameTextField;
@property UIButton *submitNameButton;
@property UIView *checkView;
@property Boolean nameIsOk;
@property UIView *progressBarView1;

// clean ask layout
@property UILabel *cleanAskTitleLabel;
@property UILabel *cleanAskQuestionLabel;
@property UITextView *cleanAskReplyTextView;
@property UIButton *openChatButton;
@property NSString *questionString;
@property UIView *progressBarView2;

//
@property UILabel *textNumberCounterLabel;
@property UIImage *uploadImage;
@property LoadingView *imageLoadingView;
@property UIScrollView *scrollView;
@property UITextField *activeTextField;
@property UITextView *activeTextView;

@end
