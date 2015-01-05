//
//  EditpasViewController.h
//  youxin
//
//  Created by fei on 13-9-18.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINav.h"
#import "HttpDownload.h"

@interface EditpasViewController : UIViewController<UITextFieldDelegate,HttpdownloadDelegate>
@property (nonatomic,retain) UINav *nav;
@property (nonatomic,retain) UITextField *txtBeforepas;
@property (nonatomic,retain) UITextField *txtNewPas;
@property (nonatomic,retain) UITextField *txtReNewPas;
@property (nonatomic,retain) UIButton *btnSave;


@property (nonatomic,retain) HttpDownload *mHttpdownload;
@end
