//
//  ColorgyChatAPI.h
//  ColorgyCourse
//
//  Created by 張子晏 on 2016/1/28.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@interface ColorgyChatAPI : NSObject

- (void)test;
- (void)postEmail:(NSString *)email success:(void (^)(NSDictionary *response))success failure:(void (^)(void))failure;
- (void)patchUserImage:(UIImage *)image chopRect:(CGRect)chopRect success:(void (^)(NSDictionary *response))success failure:(void (^)(void))failure;

@end
