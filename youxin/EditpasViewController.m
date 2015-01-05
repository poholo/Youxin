//
//  EditpasViewController.m
//  youxin
//
//  Created by fei on 13-9-18.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "EditpasViewController.h"
#import "AppDelegate.h"

@interface EditpasViewController ()

@end

@implementation EditpasViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"edit_pas_bg"] stretchableImageWithLeftCapWidth:3 topCapHeight:5]];
    
    UIImageView *imgvwbg = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"edit_pas_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    imgvwbg.frame = self.view.frame;
    imgvwbg.userInteractionEnabled = YES;
    [self.view addSubview:imgvwbg];
    
    //1.导航条
    _nav = [[UINav alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44) target:self];
    _nav.lbTile.text = @"修改密码";
    [self.view addSubview:_nav];
    
    
    //2.原来密码
    UILabel *lbBeforepas = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 280, 30)];
    lbBeforepas.text = @"原来密码:";
    
    lbBeforepas.textColor = [UIColor blackColor];
    lbBeforepas.font = [UIFont boldSystemFontOfSize:16];
    lbBeforepas.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:lbBeforepas];
    
    
    _txtBeforepas = [[UITextField alloc] initWithFrame:CGRectMake(lbBeforepas.frame.origin.x,
                                                                  lbBeforepas.frame.origin.y + lbBeforepas.frame.size.height+3,
                                                                  280,
                                                                  40)];
    _txtBeforepas.borderStyle = UITextBorderStyleRoundedRect;
    _txtBeforepas.secureTextEntry = YES;
    _txtBeforepas.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _txtBeforepas.delegate = self;
    
    [self.view addSubview:_txtBeforepas];
    
    //3.新密码
    UILabel *lbNewpas = [[UILabel alloc] initWithFrame:CGRectMake(_txtBeforepas.frame.origin.x,
                                                                  _txtBeforepas.frame.size.height + _txtBeforepas.frame.origin.y + 10, _txtBeforepas.frame.size.width,
                                                                  _txtBeforepas.frame.size.height)];
    lbNewpas.textColor = lbBeforepas.textColor;
    lbNewpas.text = @"新密码:";
    lbNewpas.backgroundColor = lbBeforepas.backgroundColor;
    lbNewpas.font = lbBeforepas.font;
    
    [self.view addSubview:lbNewpas];
    
    _txtNewPas =[[UITextField alloc] initWithFrame:CGRectMake(lbNewpas.frame.origin.x,
                                                             lbNewpas.frame.origin.y + lbNewpas.frame.size.height + 3,
                                                             _txtBeforepas.bounds.size.width,
                                                              _txtBeforepas.bounds.size.height)];
    _txtNewPas.secureTextEntry = YES;
    _txtNewPas.borderStyle = _txtBeforepas.borderStyle;
    _txtNewPas.delegate = self;
    _txtNewPas.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.view addSubview:_txtNewPas];
    
    
    
    //4.重复密码
    UILabel *lbReNewPas = [[UILabel alloc] initWithFrame:CGRectMake(_txtNewPas.frame.origin.x,
                                                                   _txtNewPas.frame.origin.y + _txtNewPas.frame.size.height +10,
                                                                   _txtNewPas.bounds.size.width,
                                                                   _txtNewPas.bounds.size.height)];
    lbReNewPas.backgroundColor = lbNewpas.backgroundColor;
    lbReNewPas.font = lbNewpas.font;
    lbReNewPas.textColor = lbNewpas.textColor;
    
    
    lbReNewPas.text = @"确认密码:";
    [self.view addSubview:lbReNewPas];
    
    _txtReNewPas = [[UITextField alloc] initWithFrame:CGRectMake(lbReNewPas.frame.origin.x,
                                                                lbReNewPas.frame.origin.y + lbReNewPas.frame.size.height + 3,
                                                                 _txtNewPas.frame.size.width,
                                                                _txtNewPas.frame.size.height)];
    _txtReNewPas.secureTextEntry = YES;
    _txtReNewPas.borderStyle = _txtNewPas.borderStyle;
    _txtReNewPas.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _txtReNewPas.delegate = self;

    [self.view addSubview:_txtReNewPas];
    
    //提交修改
    _btnSave = [[UIButton alloc] initWithFrame:CGRectMake(_txtReNewPas.frame.origin.x,
                                                         _txtReNewPas.frame.origin.y + _txtReNewPas.frame.size.height +20,
                                                         _txtReNewPas.frame.size.width,
                                                          _txtReNewPas.frame.size.height + 10)];
    
    [_btnSave setTitle:@"保  存" forState:UIControlStateNormal];
    _btnSave.tag = 1;
    [_btnSave setBackgroundImage:[UIImage imageNamed:@"login_nomal"] forState:UIControlStateNormal];
    [_btnSave setBackgroundImage:[UIImage imageNamed:@"login_highted"] forState:UIControlStateHighlighted];
    
    
    [_btnSave addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btnSave];
    
    
    //背景触摸事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboarddown)];
    [imgvwbg addGestureRecognizer:tap];
    
    
    //网络 进入请求网络最新的一页
    _mHttpdownload = [[HttpDownload alloc] init];
    _mHttpdownload.delegate = self;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 触摸背景促使键盘降落
