//
//  UIImage+GaussianBlurUIImage.h
//  Colorgy
//
//  Created by 張子晏 on 2016/1/20.
//  Copyright © 2016年 張子晏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GaussianBlurUIImage)

- (UIImage *)gaussianBlurImage:(UIImage *)image andInputRadius:(CGFloat)radius;

@end
