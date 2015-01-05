//
//  UIUtils.m
//  youxin
//
//  Created by fei on 13-9-29.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "UIUtils.h"

@implementation UIUtils
+(UILabel *)createDataTitleLabelWithFrame:(CGRect)rect text:(NSString *)text{
    
    UILabel * lb = [[UILabel alloc] initWithFrame:rect];
    lb.textAlignment = UITextAlignmentCenter;
    lb.backgroundColor =[UIColor clearColor];
    lb.font  = [UIFont systemFontOfSize:15];
    lb.text = text;
    
    return lb;
}

+(UILabel *)createDataSumLabelWithFrame:(CGRect)rect text:(NSString *)text{
    
    UILabel *lbsum = [[UILabel alloc] initWithFrame:rect];
    lbsum.backgroundColor = [UIColor clearColor];
    lbsum.textAlignment = UITextAlignmentCenter;
    
    lbsum.font = [UIFont systemFontOfSize:25];
    lbsum.text = text;
    
    return lbsum;

}


+(UIImageView *)createNoInfo{
    UIImageView *imgvw =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_info"]];
    imgvw.frame = CGRectMake(90, 150, 140, 150);
    
    imgvw.hidden = YES;
    return imgvw;
}
+(UILabel*)createLb:(NSString *)str oragin:(CGPoint)point color:(UIColor*)color fontSize:(float)fontSize{
    float lenth = [str length]*25;
    NSLog(@"length = %f",lenth);
    UILabel *lb= [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, lenth, 25)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont boldSystemFontOfSize:fontSize];
    lb.text = str;
    lb.textColor = color;
    
    return lb;
}
@end
