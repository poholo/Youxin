//
//  IOS7StatusBarBlackView.m
//  youxin
//
//  Created by yuyang on 13-10-28.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "IOS7StatusBarBlackView.h"

@implementation IOS7StatusBarBlackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(UIView *)StatusBarBlackVIew
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor = [UIColor blackColor];
    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
