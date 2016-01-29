//
//  NSString+Email.m
//  Colorgy
//
//  Created by 張子晏 on 2016/1/25.
//  Copyright © 2016年 張子晏. All rights reserved.
//

#import "NSString+Email.h"

@implementation NSString (Email)

- (BOOL)isEmail{
    NSString *emailRegex = @"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:self];
    return isValid;
}

@end
