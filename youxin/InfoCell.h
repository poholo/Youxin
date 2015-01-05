//
//  InfoCell.h
//  youxin
//
//  Created by fei on 13-9-11.
//  Copyright (c) 2013年 mjc. All rights reserved.
//



#define FONT_DEFAUT [UIFont systemFontOfSize:20]


#define COLOR_CONFIRM [UIColor colorWithRed:60.0/255 green:169.0/255 blue:2.0/255 alpha:1.0f]
#define COLOR_DEFAULT [UIColor blackColor]

#import <UIKit/UIKit.h>

@interface InfoCell : UITableViewCell
@property (nonatomic,retain) UILabel *lbTime;
@property (nonatomic,retain) UILabel *lbStatus;
@property (nonatomic,retain) UILabel *lbnm;
@property (nonatomic,retain) UIImageView *imgvwPhone;
@property (nonatomic,retain) UILabel *lbPhoneno;
@property (nonatomic,retain) UIButton *btnCall;
@property (nonatomic,retain) UIButton *btnDis;
@property (nonatomic,retain) UIButton *btnConfirm;

@property (nonatomic,retain) NSString *identify;
@property (nonatomic,retain) NSIndexPath *indexpath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier btnno:(NSInteger)btnsum taget:(id)target sel:(SEL)sel;
-(void)addbtn:(NSInteger)no target:(id)target sel:(SEL)sel;
@end
