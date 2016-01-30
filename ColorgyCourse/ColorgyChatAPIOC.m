//
//  ColorgyChatAPIOC.m
//  ColorgyCourse
//
//  Created by 張子晏 on 2016/1/28.
//  Copyright © 2016年 David. All rights reserved.
//

#import "ColorgyChatAPIOC.h"
#import "AFNetworking.h"
#import "NSString+Email.h"
#import "ColorgyCourse-Swift.h"

@implementation ColorgyChatAPIOC

- (void)test {
}

- (void)preloadInformation:(void (^)(NSDictionary *))success failure:(void (^)(void))failure {
    [ColorgyChatAPI getQuestion:^(NSDictionary *response) {
        self.todayQuestion = [response valueForKey:@"question"];
        if (success) {
            success(response);
        }
    } failure:failure];
}

- (void)getQuestion:(void (^)(NSString *))success failure:(void (^)(void))failure {
    [ColorgyChatAPI getQuestion:^(NSDictionary *response) {
        self.todayQuestion = [response valueForKey:@"question"];
        if (success) {
            success(self.todayQuestion);
        }
    } failure:failure];
}

- (void)postEmail:(NSString *)email success:(void (^)(NSDictionary *response))success failure:(void (^)(void))failure {
    [ColorgyAPI POSTUserEmail:email success:^(NSDictionary *response) {
        if(success) {
            success(response);
        }
    } failure:^() {
        if(failure) {
            failure();
        }
    }];
}

- (void)patchUserImage:(UIImage *)image chopRect:(CGRect)chopRect success:(void (^)(NSDictionary *response))success failure:(void (^)(void))failure {
    NSString *avatar = [NSString stringWithFormat:@"data:image/png;base64,%@", [self encodeToBase64String:image]];
    
    [ColorgyAPI PATCHUserImage:avatar avatar_crop_x:chopRect.origin.x avatar_crop_y:chopRect.origin.y avatar_crop_w:chopRect.size.width avatar_crop_h:chopRect.size.height success:^(NSDictionary *response){
        if (success) {
            success(response);
        }
    } failure:^() {
        if (failure) {
            failure();
        }
    }];
}

- (void)postChatUserNamer:(NSString *)name successs:(void (^) (NSDictionary *response))success failure:(void (^)(void))failure {
}

#pragma mark - Base64

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
