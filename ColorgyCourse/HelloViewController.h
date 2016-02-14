//
//  HelloViewController.h
//  ColorgyCourse
//
//  Created by 張子晏 on 2016/2/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorgyCourse-Swift.h"

@interface HelloViewController : UIViewController

@property UIImage *userImage;

@property UIImageView *userImageView;
@property UIImageView *chatIconImageView;
@property UILabel *chatMessageLabel;
@property UIView *buttonView;
@property UIButton *helloButton;
@property UIScrollView *scrollView;

- (instancetype)initWithInformaion:(ChatUserInformation *)information;

@end
