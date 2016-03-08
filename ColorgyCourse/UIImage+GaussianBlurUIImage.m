//
//  UIImage+GaussianBlurUIImage.m
//  Colorgy
//
//  Created by 張子晏 on 2016/1/20.
//  Copyright © 2016年 張子晏. All rights reserved.
//

#import "UIImage+GaussianBlurUIImage.h"

@implementation UIImage (GaussianBlurUIImage)

- (UIImage *)gaussianBlurImage:(UIImage *)image andInputRadius:(CGFloat)radius {
    if (image) {
		EAGLContext *openGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		CIContext *context = [CIContext contextWithEAGLContext:openGLContext];
        CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        
        [filter setValue:inputImage forKey:kCIInputImageKey];
        [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
        
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
        
        return [UIImage imageWithCGImage:cgImage];
    }
    return nil;
}

@end
