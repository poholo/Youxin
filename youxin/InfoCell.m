//
//  InfoCell.m
//  youxin
//
//  Created by fei on 13-9-11.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "InfoCell.h"


@implementation InfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier btnno:(NSInteger)btnsum taget:(id)target sel:(SEL)sel
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //bg 
        
        UIImageView *imgvwBg = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cell_bg1"] stretchableImageWithLeftCapWidth:4 topCapHeight:10]];
        [imgvwBg setFrame:CGRectMake(5, 5, 310, 100)];
        [self addSubview:imgvwBg];
        //time
        _lbTime = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 200, 30)];
        _lbTime.textColor = [UIColor grayColor];
        
        _lbTime.backgroundColor = [UIColor clearColor];
        _lbTime.font = [UIFont boldSystemFontOfSize:15];

        [self addSubview:_lbTime];
        
        //处理状态
        _lbStatus = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 140, 30)];
        _lbStatus.textColor = [UIColor redColor];
        _lbStatus.backgroundColor = [UIColor clearColor];
        _lbStatus.text = STATUS_DEFANUT;
        _lbStatus.textAlignment = UITextAlignmentRight;
        
        _lbStatus.font = FONT_DEFAUT;
        
        [self addSubview:_lbStatus];
        
        //name
        _lbnm = [[UILabel alloc] initWithFrame:CGRectMake(_lbTime.frame.origin.x, _lbTime.frame.origin.y+_lbTime.frame.size.height, 160, 30)];
        _lbnm.backgroundColor = [UIColor clearColor];
        _lbnm.textColor = [UIColor blackColor];
        _lbnm.font = FONT_DEFAUT;
        
        [self addSubview:_lbnm];
        
        //电话
         _imgvwPhone= [[UIImageView alloc] initWithFrame:CGRectMake(160, _lbnm.frame.origin.y+5, 20, 20)];
        _imgvwPhone.image = [UIImage imageNamed:@"phone"];
        
        [self addSubview:_imgvwPhone];
        
        _lbPhoneno = [[UILabel alloc] initWithFrame:CGRectMake(_imgvwPhone.frame.origin.x+_imgvwPhone.frame.size.width-10, _imgvwPhone.frame.origin.y-5, 130, 30)];
        _lbPhoneno.textColor = [UIColor blackColor];
        _lbPhoneno.font = _lbnm.font;
        _lbPhoneno.backgroundColor = [UIColor clearColor];
        _lbPhoneno.textAlignment = UITextAlignmentRight;
        _lbPhoneno.font = FONT_DEFAUT;
        
        [self addSubview:_lbPhoneno];
        
        //btn
        
        for(int i =0;i<=btnsum;i++){
            [self addbtn:i target:target sel:sel];
        }
        
        
        
        
        
    }
    return self;
}

-(void)addbtn:(NSInteger)no target:(id)target sel:(SEL)sel{
    if(no==0){
        _btnCall = [[UIButton alloc] initWithFrame:CGRectMake(_lbnm.frame.origin.x,_lbnm.frame.origin.y + _lbnm.frame.size.height +8, 65, 27)];
        [_btnCall setBackgroundImage:[UIImage imageNamed:@"call_normal"] forState:UIControlStateNormal];
        [_btnCall setBackgroundImage:[UIImage imageNamed:@"call_highted"] forState:UIControlStateHighlighted];
        
        [_btnCall addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        
        _btnCall.tag = 0;
        [self addSubview:_btnCall];
    }
    else if(no==1){
        _btnDis = [[UIButton alloc] initWithFrame:CGRectMake(_btnCall.frame.origin.x +_btnCall.frame.size.width+85, _btnCall.frame.origin.y, _btnCall.frame.size.width,_btnCall.frame.size.height)];
        [_btnDis setBackgroundImage:[UIImage imageNamed:@"btn_abanden_normal"] forState:UIControlStateNormal];
        [_btnDis setBackgroundImage:[UIImage imageNamed:@"btn_abanden_highted"] forState:UIControlStateHighlighted];
        
        [_btnDis addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        
        _btnDis.tag = 1;
        
        [self addSubview:_btnDis];
    }
    else if(no==2){
        _btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake(_btnDis.frame.origin.x + _btnDis.frame.size.width + 10, _btnDis.frame.origin.y, _btnDis.frame.size.width, _btnDis.frame.size.height)];
        [_btnConfirm setBackgroundImage:[UIImage imageNamed:@"btn_confirm_normal"] forState:UIControlStateNormal];
        [_btnConfirm setBackgroundImage:[UIImage imageNamed:@"btn_confirm_highted"] forState:UIControlStateHighlighted];
        [_btnConfirm addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        _btnConfirm.tag = 2;
        
        [self addSubview:_btnConfirm];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
