//
//  LoginViewController.m
//  youxin
//
//  Created by fei on 13-9-8.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewUtils.h"
#import "UICheckbox.h"
#import "AppDelegate.h"
#import "ForgotPasViewController.h"
#import "SVProgressHUD.h"


@interface LoginViewController (){
    UITextField *txtPas;
    UITextField *txtUsrnm;
    UICheckbox *cbRemberPas;
}

@end

@implementation LoginViewController

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
    
    //1.输入框背景
    //usrnm
    UIImageView *imgvwusr = [ViewUtils createLoginTextBg:@"login_txt_bg" signnm:@"login_usrnm" origin:CGPointMake(40, 130)];
    [self.view addSubview:imgvwusr];
    
    txtUsrnm = [[UITextField alloc] initWithFrame:CGRectMake(imgvwusr.frame.origin.x+35, imgvwusr.frame.origin.y, 240-40, 40)];
    txtUsrnm.placeholder = @"用户名";
    txtUsrnm.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    txtUsrnm.delegate = self;
    

    
//    [self.view addSubview:txtUsrnm];
    
    
    
    //pas
    UIImageView *imgvwpas = [ViewUtils createLoginTextBg:@"login_txt_bg" signnm:@"login_pas" origin:CGPointMake(40, imgvwusr.frame.size.height+imgvwusr.frame.origin.y+20)];
    [self.view addSubview:imgvwpas];
    
    txtPas = [[UITextField alloc] initWithFrame:CGRectMake(imgvwpas.frame.origin.x+35, imgvwpas.frame.origin.y, 240-40, 40)];
    txtPas.secureTextEntry = YES;
    txtPas.placeholder = @"密码";
    
    txtPas.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtPas.delegate = self;

//    [self.view addSubview:txtPas];
    
    
    //复选框
    cbRemberPas = [[UICheckbox alloc] initWithUncheckImg:@"login_type_normal" checkimg:@"login_type_highted" txt:@"记住密码" point:CGPointMake(40,imgvwpas.frame.size.height+imgvwpas.frame.origin.y+12)];
    cbRemberPas.checkType = CHECK_BOX_SELECTED;
//    [self.view addSubview:cbRemberPas];
    
    
    NSLog(@"%@",[cbRemberPas subviews]);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgest)];
    bgvw.userInteractionEnabled = YES;
//    [bgvw addGestureRecognizer:tap];
    
    //忘记密码
    UILabel *lbForgetPas = [[UILabel alloc] initWithFrame:CGRectMake(cbRemberPas.frame.origin.x+160,imgvwpas.frame.size.height + imgvwpas.frame.origin.y + 15, 80, 20)];
    lbForgetPas.text = @"忘记密码？";
    lbForgetPas.backgroundColor = [UIColor clearColor];

    lbForgetPas.font = [UIFont systemFontOfSize:15];
    lbForgetPas.textColor = [UIColor whiteColor];
