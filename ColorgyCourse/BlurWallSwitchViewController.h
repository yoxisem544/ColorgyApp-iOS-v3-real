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

@property UIViewController *activityViewController;
@property OpeningViewController *openingViewController;
@property BlurWallViewController *blurWallViewController;
@property UINavigationController *navigationBlurWallViewController;
@property UIButton *refreshButton;
@property ChatUser *chatUser;
@property UILabel *notAvailableLabel;
@property UILabel *notAvailableLabelSubtitle;
@property UIImageView *notAvailableImageView;

- (void)switchViewController;

@end
