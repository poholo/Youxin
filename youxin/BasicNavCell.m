//
//  BasicNavCell.m
//  youxin
//
//  Created by fei on 13-9-11.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "BasicNavCell.h"

@implementation BasicNavCell

- (id)initWithFrame:(CGRect)frame target:(id)target sel:(SEL)sel
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _imgvwIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 20, 20)];
        [self addSubview:_imgvwIcon];
        
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(_imgvwIcon.frame.origin.x+_imgvwIcon.frame.size.width + 15, _imgvwIcon.frame.origin.y, 100, 20)];
        _lbTitle.textColor = [UIColor whiteColor];
        _lbTitle.backgroundColor = [UIColor clearColor];
        _lbTitle.font = [UIFont systemFontOfSize:15];
        
        [self addSubview:_lbTitle];
        
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
        [self addGestureRecognizer:tgr];
        
        
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
