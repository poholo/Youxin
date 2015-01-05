// Copyright (c) 2013 Mutual Mobile (http://mutualmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"
#import "HttpDownload.h"

#define UPLOADREQUEST_AUTO 0
#define UPLOADREQUEST_HANDLE 1


@class SubCell;

typedef NS_ENUM(NSInteger, MMDrawerSection){
    MMDrawerSectionViewSelection,
    MMDrawerSectionDrawerWidth,
    MMDrawerSectionShadowToggle,
    MMDrawerSectionOpenDrawerGestures,
    MMDrawerSectionCloseDrawerGestures,
    MMDrawerSectionCenterHiddenInteraction,
    MMDrawerSectionStretchDrawer,
};

@interface MMExampleSideDrawerViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,HttpdownloadDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * drawerWidths;
@property (nonatomic,assign) NSInteger usrtype;
@property (nonatomic,assign) BOOL isFirstOpen;
@property (nonatomic,assign) BOOL isSecOpen;
@property (nonatomic,assign) BOOL isYXdata;


@property (nonatomic,assign) int montion;
@property (nonatomic,assign) BOOL isDownloadData;
@property (nonatomic,assign) BOOL montionHadDownload;
//预约管理

@property (nonatomic,assign) int montionWaitSum;
@property (nonatomic,assign) int montionConfirmSum;
@property (nonatomic,assign) int montionAbanSum;


//救援管理
@property (nonatomic,assign) int montionJiuyuanWaitSum;
@property (nonatomic,assign) int montionJiuyuanConfirmSum;
@property (nonatomic,assign) int montionJiuyuanAbanSum;

//优信数据


//版本更新
//版本跟新请求
@property (nonatomic,assign) BOOL isUploadRequest;
@property (nonatomic,assign) int uploadRequestType;
@property (nonatomic,assign) BOOL hasNew;
@property (nonatomic,retain) HttpDownload *mHttpdownload;
@property (nonatomic,retain) HttpDownload *mSetHttpdownload;
@property (nonatomic,retain) HttpDownload *mUploadHttpdownload;
@property (nonatomic,retain) SubCell *currentSubCell;
@end
