//
//  WFMonthViewController.h
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
@interface WFMonthViewController : UIViewController<HttpdownloadDelegate,UIScrollViewDelegate>


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

@property (nonatomic,retain) UIButton *btnBefore;
@property (nonatomic,retain) UIButton *btnNext;


@property (nonatomic,retain) HttpDownload *mHttpdownload;


//data
@property (nonatomic,retain) NSDate *useDate;
@property (nonatomic,assign) int allSum;
@property (nonatomic,assign) int addSum;
@property (nonatomic,assign) int cancelSum;


@property (nonatomic,assign) int maxYAll;
@property (nonatomic,assign) int maxYAdd;
@property (nonatomic,assign) int maxYCancel;

@property (nonatomic,assign) int maxY;

@property (nonatomic,retain) NSArray *allArr;
@property (nonatomic,retain) NSArray *addArr;
@property (nonatomic,retain) NSArray *cancelArr;

@property (nonatomic,retain) NSMutableArray *xArr;
@property (nonatomic,retain) NSMutableArray *yArr;
@property (nonatomic,retain) NSMutableArray *currentShowLine1Arr;
@property (nonatomic,retain) NSMutableArray *currentShowLine2Arr;
@property (nonatomic,retain) NSMutableArray *currentShowLine3Arr;

//时间 周
@property (nonatomic,retain) NSString *openDate;
@property (nonatomic,retain) NSString *currentDate;


@property (nonatomic,retain) NSString *startDate;
@property (nonatomic,retain) NSString *endDate;

@property (nonatomic,assign) int currentYear;
@property (nonatomic,assign) int currentMonth;
@property (nonatomic,assign) int currentDaySum;

@end
