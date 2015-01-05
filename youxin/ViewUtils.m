//
//  ViewUtils.m
//  youxin
//
//  Created by fei on 13-9-8.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "ViewUtils.h"

@implementation ViewUtils
+(UIImageView *)createLoginTextBg:(NSString *)bgpicnm signnm:(NSString *)signm origin:(CGPoint)point{
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, 240, 40)];
    UIImage *img = [[UIImage imageNamed:bgpicnm] stretchableImageWithLeftCapWidth:5 topCapHeight:10];
    bg.image = img;
    
    UIImageView *imgvwsign = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 25)];
    img = [UIImage imageNamed:signm];
    imgvwsign.image = img;
    
    [bg addSubview:imgvwsign];
    
    return bg;
}

+(UIView*)createDataBoard{
    int width = 13;
    int height = 232;
    UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(320-width, 150, width, height)];
    vw.backgroundColor = [UIColor whiteColor];
    
    return vw;
    
}
@end
