//
//  EndCell.m
//  youxin
//
//  Created by fei on 13-9-9.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "EndCell.h"

@implementation EndCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _imgvwMention = [[UIImageView alloc] initWithFrame:CGRectMake(self.lb.frame.origin.x+self.lb.frame.size.width, self.lb.frame.origin.y, 40, 20)];
        _imgvwMention.image = [[UIImage imageNamed:@"new"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        
        _lbMention = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 30, 20)];
        _lbMention.text =  @"new";
        
        _lbMention.textColor = [UIColor whiteColor];
        _lbMention.textAlignment = UITextAlignmentCenter;
        _lbMention.backgroundColor = [UIColor clearColor];
        _lbMention.font = [UIFont boldSystemFontOfSize:13];
        
        [_imgvwMention addSubview:_lbMention];
        
        [self addSubview:_imgvwMention];
        
        _imgvwMention.hidden = NO;
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
