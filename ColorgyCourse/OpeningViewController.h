//
//  OpeningViewController.h
//  Colorgy
//
//  Created by 張子晏 on 2016/1/16.
//  Copyright © 2016年 張子晏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "ColorgyChatAPIOC.h"

@interface OpeningViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate>

// opening layout
@property UIImageView *welcomeChatIconImageView;
@property UILabel *welcomeLabel;
@property UILabel *welcomeDescriptionLabel;
@property UIButton *startCheckEmailButton;

// email check layout
@property UIView *popView;
@property UIView *maskView;
@property UIImageView *emailImageView;
@property UILabel *messageLabel;
@property NSString *loadingString;
@property NSString *finishedString;
@property UIButton *checkEmailButton;
@property UIButton *manualVerificationButton;

// uplaod layout
@property UIImageView *userImageView;
@property UILabel *uploadDescriptionLabel;
@property UILabel *uploadTitleLabel;
@property UIButton *uploadPhotoButton;

// upload preview layout
@property UIButton *uploadSubmitButton;

// name layout
@property UILabel *nameDescriptionLabel;
@property UITextField *nameTextField;
@property UIButton *submitNameButton;
@property UIView *checkedView;
@property UIActivityIndicatorView *checkingView;
@property Boolean nameIsOk;
@property UIView *progressBarView1;

// clean ask layout
@property UILabel *cleanAskTitleLabel;
@property UILabel *cleanAskQuestionLabel;
@property UITextView *cleanAskReplyTextView;
@property UIButton *openChatButton;
@property NSString *questionString;
@property NSString *questionDate;
@property UIView *progressBarView2;

//
@property UILabel *textNumberCounterLabel;
@property UIImage *uploadImage;
@property LoadingView *loadingView;
@property UIScrollView *scrollView;
@property UITextField *activeTextField;
@property UITextView *activeTextView;
@property ColorgyChatAPIOC *chatApiOC;

@property NSInteger whichLayout;

- (instancetype)initWithLayout:(NSInteger)whichLayout;

@end
