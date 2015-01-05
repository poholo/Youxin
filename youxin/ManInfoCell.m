//
//  ManInfoCell.m
//  youxin
//
//  Created by fei on 13-9-12.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "ManInfoCell.h"

@implementation ManInfoCell

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
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier btnno:(NSInteger)btnsum taget:(id)target sel:(SEL)sel sel2:(SEL)sel2{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        
        UIImageView *imgvwBg = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cell_bg1"] stretchableImageWithLeftCapWidth:4 topCapHeight:10]];
        [imgvwBg setFrame:CGRectMake(5, 5, 310, 100)];
        [self addSubview:imgvwBg];
        //time
        self.lbTime = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 160, 30)];
        self.lbTime.textColor = [UIColor grayColor];
        
        self.lbTime.backgroundColor = [UIColor clearColor];
        self.lbTime.font = [UIFont boldSystemFontOfSize:15];
        
        [self addSubview:self.lbTime];
        
        //处理状态
        self.lbStatus = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 140, 30)];
        self.lbStatus.textColor = [UIColor redColor];
        self.lbStatus.backgroundColor = [UIColor clearColor];
        self.lbStatus.text = STATUS_DEFANUT;
        self.lbStatus.textAlignment = UITextAlignmentRight;
        
        self.lbStatus.font = FONT_DEFAUT;
        
        [self addSubview:self.lbStatus];
        
        //电话
        self.imgvwPhone= [[UIImageView alloc] initWithFrame:CGRectMake(15, self.lbTime.frame.origin.y + self.lbTime.frame.size.height +10, 20, 20)];
        self.imgvwPhone.image = [UIImage imageNamed:@"phone"];
        
        [self addSubview:self.imgvwPhone];
               
        self.lbPhoneno = [[UILabel alloc] initWithFrame:CGRectMake(self.imgvwPhone.frame.origin.x+self.imgvwPhone.frame.size.width-10, self.imgvwPhone.frame.origin.y-5, 130, 30)];
        self.lbPhoneno.textColor = [UIColor blackColor];
        self.lbPhoneno.font = [UIFont systemFontOfSize:20];
        self.lbPhoneno.backgroundColor = [UIColor clearColor];
        self.lbPhoneno.textAlignment = UITextAlignmentRight;
        self.lbPhoneno.font = FONT_DEFAUT;
        
        [self addSubview:self.lbPhoneno];
        
        
        
        //导航
        _btnLbs = [[UIButton alloc] initWithFrame:CGRectMake(self.lbPhoneno.frame.origin.x + self.lbPhoneno.frame.size.width +40, self.lbPhoneno.frame.origin.y, 20, 20)];
        
        [_btnLbs setBackgroundImage:[UIImage imageNamed:@"btn_lbs_normal"] forState:UIControlStateNormal];
        
        //default
        _btnLbs.tag =3;
        [_btnLbs addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_btnLbs];
        
        _lbLbsText = [[UILabel alloc] initWithFrame:CGRectMake(_btnLbs.frame.origin.x + _btnLbs.frame.size.width +5, _btnLbs.frame.origin.y, 100, 20)];
        _lbLbsText.backgroundColor = [UIColor clearColor];
        _lbLbsText.font = [UIFont systemFontOfSize:20];
        _lbLbsText.text = @"查看位置";
        _lbLbsText.textColor = [UIColor grayColor];
        [self addSubview:_lbLbsText];
        
        _lbLbsText.userInteractionEnabled = YES;
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel2];
        tgr.numberOfTapsRequired=1;
        [_lbLbsText addGestureRecognizer:tgr];
        //btn
        
        for(int i =0;i<=btnsum;i++){
            [self addbtn:i target:target sel:sel];
        }
        
    }
    return self;
    
}

-(void)addbtn:(NSInteger)no target:(id)target sel:(SEL)sel{
    if(no==0){
        self.btnCall = [[UIButton alloc] initWithFrame:CGRectMake(self.imgvwPhone.frame.origin.x,self.imgvwPhone.frame.origin.y + self.imgvwPhone.frame.size.height +8, 65, 27)];
        [self.btnCall setBackgroundImage:[UIImage imageNamed:@"call_normal"] forState:UIControlStateNormal];
        [self.btnCall setBackgroundImage:[UIImage imageNamed:@"call_highted"] forState:UIControlStateHighlighted];
        
        [self.btnCall addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        
        self.btnCall.tag = 0;
        [self addSubview:self.btnCall];
    }
    else if(no==1){
        self.btnDis = [[UIButton alloc] initWithFrame:CGRectMake(self.btnCall.frame.origin.x +self.btnCall.frame.size.width+85, self.btnCall.frame.origin.y, self.btnCall.frame.size.width,self.btnCall.frame.size.height)];
        [self.btnDis setBackgroundImage:[UIImage imageNamed:@"btn_abanden_normal"] forState:UIControlStateNormal];
        [self.btnDis setBackgroundImage:[UIImage imageNamed:@"btn_abanden_highted"] forState:UIControlStateHighlighted];
        
        [self.btnDis addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        
        self.btnDis.tag = 1;
        
        [self addSubview:self.btnDis];
    }
    else if(no==2){
        self.btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake(self.btnDis.frame.origin.x + self.btnDis.frame.size.width + 10, self.btnDis.frame.origin.y, self.btnDis.frame.size.width, self.btnDis.frame.size.height)];
        [self.btnConfirm setBackgroundImage:[UIImage imageNamed:@"btn_confirm_normal"] forState:UIControlStateNormal];
        [self.btnConfirm setBackgroundImage:[UIImage imageNamed:@"btn_confirm_highted"] forState:UIControlStateHighlighted];
        
        [self.btnConfirm addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        self.btnConfirm.tag = 2;
        
        [self addSubview:self.btnConfirm];
    }
}

@end
