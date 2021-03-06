//
//  WFAllViewController.h
//  youxin
//
//  Created by fei on 13-9-29.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WechatFans.h"
#import "FDGraphView.h"
#import "FDGraphviewNoCenterPointer.h"

#import "HttpDownload.h"
#define SHOW_TYPE_DAY 0
#define SHOW_TYPE_WEEK 1
#define SHOW_TYPE_MONTH 2
@interface WFAllViewController : UIViewController<HttpdownloadDelegate,UIScrollViewDelegate>

@property (nonatomic,retain) WechatFans *wechatFans;

@property (nonatomic,retain) FDGraphviewNoCenterPointer *fgvSum;
@property (nonatomic,retain) FDGraphView *fgvNewAdd;
@property (nonatomic,retain) FDGraphView *fgvCancel;


//标题
@property (nonatomic,retain) UILabel* lbTime;
@property (nonatomic,retain) UILabel* lbAlltt;
@property (nonatomic,retain) UILabel* lbAddNewtt;
@property (nonatomic,retain) UILabel* lbCanceltt;

//总数

@property (nonatomic,retain) UILabel *lbAllSum;
@property (nonatomic,retain) UILabel *lbAddnewSum;
@property (nonatomic,retain) UILabel *lbCancelSum;

//3个色块
@property (nonatomic,retain) UIImageView *imgvwAll;
@property (nonatomic,retain) UIImageView *imgvwNewadd;
@property (nonatomic,retain) UIImageView *imgvwCancel;

//播放底板

@property (nonatomic,retain) UIScrollView *srcvw;

@property (nonatomic,retain) NSMutableArray *xlbArr;
@property (nonatomic,retain) NSMutableArray *ylbArr;


@property (nonatomic,retain) HttpDownload *mHttpdownload;


//data
@property (nonatomic,retain) NSDate *useDate;
@property (nonatomic,assign) int allSum;
@property (nonatomic,assign) int addSum;
@property (nonatomic,assign) int cancelSum;

@property (nonatomic,retain) NSArray *allArr;
@property (nonatomic,retain) NSArray *addArr;
@property (nonatomic,retain) NSArray *cancelArr;

@property (nonatomic,retain) NSMutableArray *xArr;
@property (nonatomic,retain) NSMutableArray *yArr;
@property (nonatomic,retain) NSMutableArray *currentShowLine1Arr;
@property (nonatomic,retain) NSMutableArray *currentShowLine2Arr;
@property (nonatomic,retain) NSMutableArray *currentShowLine3Arr;


@property (nonatomic,assign) int fromYear;
@property (nonatomic,assign) int fromMonth;
@property (nonatomic,assign) int fromDay;


@property (nonatomic,assign) int nowYear;
@property (nonatomic,assign) int nowMonth;
@property (nonatomic,assign) int nowDay;

@property (nonatomic,assign) int showType;
@property (nonatomic,assign) int maxY;


@property (nonatomic,assign) int maxYAll;
@property (nonatomic,assign) int maxYAdd;
@property (nonatomic,assign) int maxYCancel;
@end
