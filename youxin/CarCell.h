//
//  CarCell.h
//  youxin
//
//  Created by fei on 13-9-25.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#define CELL_BG_GRAY @""
#define CELL_BG_WHITE @"cell_white"
#define CELL_BG_TITLE @"cell_gray_bg"
#define CELL_BG_SELECTED @"cell_select"

#import <UIKit/UIKit.h>

@interface CarCell : UITableViewCell
@property (nonatomic,retain) UILabel *lbKey;
@property (nonatomic,retain) UILabel *lbSum;


@property (nonatomic,retain) UIImageView *imgvwBoundsLine;
@property (nonatomic,retain) NSString *bgnm;
-(void)switchbg;
@end
