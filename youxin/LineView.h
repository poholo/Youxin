//
//  LineView.h
//  youxin
//
//  Created by fei on 13-10-10.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineView : UIView
//坐标轴
@property (nonatomic,retain) UIImageView *imgvwBg;

//折线数据展示板
@property (nonatomic,retain) UIScrollView *srcBoard;

//x y 显示板
@property (nonatomic,retain) NSArray *xLbArr;
@property (nonatomic,retain) NSArray *yLbArr;

//x y数据
@property (nonatomic,retain) NSArray *xArr;
@property (nonatomic,retain) NSArray *yArr;

@property (nonatomic,assign) float xOffset;
@property (nonatomic,assign) float yOffset;

-(void)drawRect:(CGRect)rect;


@end
