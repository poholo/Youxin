//
//  AppDelegate.m
//  youxin
//
//  Created by fei on 13-9-8.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "AppDelegate.h"

#import "WaitInfoViewController.h"
#import "ManageWaitInfoViewController.h"

#import "CarTypeViewController.h"
#import "WechatFansViewController.h"


#import "NavViewController.h"

#import "Notification.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.currentApplication = application;
    
     self.leftSideDrawerViewController = [[MMExampleSideDrawerViewController alloc] init];
    [self switchViewController:VW_TYPE_LOGIN];
    
    //消息推送
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    
    //download
    _mHttpdownload = [[HttpDownload alloc] init];
    _mHttpdownload.delegate = self;
    
    #pragma mark - 消息推送进入
//    if(!launchOptions){
//        [self notificationIn];
//    }
	
//	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//
    NSLog(@"%@",[UIApplication sharedApplication]);
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)switchViewController:(NSInteger)type{
    self.leftSideDrawerViewController.isYXdata = NO;
    switch (type) {
        case VW_TYPE_LOGIN:
        {
            self.window.rootViewController = [[NSClassFromString(@"LoginViewController") alloc] init];
        }
            break;
            
        case VW_TYPE_SAVE:{
            self.leftSideDrawerViewController.usrtype = type;
            
            WaitInfoViewController *wvc = [[WaitInfoViewController alloc] init];
            MMDrawerController *drawerController = [[MMDrawerController alloc]
                                                    initWithCenterViewController:wvc
                                                    leftDrawerViewController:self.leftSideDrawerViewController];
            _rootDrawerController = drawerController;
            
            [drawerController setMaximumLeftDrawerWidth:240.0f];
            [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
            

            
           
            
            self.window.rootViewController = drawerController;
        }
            break;
            
        case VW_TYPE_ORDER:{
            self.leftSideDrawerViewController.usrtype = type;
            
            ManageWaitInfoViewController *mavc = [[ManageWaitInfoViewController alloc] init];
    
            MMDrawerController *drawerController = [[MMDrawerController alloc]
                                                    initWithCenterViewController:mavc
                                                    leftDrawerViewController:self.leftSideDrawerViewController];

            _rootDrawerController = drawerController;
            [drawerController setMaximumLeftDrawerWidth:240.0f];
            [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
            
            
            self.window.rootViewController = drawerController;
        
        }
            break;
            
        case VW_TYPE_DIN:{
            self.leftSideDrawerViewController.usrtype = type;
            self.leftSideDrawerViewController.isYXdata = YES;
            
            WechatFansViewController *wechatFansvc = [[WechatFansViewController alloc] init];
            
            MMDrawerController *drawerController = [[MMDrawerController alloc]
                                                    initWithCenterViewController:wechatFansvc
                                                    leftDrawerViewController:self.leftSideDrawerViewController];
            _rootDrawerController = drawerController;
            
            [drawerController setMaximumLeftDrawerWidth:240.0f];
            [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        
            
            self.window.rootViewController = drawerController;
        
        }
            break; 
            
        default:
            break;
    }
}

#pragma mark - 替换中栏viewcontroller
-(void)replaceCurrentCenterViewController:(UIViewController*)vc{
    [_rootDrawerController setCenterViewController:vc withFullCloseAnimation:YES completion:nil];
}
#pragma mark - get Device token
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    NSLog(@"My token is:%@", token);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

//处理收到的消息推送
- ( void )application : (UIApplication * )application
didReceiveRemoteNotification : ( NSDictionary * )userInfo
{
    NSLog(@"%@",userInfo);
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSDictionary *dict = [userInfo objectForKey:@"aps"];
    UIAlertView *alerview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[dict objectForKey:@"alert"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alerview show];    
    
    if([UIApplication sharedApplication].applicationIconBadgeNumber==0){
        [UIApplication sharedApplication].applicationIconBadgeNumber =1;
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    
}

#pragma mark - 消息推送进入
-(void)notificationIn{

    if([UIApplication sharedApplication].applicationIconBadgeNumber==0){
        [UIApplication sharedApplication].applicationIconBadgeNumber =1;
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //打开应用  跳转到对应用户的首页
    NSString *usrnm = [[NSUserDefaults standardUserDefaults] objectForKey:@"usrnm"];
    NSString *pas = [[NSUserDefaults standardUserDefaults] objectForKey:@"pas"];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    if(pas.length<=0||usrnm.length<=0){
        return;
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"用户名或密码不能空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
    }
    else if(pas.length<=3||usrnm.length<=3){
        return;
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"用户名或密码太短！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
    }
    else{
        //post提交的参数，格式如下：
        //参数1名字=参数1数据&参数2名字＝参数2数据&参数3名字＝参数3数据&...
        NSString *post = [NSString stringWithFormat:@"iosName=%@&iosPwd=%@&parm=check&token=%@",
                          usrnm,
                          pas,
                          token];
        [_mHttpdownload downloadHomeUrl:[NSString stringWithFormat:@"%@Login.php",HOME_URL] postparm:post];
        [SVProgressHUD showWithStatus:@"登陆中..."];
        
    }


}

#pragma mark - httpdownload
-(void)downloadComplete:(HttpDownload *)hd{

    NSLog(@"complete");
    NSString *result = [[NSString alloc] initWithData:hd.mData encoding:NSUTF8StringEncoding];
    NSLog(@"user login check result:%@",result);
    
    NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"%@",resultdic);
    NSInteger status = [[resultdic objectForKey:@"status"] intValue];
    NSString *power = [resultdic objectForKey:@"power"];
    NSString *skey = [resultdic objectForKey:@"skey"];
    NSString *nontationstr = nil;
    switch (status) {
            //登陆正确
        case 1:
        {
            //保存用户数据
            [[NSUserDefaults standardUserDefaults] setObject:skey forKey:@"skey"];
            [[NSUserDefaults standardUserDefaults] setObject:[resultdic objectForKey:@"power"] forKey:@"power"];
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
            [SVProgressHUD dismissWithSuccess:@"登陆成功" afterDelay:2];
            
        }
            break;
            //用户不存在
        case 2:{
            //            nontationstr = @"用户不存在";
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆提示" message:nontationstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            //            [alert show];
            [SVProgressHUD dismissWithError:@"用户不存在" afterDelay:3];
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
        }
            break;
            //账号未启用
        case 5:{
            //            nontationstr = @"账号未启用";
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆提示" message:nontationstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            //            [alert show];
            [SVProgressHUD dismissWithError:@"账号未启用" afterDelay:3];
        }
            break;
            
            //账号已经过有效期
        case 6:{
            //            nontationstr = @"账号已经过有效期";
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆提示" message:nontationstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            //            [alert show];
            [SVProgressHUD dismissWithError:@"账号已经过有效期" afterDelay:3];
        }
            break;
        default:
            break;
    }
}
-(void)downloadError:(HttpDownload *)hd{
     [SVProgressHUD dismissWithError:@"网络处于关闭状态" afterDelay:2];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

#pragma mark - badge
-(void)refreshBadge:(int)sum{
    self.currentApplication.applicationIconBadgeNumber = sum;
}
@end
