//
//  MesViewController.m
//  youxin
//
//  Created by fei on 13-9-18.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "MesViewController.h"

@interface MesViewController ()

@end

@implementation MesViewController

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
    //0.背景板
    UIImageView *imgvwbg = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"edit_pas_bg"] stretchableImageWithLeftCapWidth:3 topCapHeight:5]];
    imgvwbg.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tgrclick)];
    [imgvwbg addGestureRecognizer:tap];
    imgvwbg.frame = self.view.frame;
    [self.view addSubview:imgvwbg];
    
    
    //1.导航
    _nav = [[UINav alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) target:self];
    _nav.lbTile.text = @"意见反馈";
    [self.view addSubview:_nav];
    
    //2.message
    UILabel *lbMes = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 100, 30)];
    lbMes.backgroundColor = [UIColor clearColor];
    lbMes.font = [UIFont boldSystemFontOfSize:16];
    lbMes.textColor = [UIColor blackColor];
    lbMes.text = @"意见建议:";
    
    [self.view addSubview:lbMes];
    
    //2.1 字数提示
    _lbCharCount =[[UILabel alloc] initWithFrame:CGRectMake(lbMes.frame.origin.x +lbMes.frame.size.width,
                                                           lbMes.frame.origin.y,
                                                           175,
                                                           lbMes.frame.size.height)];
    _lbCharCount.backgroundColor = [UIColor clearColor];
    _lbCharCount.font = [UIFont systemFontOfSize:14];
    _lbCharCount.textColor = [UIColor grayColor];
    _lbCharCount.textAlignment = UITextAlignmentRight;
    
    _lbCharCount.text = @"0/200";
    [self.view addSubview:_lbCharCount];
    
    //2.2 输入框
    _tvMes = [[UITextView alloc] initWithFrame:CGRectMake(lbMes.frame.origin.x,
                                                         lbMes.frame.origin.y + lbMes.frame.size.height,
                                                         280,
                                                         100)];
    _tvMes.text = @"欢迎您给我们提出的意见，以帮助我们做的更好！";
    _tvMes.textColor = [UIColor grayColor];
    _tvMes.font = [UIFont systemFontOfSize:15];
    _tvMes.delegate = self;
    [self.view addSubview:_tvMes];
    
    //3.联系方式
    UILabel *lbContract = [[UILabel alloc] initWithFrame:CGRectMake(_tvMes.frame.origin.x,
                                                                   _tvMes.frame.origin.y + _tvMes.frame.size.height  + 10,
                                                                   lbMes.frame.size.width,
                                                                   lbMes.frame.size.height)];
    
    lbContract.backgroundColor = [UIColor clearColor];
    lbContract.textColor = lbMes.textColor;
    lbContract.font = lbMes.font;
    lbContract.text = @"联系方式:";
    
    [self.view addSubview:lbContract];
    
    _txtPhone = [[UITextField alloc] initWithFrame:CGRectMake(lbContract.frame.origin.x,
                                                             lbContract.frame.origin.y + lbContract.frame.size.height,
                                                             280, 40)];
    _txtPhone.placeholder = @"请留下您的手机号/QQ/邮箱，以方便沟通";
    _txtPhone.borderStyle = UITextBorderStyleRoundedRect;
    _txtPhone.delegate = self;
    _txtPhone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _txtPhone.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_txtPhone];
    
    //提交
    UIButton *btnSend = [[UIButton alloc] initWithFrame:CGRectMake(_txtPhone.frame.origin.x,
                                                                  _txtPhone.frame.origin.y + _txtPhone.frame.size.height + 15,
                                                                  280, 40)];
    [btnSend setTitle:@"发  送" forState:UIControlStateNormal];
    btnSend.tag = 1;
    [btnSend setBackgroundImage:[UIImage imageNamed:@"login_nomal"] forState:UIControlStateNormal];
    [btnSend setBackgroundImage:[UIImage imageNamed:@"login_highted"] forState:UIControlStateHighlighted];
    
    
    [btnSend addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnSend];
    
    
    //net
    _mHttpdownload = [[HttpDownload alloc] init];
    _mHttpdownload.delegate = self;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            //提交信息
        case 1:{
            [SVProgressHUD show];
            // 用户id ， 留言内容 ，联系方式
            //post提交的参数，格式如下：
            //参数1名字=参数1数据&参数2名字＝参数2数据&参数3名字＝参数3数据&...
            
            if(_tvMes.text.length<=10||[_tvMes.text isEqualToString:@"欢迎您给我们提出的意见，以帮助我们做的更好！"]){
//                UIAlertView *alervw = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"输入内容太短" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alervw show];
                [SVProgressHUD dismissWithSuccess:@"输入内容太短" afterDelay:1];
            }
            else{
            
                NSString *post = [NSString stringWithFormat:
                                  @"iosName=%@&skey=%@&intro=%@&contact=%@",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"],
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"skey"],
                                  _tvMes.text,
                                  _txtPhone.text];
                [_mHttpdownload downloadHomeUrl:[NSString stringWithFormat:@"%@Feedback.php",HOME_URL] postparm:post];
            }
            
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 键盘降落
-(void)tgrclick{
    [_tvMes resignFirstResponder];
    [_txtPhone resignFirstResponder];
    
    

    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x,
                                      20, self.view.bounds.size.width,
                                      self.view.bounds.size.height);
    }];
}

