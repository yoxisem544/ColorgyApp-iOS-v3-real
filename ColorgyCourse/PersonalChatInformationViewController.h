//
//  PersonalChatInformationViewController.h
//  ColorgyCourse
//
//  Created by 張子晏 on 2016/2/2.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalChatInformationViewController : UIViewController<UITextFieldDelegate, UIImagePickerControllerDelegate>
@property UITextField *activeTextField;
@property UIImage *uploadImage;
@end
