//
//  AppDelegate.h
//  youxin
//
//  Created by fei on 13-9-8.
//  Copyright (c) 2013年 mjc. All rights reserved.
//


/*
 
 $deviceToken= '2bf6e8f97942b07e3dd790d70f52x18a4d50338b5bb00f6f14d8bb6f775a6d98'; //没有空格
 $body = array("aps" => array("alert" => 'message',"badge" => 2,"sound"=>'default'));  //推送方式，包含内容和声音
 $ctx = stream_context_create();
 //如果在Windows的服务器上，寻找pem路径会有问题，路径修改成这样的方法：
 //$pem = dirname(__FILE__) . '/' . 'apns-dev.pem';
 //linux 的服务器直接写pem的路径即可
 stream_context_set_option($ctx,"ssl","local_cert","apns-dev.pem");
 $pass = "xxxxxx";
 stream_context_set_option($ctx, 'ssl', 'passphrase', $pass);
 //此处有两个服务器需要选择，如果是开发测试用，选择第二名sandbox的服务器并使用Dev的pem证书，如果是正是发布，使用Product的pem并选用正式的服务器
 $fp = stream_socket_client("ssl://gateway.push.apple.com:2195", $err, $errstr, 60, STREAM_CLIENT_CONNECT, $ctx);
 $fp = stream_socket_client("ssl://gateway.sandbox.push.apple.com:2195", $err, $errstr, 60, STREAM_CLIENT_CONNECT, $ctx);
 if (!$fp) {
 echo "Failed to connect $err $errstrn";
 return;
 }
 print "Connection OK\n";
 $payload = json_encode($body);
 $msg = chr(0) . pack("n",32) . pack("H*", str_replace(' ', '', $deviceToken)) . pack("n",strlen($payload)) . $payload;
 echo "sending message :" . $payload ."\n";
 fwrite($fp, $msg);
 fclose($fp);
 
 */

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
#import "MMExampleSideDrawerViewController.h"
#import "HttpDownload.h"

#define VW_TYPE_LOGIN 0
#define VW_TYPE_SAVE 1
#define VW_TYPE_ORDER 2
#define VW_TYPE_DIN 3

#define SHAREAPP ((AppDelegate*)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,HttpdownloadDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign) BOOL isOpenNoti;
@property (nonatomic,retain) UIApplication *currentApplication;
@property (nonatomic,retain) HttpDownload *mHttpdownload;
-(void)switchViewController:(NSInteger)type;


//当前抽屉导航器，用来替换中栏viewcontroller
@property (nonatomic,retain) MMExampleSideDrawerViewController * leftSideDrawerViewController;
@property (nonatomic,retain) MMDrawerController *rootDrawerController;
-(void)replaceCurrentCenterViewController:(UIViewController*)vc;
-(void)refreshBadge:(int)sum;
@end
