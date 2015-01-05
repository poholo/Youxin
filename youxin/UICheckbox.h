//
//  UICheckbox.h
//  youxin
//
//  Created by fei on 13-9-8.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#define CHECK_BOX_SELECTED   1
#define CHECK_BOX_UNSELECTED 0

#import <UIKit/UIKit.h>

@interface UICheckbox : UIView
@property (nonatomic,assign) NSInteger checkType;
@property (nonatomic,retain) NSString *uncheckImg;
@property (nonatomic,retain) NSString *checkedImg;
@property (nonatomic,retain) UIImageView *checkimgvw;
@property (nonatomic,retain) UILabel *lb;

-(id)initWithUncheckImg:(NSString*)uncheckimg checkimg:(NSString*)checkimg txt:(NSString*)str point:(CGPoint)point;
-(void)switchCheck;
@end
