//
//  UselessView.m
//  ColorgyCourse
//
//  Created by 張子晏 on 2016/2/24.
//  Copyright © 2016年 David. All rights reserved.
//

#import "UselessView.h"

@implementation UselessView {
    NSString *messageString;
    UIView *messageView;
}

- (instancetype)initWithFrame:(CGRect)frame withMessage:(NSString *)message {
    self = [super initWithFrame:frame];
    if (self) {
        messageString = message;
        self.backgroundColor = [self UIColorFromRGB:0 green:207 blue:228 alpha:100];
        
        CGFloat height = self.bounds.size.height;
        CGFloat centerHeight = self.bounds.size.height / 2;
        
        self.loudSpeakerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loudSpeaker"]];
        self.loudSpeakerImageView.frame = CGRectMake(0, 0, 20, 20);
        self.loudSpeakerImageView.center = CGPointMake(centerHeight, centerHeight);
        [self addSubview:self.loudSpeakerImageView];
        
//        messageView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.height, self.bounds.origin.y, self.bounds.size.width - height * 2, self.bounds.size.height)];
//        messageView.backgroundColor = [UIColor blueColor];
        [self addSubview:messageView];
        
        
        CGFloat messageWidth = messageView.bounds.size.width;
        
//        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageWidth, 0, 320, self.bounds.size.height)];
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(height, 0, self.bounds.size.width - height, self.bounds.size.height)];
//        self.messageLabel.backgroundColor = [UIColor yellowColor];
        self.messageLabel.textColor = [UIColor whiteColor];
        self.messageLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:15];
        self.messageLabel.text = messageString;
//        [messageView addSubview:self.messageLabel];
        [self addSubview:self.messageLabel];
        
//        [self.messageLabel sizeToFit];
        
//        [UIView animateWithDuration:20 delay:0 options:UIViewAnimationOptionCurveLinear animations:^() {
//            self.messageLabel.frame = CGRectMake(-self.messageLabel.bounds.size.width, 0, self.messageLabel.bounds.size.width, self.bounds.size.height);
//        } completion:^(BOOL finished) {}];
    }
    return self;
}

#pragma mark - UIColor

- (UIColor *)UIColorFromRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:(alpha / 100)];
}

@end
