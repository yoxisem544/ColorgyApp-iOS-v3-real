//
//  UselessView.h
//  ColorgyCourse
//
//  Created by 張子晏 on 2016/2/24.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UselessView : UIView

@property UIImageView *loudSpeakerImageView;
@property UILabel *messageLabel;

- (instancetype)initWithFrame:(CGRect)frame withMessage:(NSString *)message;

@end
