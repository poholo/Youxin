//
//  MentionCell.m
//  youxin
//
//  Created by fei on 13-10-14.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "MentionCell.h"

@implementation MentionCell

-(id)initWithFrame:(CGRect)frame target:(id)target tag:(NSInteger)tag sel:(SEL)sel{
    self = [super initWithFrame:frame];
    if (self) {
        //bg
        self.image = [UIImage imageNamed:@"cell_sub_bg"];
        
        //title
        self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        self.lbTitle.textColor = [UIColor whiteColor];
        self.lbTitle.font = [UIFont systemFontOfSize:15];
        self.lbTitle.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.lbTitle];
        
        
        
        self.imgvwMetion = [[UIImageView alloc] initWithFrame:CGRectMake(self.lbTitle.frame.size.width + self.lbTitle.frame.origin.x + 30,
                                                                         self.lbTitle.frame.origin.y,
                                                                         40,
                                                                         20)];
        [self.imgvwMetion addSubview:self.lbMention];
        
        
        [self addSubview:self.imgvwMetion];
        
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
