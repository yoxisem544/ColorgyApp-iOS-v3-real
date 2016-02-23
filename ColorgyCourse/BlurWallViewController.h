//
//  BlurWallViewController.h
//  Colorgy
//
//  Created by 張子晏 on 2016/1/20.
//  Copyright © 2016年 張子晏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface BlurWallViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate>

@property UICollectionView *blurWallCollectionView;
@property UICollectionViewFlowLayout *blurWallCollectionViewFlowLayout;
@property UIRefreshControl *blurWallRefreshControl;
@property NSMutableArray *blurWallDataMutableArray;
@property NSInteger numberOfColumn;
@property UISegmentedControl *blurWallSegmentedControl;
@property LoadingView *loadingView;

// CleanAskView
@property UIView *cleanAskView;
@property UIView *cleanAskMaskView;
@property UIView *cleanAskAlertView;
@property UITextView *cleanAskTextView;
@property NSString *cleanAskString;
@property NSString *questionDate;
@property UIWindow *currentWindow;
@property UILabel *cleanAskTitleLabel;
@property UILabel *cleanAskMessageLabel;
@property UIButton *cancelButton;
@property UIButton *submitButton;
@property UIView *line1;
@property UIView *line2;
@property UILabel *textNumberCounterLabel;

@end
