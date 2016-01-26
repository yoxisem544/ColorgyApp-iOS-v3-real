//
//  ImageCache.h
//  
//
//  Created by 張子晏 on 2016/1/26.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageCache : NSObject

@property (nonatomic, retain) NSCache *imgCache;

+ (ImageCache *)sharedImageCache;
- (void)addImage:(NSString *)imageURL image:(UIImage *)image;
- (UIImage *)getImage:(NSString *)imageURL;
- (BOOL)doesExist:(NSString *)imageURL;

@end
