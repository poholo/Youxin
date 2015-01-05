//
//  UINav.h
//  youxin
//
//  Created by fei on 13-9-10.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINav : UIView
@property (nonatomic,retain) UIButton *backBtn;
@property (nonatomic,readonly) UILabel *lbTile;
- (id)initWithFrame:(CGRect)frame target:(id)target;
@end
