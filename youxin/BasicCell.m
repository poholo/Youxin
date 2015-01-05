//
//  BasicCell.m
//  youxin
//
//  Created by fei on 13-9-9.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "BasicCell.h"

@implementation BasicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cell_bg2"] stretchableImageWithLeftCapWidth:3 topCapHeight:10]];

//        self.backgroundView.frame = CGRectMake(0, 0, 240, 40.0f);

         
        
        
       
        _imgvwIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 15, 15)];
        [self addSubview:_imgvwIcon];
        
        _lb = [[UILabel alloc] initWithFrame:CGRectMake(_imgvwIcon.frame.origin.x+_imgvwIcon.frame.size.width + 15, _imgvwIcon.frame.origin.y-4, 100, 20)];
        _lb.textColor = [UIColor whiteColor];
        _lb.backgroundColor = [UIColor clearColor];
        _lb.font = [UIFont systemFontOfSize:15];
        
        [self addSubview:_lb];
        
        
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"nav.jpg"] stretchableImageWithLeftCapWidth:3 topCapHeight:10]];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
