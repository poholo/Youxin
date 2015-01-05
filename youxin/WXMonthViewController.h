//
//  WXMonthViewController.h
//  youxin
//
//  Created by yuyang on 13-9-26.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDGraphScrollView.h"
#import "FDGraphView.h"
#import "HttpDownload.h"
@interface WXMonthViewController : UIViewController<HttpdownloadDelegate,UIScrollViewDelegate>
@property (nonatomic,retain) UILabel *lbTime;
@property (nonatomic,retain) UILabel *lbYXTitle;
@property (nonatomic,retain) UILabel *lbActionTitle;
@property (nonatomic,retain) UILabel *lbYXSum;
@property (nonatomic,retain) UILabel *lbActionSum;
@property (nonatomic,retain) UIScrollView *scrollview;


@property (nonatomic,retain) FDGraphView *fdgcYXDis;
@property (nonatomic,retain) NSMutableArray *xlbArr;
@property (nonatomic,retain) NSMutableArray *ylbArr;

//net
@property (nonatomic,retain) HttpDownload *mHttpdownload;

//data
@property (nonatomic,retain) NSMutableArray *dataArr;
@property (nonatomic,assign) int yxSum;
@property (nonatomic,assign) int actionSum;
@property (nonatomic,assign) int showType;
@property (nonatomic,retain) NSString *usedate;
@property (nonatomic,assign) int maxY;


@property (nonatomic,retain) NSMutableArray *currentShowData;
@property (nonatomic,retain) NSMutableArray *xArr;
@property (nonatomic,retain) NSMutableArray *yArr;


@property (nonatomic,assign) int sum;
@property (nonatomic,retain) NSString *openDate;
@property (nonatomic,retain) NSString *currentDate;



@property (nonatomic,retain) NSString *startDate;
@property (nonatomic,retain) NSString *endDate;

@property (nonatomic,assign) int currentYear;
@property (nonatomic,assign) int currentMonth;
@property (nonatomic,assign) int currentDaySum;


@property (nonatomic,retain) UIButton *btnBeforeWeek;
@property (nonatomic,retain) UIButton *btnNextWeek;


@end