#pragma mark - textdelegate 
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == _txtPhone){
        [UIView animateWithDuration:1 animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, -100, self.view.frame.size.width, self.view.frame.size.height);
        }];
        textField.returnKeyType = UIReturnKeySend;
        
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == _txtPhone){
        //return done 动作  send
        
    }
    return YES;
}


#pragma mark - text view delegate 
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if(textView == _tvMes){
        if([_tvMes.text isEqualToString:@"欢迎您给我们提出的意见，以帮助我们做的更好！"]){
            _tvMes.text = @"";
            _tvMes.textColor = [UIColor blackColor];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, 20, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if(textView== _tvMes){
        if([_tvMes.text isEqualToString:@""]){
            _tvMes.text = @"欢迎您给我们提出的意见，以帮助我们做的更好！";
            _tvMes.textColor = [UIColor grayColor];
        }
    }
}


-(void)textViewDidChange:(UITextView *)textView{
    _lbCharCount.text = [NSString stringWithFormat:@"%d/200",textView.text.length];
    int length = textView.text.length;
    if(length<=200){
        _lbCharCount.textColor = [UIColor grayColor];
    }
    else{
        _lbCharCount.textColor = [UIColor redColor];
    }
}
#pragma mark -网络


-(void)downloadComplete:(HttpDownload *)hd{
    NSLog(@"complete");
    NSString *result = [[NSString alloc] initWithData:hd.mData encoding:NSUTF8StringEncoding];
    NSLog(@"user login check result:%@",result);
    NSLog(@"%d",hd.mData.length);
    NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",resultdic);
    NSInteger status = [[resultdic objectForKey:@"status"] intValue];
    switch (status) {
        //提交成功
        case 1:
        {
//            UIAlertView *alertvw = [[UIAlertView alloc] initWithTitle:@"提交成功" message:@"感谢您的留言，我们会在第一时间联系您！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertvw show];
            [SVProgressHUD dismissWithSuccess:@"感谢您的留言，我们会在第一时间联系您！" afterDelay:2];
            _tvMes.text = @"";
            _txtPhone.text = @"";
        }
            break;
            //提交失败
        case 2:{
            [SVProgressHUD dismissWithError:@"提交失败" afterDelay:2];
//            UIAlertView *alertvw = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"提交失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertvw show];
        }
            break;
        default:
            break;
    }
    

}
-(void)downloadError:(HttpDownload *)hd{
    [SVProgressHUD dismissWithError:@"网络处于关闭状态" afterDelay:2];
}

@end
