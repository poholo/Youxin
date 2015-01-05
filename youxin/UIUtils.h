//
//  UIUtils.h
//  youxin
//
//  Created by fei on 13-9-29.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIUtils : NSObject
+(UILabel*)createDataTitleLabelWithFrame:(CGRect)rect text:(NSString*)text;
+(UILabel*)createDataSumLabelWithFrame:(CGRect)rect text:(NSString*)text;
+(UIImageView*)createNoInfo;
+(UILabel*)createLb:(NSString*)str oragin:(CGPoint)point color:(UIColor*)color fontSize:(float)fontSize;
@end
