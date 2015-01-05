//
//  AlertUtils.m
//  youxin
//
//  Created by fei on 13-10-1.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "AlertUtils.h"

@implementation AlertUtils
+(void)showNetErrorAlert{
    UIAlertView *alertvw = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络质量较差" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alertvw show];
}


@end
