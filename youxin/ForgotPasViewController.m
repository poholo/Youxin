//
//  ForgotPasViewController.m
//  youxin
//
//  Created by fei on 13-10-7.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "ForgotPasViewController.h"
#import "ViewUtils.h"
#import "UIUtils.h"

@interface ForgotPasViewController ()

@end

@implementation ForgotPasViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *bgvw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lgoin_bg.jpg"]];
    bgvw.frame = self.view.bounds;
    [self.view addSubview:bgvw];
    
    UILabel *lbTitle = [UIUtils createDataTitleLabelWithFrame:CGRectMake(0, 120, 320, 30) text:@"请拨打优信客服热线重置密码:"];
    lbTitle.font = [UIFont systemFontOfSize:17];
    lbTitle.textColor = [UIColor whiteColor];
    
    [self.view addSubview:lbTitle];
    
    
    UIImageView *imgvwusr = [ViewUtils createLoginTextBg:@"login_txt_bg" signnm:@"" origin:CGPointMake(40, 165)];
    [self.view addSubview:imgvwusr];
    UILabel *lb = [UIUtils createDataSumLabelWithFrame:CGRectMake(imgvwusr.frame.origin.x,
                                                                  imgvwusr.frame.origin.y,
                                                                  imgvwusr.frame.size.width,
                                                                  imgvwusr.frame.size.height) text:@"010-51241558"];
    lb.font = lbTitle.font;
    lb.textColor = lbTitle.textColor;
    [self.view addSubview:lb];

    

    
    
    UIButton *btnCall = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCall.frame = CGRectMake(40, 230, 240, 40);
    
    [btnCall setBackgroundImage:[UIImage imageNamed:@"login_nomal"] forState:UIControlStateNormal];
    [btnCall setBackgroundImage:[UIImage imageNamed:@"login_highted"] forState:UIControlStateHighlighted];
    btnCall.tag = 1;
    [btnCall setTitle:@"呼  叫" forState:UIControlStateNormal];
    
    [btnCall addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnCall];
    
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(40, 290, 240, 40);
    
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"login_nomal"] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"login_highted"] forState:UIControlStateHighlighted];
    btnCancel.tag = 2;
    [btnCancel setTitle:@"返  回" forState:UIControlStateNormal];
    
    [btnCancel addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnCancel];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -btnclick
-(void)btnClick:(UIButton*)btn{
    switch (btn.tag) {
            //call
        case 1:{
            //需要适配
            NSString *number = @"010-51241558";// 此处读入电话号码
            
            // NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number]; //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列表
            
            
            
            NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",number]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
        
        }
            break;
            //dismiss
        case 2:
        {
            [self dismissModalViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
