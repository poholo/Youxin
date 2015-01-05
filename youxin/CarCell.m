//
//  CarCell.m
//  youxin
//
//  Created by fei on 13-9-25.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "CarCell.h"

@implementation CarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.bgnm]];
        _lbKey = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 170, 15)];
        _lbKey.backgroundColor = [UIColor clearColor];
        _lbKey.font = [UIFont systemFontOfSize:15];
        
        
        [self addSubview:_lbKey];
        
        
        _lbSum = [[UILabel alloc] initWithFrame:CGRectMake(_lbKey.frame.origin.x + _lbKey.frame.size.width, _lbKey.frame.origin.y, 100, _lbKey.frame.size.height)];
        _lbSum.backgroundColor = [UIColor clearColor];
        _lbSum.font = _lbKey.font;
        
        [self addSubview:_lbSum];
        
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CELL_BG_SELECTED]];
        
        //分割线
        UIImageView *v1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
        v1.frame = CGRectMake(0, 0, 1, 30);
        [self addSubview:v1];
        
        UIImageView *v2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
        v2.frame = CGRectMake(170, 0, 1, 30);
        [self addSubview:v2];
        
        
        UIImageView *v3= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
        v3.frame = CGRectMake(299, 0, 1, 30);
        [self addSubview:v3];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)switchbg{
    self.backgroundView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.bgnm]];
}

@end