//    [self.view addSubview:lbForgetPas];
    
    UITapGestureRecognizer *tgrforgetPas = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPas)];
    lbForgetPas.userInteractionEnabled = YES;
    [lbForgetPas addGestureRecognizer:tgrforgetPas];
    //登陆
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame = CGRectMake(40, 160, 240, 40);
    
    [btnSave setBackgroundImage:[UIImage imageNamed:@"login_nomal"] forState:UIControlStateNormal];
    [btnSave setBackgroundImage:[UIImage imageNamed:@"login_highted"] forState:UIControlStateHighlighted];
    btnSave.tag = 0;
    [btnSave setTitle:@"救援登陆" forState:UIControlStateNormal];
    
    [btnSave addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnSave];
    
    
    //登陆
    UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogin.frame = CGRectMake(40, 220, 240, 40);
    
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"login_nomal"] forState:UIControlStateNormal];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"login_highted"] forState:UIControlStateHighlighted];
    btnLogin.tag = 1;
    [btnLogin setTitle:@"预约登陆" forState:UIControlStateNormal];
    
    [btnLogin addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnLogin];
    
    //预约登陆
    UIButton *btnData = [UIButton buttonWithType:UIButtonTypeCustom];
    btnData.frame = CGRectMake(40, 280, 240, 40);
    
    [btnData setBackgroundImage:[UIImage imageNamed:@"login_nomal"] forState:UIControlStateNormal];
    [btnData setBackgroundImage:[UIImage imageNamed:@"login_highted"] forState:UIControlStateHighlighted];
    btnData.tag = 2;
    [btnData setTitle:@"数据管理终端" forState:UIControlStateNormal];
    
    [btnData addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnData];
    
    
    
    
    //网络
    _mHttpdownload = [[HttpDownload alloc] init];
    _mHttpdownload.delegate = self;
    

   // cbRemberPas.checkType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"checktype"] intValue];
    
    
    
    //用户习惯数据
    if(cbRemberPas.checkType == CHECK_BOX_SELECTED){
        txtUsrnm.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"];
        txtPas.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"pas"];
    
    }
    
    
}

-(void)btnClick:(UIButton*)btn{
    
    switch (btn.tag) {
        case 0:
        {
            [SHAREAPP switchViewController:VW_TYPE_SAVE];
        }
        break;
        case 1:{
            [SHAREAPP switchViewController:VW_TYPE_ORDER];
        }
        break;
        case 2:{
            [SHAREAPP switchViewController:VW_TYPE_DIN];
        }
        break;
        
        default:
        break;
    }
    
    [SVProgressHUD dismissWithSuccess:[NSString stringWithFormat:@"尊敬的%@,欢迎登陆优信",
                                       [[NSUserDefaults standardUserDefaults] objectForKey:@"nikeNm"]]
                           afterDelay:3];
    return;
    NSString *usrnm = nil;
    NSString *pas = @"123456";
    switch (btn.tag) {
        case 1:
        {
            usrnm = @"w-csgs110";
        }
            break;
        case 2:{
            usrnm = @"w-csgs111";
        }
            break;
        case 3:{
            usrnm = @"w-csgs112";
        }
            break;
        default:
            break;
    }
   
        //post提交的参数，格式如下：
        //参数1名字=参数1数据&参数2名字＝参数2数据&参数3名字＝参数3数据&...
        NSString *post = [NSString stringWithFormat:@"iosName=%@&iosPwd=%@&parm=check&token=%@",
                                                    usrnm,
                                                    pas,
                                                    [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
        [_mHttpdownload downloadHomeUrl:[NSString stringWithFormat:@"%@Login.php",HOME_URL] postparm:post];
        [SVProgressHUD showWithStatus:@"登陆中..."];
    
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapgest{
    [txtUsrnm resignFirstResponder];
    [txtPas resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height);
    }];
}


#pragma mark - 忘记密码
-(void)forgetPas{
    NSLog(@"忘记密码");

    
    
    ForgotPasViewController *fvc = [[ForgotPasViewController alloc] init];
    [self presentModalViewController:fvc animated:YES];
    
}

#pragma mark - textdelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, -100, self.view.bounds.size.width, self.view.bounds.size.height);
    }];
    
    if(textField == txtUsrnm){
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyNext;
    }
    else if(textField == txtPas){
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyJoin;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == txtUsrnm){
        [txtPas becomeFirstResponder];
    }
    
    else if(textField == txtPas){
        UIButton *btn = [[UIButton alloc] init];
        [self btnClick:btn];
        [self tapgest];
    }
    
    return YES;
}


