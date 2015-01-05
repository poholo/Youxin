//
//  SubCell.h
//  youxin
//
//  Created by fei on 13-9-9.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#define SUBCELL_BG_IMG_NORMAL @"cell_sub_bg"
#define SUBCELL_BG_IMG_SELECT @"nav.jpg"

#import <UIKit/UIKit.h>

@interface SubCell : UIImageView
@property (nonatomic,retain) UILabel *lbTitle;
@property (nonatomic,retain) UILabel *lbMention;
@property (nonatomic,retain) UIImageView *imgvwMetion;

@property (nonatomic,assign) BOOL *isSelect;


- (id)initWithFrame:(CGRect)frame target:(id)target tag:(NSInteger)tag sel:(SEL)sel;
@end
