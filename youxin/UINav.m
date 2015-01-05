//
//  UINav.m
//  youxin
//
//  Created by fei on 13-9-10.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "UINav.h"

@implementation UINav

- (id)initWithFrame:(CGRect)frame target:(id)target
{
//	if(isIOS7)
//	{
//		frame.origin.y += iOS7StatusBarHight;
//	}
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		
        self.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"nav.jpg"] stretchableImageWithLeftCapWidth:2 topCapHeight:5]];
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, 60, 30)];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"menu_normal"] forState:UIControlStateNormal];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"menu_highted"] forState:UIControlStateHighlighted];
        _backBtn.tag = 0;
        
        [_backBtn addTarget:target action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_backBtn];
        
        
        _lbTile = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        _lbTile.textAlignment = UITextAlignmentCenter;
        _lbTile.textColor = [UIColor whiteColor];
        _lbTile.backgroundColor = [UIColor clearColor];
        _lbTile.font = [UIFont boldSystemFontOfSize:20];
        
        [self addSubview:_lbTile];
    
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