#pragma mark - net 
-(void)downloadComplete:(HttpDownload *)hd{
    NSLog(@"complete");
    NSString *result = [[NSString alloc] initWithData:hd.mData encoding:NSUTF8StringEncoding];
    NSLog(@"user login check result:%@",result);
    
    NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"%@",resultdic);
    NSInteger status = [[resultdic objectForKey:@"status"] intValue];
    NSString *power = [resultdic objectForKey:@"power"];
    NSString *skey = [resultdic objectForKey:@"skey"];
    NSString *nikeNm = [resultdic objectForKey:@"nickName"];
    NSString *dealerName = [resultdic objectForKey:@"dealerName"];
    
    int jikeSwith = [[resultdic objectForKey:@"jikeStatus"] intValue];
    
    
    
    int molest = [[resultdic objectForKey:@"molest"] intValue];
    
    NSString *nontationstr = nil;
    switch (status) {
            //登陆正确
        case 1:
        {
            //保存用户数据
            [[NSUserDefaults standardUserDefaults] setObject:skey forKey:@"skey"];
            [[NSUserDefaults standardUserDefaults] setObject:txtUsrnm.text forKey:@"usrnm"];
            [[NSUserDefaults standardUserDefaults] setObject:txtPas.text forKey:@"pas"];
            [[NSUserDefaults standardUserDefaults] setObject:[resultdic objectForKey:@"power"] forKey:@"power"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cbRemberPas.checkType] forKey:@"checktype"];
            [[NSUserDefaults standardUserDefaults] setInteger:molest forKey:@"sval"];
            
            [[NSUserDefaults standardUserDefaults] setObject:nikeNm forKey:@"nikeNm"];
            [[NSUserDefaults standardUserDefaults] setObject:dealerName forKey:@"dealerName"];
            //集客数据开关
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:jikeSwith] forKey:@"jikeSwith"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            
            
            
            
            //服务预约管理
            if([power isEqualToString:@"1,0,0"]){
                [SHAREAPP switchViewController:VW_TYPE_SAVE];
            }
            //救援服务管理
            else if([power isEqualToString:@"0,1,0"]){
                [SHAREAPP switchViewController:VW_TYPE_ORDER];
            }
            //优信数据
            else if([power isEqualToString:@"0,0,1"]){
                [SHAREAPP switchViewController:VW_TYPE_DIN];
            }
            
            
            [SVProgressHUD dismissWithSuccess:[NSString stringWithFormat:@"尊敬的%@,欢迎登陆优信",
                                               [[NSUserDefaults standardUserDefaults] objectForKey:@"nikeNm"]]
                                   afterDelay:3];
            
        }
            break;
            //用户不存在
        case 2:{
//            nontationstr = @"用户不存在";
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆提示" message:nontationstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
            [SVProgressHUD dismissWithError:@"用户不存在" afterDelay:3];
            [self cleartxt];
        }
            break;

            //密码错误
        case 3:{
//            nontationstr = @"密码错误";
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆提示" message:nontationstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
            [SVProgressHUD dismissWithError:@"密码错误" afterDelay:3];
        }
            break;
            //账号已经禁用
        case 4:{
//            nontationstr = @"账号已经禁用";
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆提示" message:nontationstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
            [SVProgressHUD dismissWithError:@"账号已经禁用" afterDelay:3];
            [self cleartxt];
        }
            break;
            //账号未启用
        case 5:{
//            nontationstr = @"账号未启用";
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆提示" message:nontationstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
            [SVProgressHUD dismissWithError:@"账号未启用" afterDelay:3];
            [self cleartxt];
        }
            break;

            //账号已经过有效期
        case 6:{
//            nontationstr = @"账号已经过有效期";
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆提示" message:nontationstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
            [SVProgressHUD dismissWithError:@"账号已经过有效期" afterDelay:3];
            [self cleartxt];
        }
            break;
        default:
            break;
    }    
}

-(void)downloadError:(HttpDownload *)hd{
    
    [SVProgressHUD dismissWithError:@"网络处于关闭状态" afterDelay:3];
//    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的网络处于关闭状态或者网络质量较差，请确保联网的环境下使用！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alertview show];
}

-(void)cleartxt{
    txtUsrnm.text = @"";
    txtPas.text =@"";
    [txtUsrnm becomeFirstResponder];
}


@end
