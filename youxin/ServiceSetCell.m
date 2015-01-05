//
//  ServiceSetCell.m
//  youxin
//
//  Created by fei on 13-9-9.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "ServiceSetCell.h"
#import "SubCell.h"
@implementation ServiceSetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier subarr:(NSArray*)subarr show:(BOOL)isShow
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgvwDis = [[UIImageView alloc] initWithFrame:CGRectMake(self.lb.frame.size.width + self.lb.frame.origin.x + 50, self.lb.frame.origin.y+5, 10, 10)];
        _imgvwDis.image = [UIImage imageNamed:CELL_CLOSE];
        
        [self addSubview:_imgvwDis];
        _arr = subarr;
        for(id obj in _arr){
            [self addSubview:obj];
        }
    [self showSubCell:isShow];

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


-(void)showSubCell:(BOOL)isShow{
    for(SubCell * subcell in _arr){
        subcell.hidden = !isShow;
    }
}
@end
