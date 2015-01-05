//
//  LoginViewController.h
//  youxin
//
//  Created by fei on 13-9-8.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpDownload.h"
@class HttpDownload;

@interface LoginViewController : UIViewController<UITextFieldDelegate,HttpdownloadDelegate>
@property (nonatomic,retain) HttpDownload *mHttpdownload;
@end
