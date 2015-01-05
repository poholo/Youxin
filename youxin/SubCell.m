//
//  SubCell.m
//  youxin
//
//  Created by fei on 13-9-9.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "SubCell.h"

@implementation SubCell

- (id)initWithFrame:(CGRect)frame target:(id)target tag:(NSInteger)tag sel:(SEL)sel
{
    self = [super initWithFrame:frame];
    if (self) {
        //bg
        self.image = [UIImage imageNamed:@"cell_sub_bg"];
        
        //title
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        _lbTitle.textColor = [UIColor whiteColor];
        _lbTitle.font = [UIFont systemFontOfSize:15];
        _lbTitle.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_lbTitle];
        
        //metion
        _lbMention = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 30, 20)];
        _lbMention.text  = @"new";
        _lbMention.textColor = [UIColor whiteColor];
        _lbMention.textAlignment = UITextAlignmentCenter;
        _lbMention.font = [UIFont boldSystemFontOfSize:13];
        _lbMention.backgroundColor = [UIColor clearColor];
        
        
        _imgvwMetion = [[UIImageView alloc] initWithFrame:CGRectMake(_lbTitle.frame.size.width + _lbTitle.frame.origin.x, _lbTitle.frame.origin.y, 40, 20)];
        _imgvwMetion.image = [[UIImage imageNamed:@"new"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        [_imgvwMetion addSubview:_lbMention];
        
        _imgvwMetion.hidden = YES;
        
        [self addSubview:_imgvwMetion];
        
        self.tag = tag;
        
        //点击事件
        UITapGestureRecognizer *tapgtr = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tapgtr];
        
        
        
        
        
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
