//
//  LineView.m
//  youxin
//
//  Created by fei on 13-10-10.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "LineView.h"

@implementation LineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //板子展示
        _imgvwBg = [[UIImageView alloc] initWithFrame:self.bounds];
        _srcBoard = [[UIScrollView alloc] initWithFrame:self.bounds];
        
        [self addSubview:_imgvwBg];
        [self addSubview:_srcBoard];
        
        
    }
    return self;
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
