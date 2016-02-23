//
//  ColorgyChatAPIOC.h
//  ColorgyCourse
//
//  Created by 張子晏 on 2016/1/28.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#define OPENING_VIEW_STATUS @"openingViewStatus"

@interface ColorgyChatAPIOC : NSObject

@property NSString *lastestQuestion;
@property NSString *questionDate;

- (void)getQuestion:(void (^)(NSDictionary *))success failure:(void (^)(void))failure;
- (void)postEmail:(NSString *)email success:(void (^)(NSDictionary *response))success failure:(void (^)(void))failure;
- (void)patchUserImage:(UIImage *)image chopRect:(CGRect)chopRect success:(void (^)(NSDictionary *response))success failure:(void (^)(void))failure;

@end
