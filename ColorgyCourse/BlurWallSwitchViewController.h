//
//  BlurWallSwitchViewController.h
//  ColorgyCourse
//
//  Created by 張子晏 on 2016/1/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorgyCOurse-Swift.h"
#import "OpeningViewController.h"
#import "BlurWallViewController.h"

@interface BlurWallSwitchViewController : UIViewController

@property BOOL isEmailOK;
@property UIViewController *activityViewController;
@property OpeningViewController *openingViewController;
@property UINavigationController *navigationBlurWallViewController;
@property NSString *lastestQuestion;
@property NSString *questionDate;
@property ChatUser *chatUser;

- (void)switchViewController;

@end
