//
//  UICheckbox.m
//  youxin
//
//  Created by fei on 13-9-8.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "UICheckbox.h"

@implementation UICheckbox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

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

-(id)initWithUncheckImg:(NSString *)uncheckimg checkimg:(NSString *)checkimg txt:(NSString *)str point:(CGPoint)point{
    if(self = [super initWithFrame:CGRectMake(point.x, point.y , 80, 25)]){
        self.uncheckImg = uncheckimg;
        self.checkedImg = checkimg;
        self.checkimgvw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:checkimg]];
        self.checkimgvw.frame =CGRectMake(0, 5, 15, 15);
        
        [self addSubview:self.checkimgvw];
        
        
        self.lb = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 60, 15)];
        self.lb.textColor = [UIColor whiteColor];
        self.lb.font = [UIFont systemFontOfSize:15];
        self.lb.text = str;
        self.lb.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.lb];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchCheck)];
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];

    }
    return self;
}

-(void)switchCheck{
    switch (self.checkType) {
        case CHECK_BOX_SELECTED:
        {
            self.checkimgvw.image = [UIImage imageNamed:self.uncheckImg];
            self.checkType = CHECK_BOX_UNSELECTED;
        }
            break;
        case CHECK_BOX_UNSELECTED:{
            self.checkimgvw.image = [UIImage imageNamed:self.checkedImg];
            self.checkType = CHECK_BOX_SELECTED;
        }
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lb.textColor = [UIColor grayColor];
    } completion:^(BOOL finished) {
        self.lb.textColor = [UIColor whiteColor];
    }];
}

@end