-(void)keyboarddown{
    [self.txtBeforepas resignFirstResponder];
    [self.txtNewPas resignFirstResponder];
    [self.txtReNewPas resignFirstResponder];
    
    //view frame回复正常
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.frame.size.height);
    }];
    
}

#pragma mark - textfiled响应事件
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect currentRect ;
    if(textField == _txtBeforepas){
        currentRect = CGRectMake(self.view.frame.origin.x, -44, self.view.frame.size.width, self.view.frame.size.height);
        textField.returnKeyType = UIReturnKeyNext;
    }
    else if(textField == _txtNewPas){
        currentRect = CGRectMake(self.view.frame.origin.x, -100, self.view.frame.size.width, self.view.frame.size.height);
        textField.returnKeyType = UIReturnKeyNext;
    }
    else if(textField == _txtReNewPas){
        currentRect = CGRectMake(self.view.frame.origin.x, -150, self.view.frame.size.width, self.view.frame.size.height);
        textField.returnKeyType = UIReturnKeyDone;
    }
    
    [UIView animateWithDuration:1 animations:^{
        self.view.frame = currentRect;
    }];
}

#pragma mark  - textfiled 响应事件返回
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == _txtBeforepas){
        [_txtNewPas becomeFirstResponder];
    
    }
    else if(textField == _txtNewPas){
        [_txtReNewPas becomeFirstResponder];
    }
    else if(textField == _txtReNewPas){
        //提交
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = 1;
        [self btnClick:btn];
    }
    
    return YES;
}


#pragma mark - btnclick
-(void)btnClick:(UIButton*)btn{
    switch (btn.tag) {
            //返回主菜单
        case 0:
        {
            [self dismissModalViewControllerAnimated:YES];
        }
            break;
        //修改密码
        case 1:{
            [SVProgressHUD show];
            //用户id 原来的密码 ， 新密码
            
            if(_txtBeforepas.text.length == 0 || _txtNewPas.text.length == 0 || _txtReNewPas.text.length == 0){
               [SVProgressHUD dismissWithError:@"新旧密码不能为空" afterDelay:2];
//                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"新旧密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alertview show];
            }
            else if(_txtBeforepas.text.length<6 || _txtNewPas.text.length<6 || _txtReNewPas.text.length <6){
//                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"密码长度至少需要6位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alertview show];
                [SVProgressHUD dismissWithError:@"密码长度至少需要6位" afterDelay:2];
            }
            else if(![_txtReNewPas.text isEqualToString:_txtNewPas.text]){
//                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"两次密码不一样" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                
//                [alertview show];
                [SVProgressHUD dismissWithError:@"两次密码不一样" afterDelay:2];
            }
            else if([_txtNewPas.text isEqualToString:_txtReNewPas.text]){
                NSString *post = [NSString stringWithFormat:
                                  @"iosName=%@&skey=%@&oldPwd=%@&newPwd=%@&parm=modPwd",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                                  _txtBeforepas.text,
                                  _txtNewPas.text];
                NSString *home_usr = [NSString stringWithFormat:@"%@Login.php",HOME_URL];
                
                [_mHttpdownload downloadHomeUrl:home_usr postparm:post];
                
                NSLog(@"home_usr%@",home_usr);
                NSLog(@"post - %@",post);
                
                
            }
            
            
        }
        default:
            break;
    }
}

#pragma mark - httpdownloaddelgate
-(void)downloadComplete:(HttpDownload *)hd{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dict);
    NSInteger status = [[dict objectForKey:@"status"] intValue];
    switch (status) {
            //修改成功
        case 1:
        {
            [SVProgressHUD dismissWithSuccess:@"密码修改成功" afterDelay:1];
//            UIAlertView *alervw = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"密码修改成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
//            [alervw show];
            [[NSUserDefaults standardUserDefaults] setObject:_txtNewPas.text forKey:@"pas"];
            [SHAREAPP switchViewController:VW_TYPE_LOGIN];
            
        }
            break;
            //修改失败
        case 2:{
            [SVProgressHUD dismissWithSuccess:@"旧密码不正确，请联系客服人员！" afterDelay:1];
//            UIAlertView *alervw = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"旧密码不正确，请联系客服人员！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
//            [alervw show];
        }
            break;
        default:
            break;
    }
    
    
}
-(void)downloadError:(HttpDownload *)hd{
    [SVProgressHUD dismissWithError:@"网络处于关闭状态" afterDelay:1];
}


@end
