//
//  MesViewController.h
//  youxin
//
//  Created by fei on 13-9-18.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINav.h"
#import "HttpDownload.h"
#import "HttpdownloadDelgate.h"

@interface MesViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,HttpdownloadDelegate>
@property (nonatomic,retain) UINav *nav;
@property (nonatomic,retain) UITextView *tvMes;
@property (nonatomic,retain) UILabel *lbCharCount;
@property (nonatomic,retain) UITextField *txtPhone;

@property (nonatomic,retain) HttpDownload *mHttpdownload;

@end
