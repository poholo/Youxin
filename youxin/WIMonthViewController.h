//
//  WIMonthViewController.h
//  youxin
//
//  Created by fei on 13-9-29.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FDGraphScrollView.h"
#import "FDGraphView.h"
#import "HttpDownload.h"

@interface WIMonthViewController : UIViewController<HttpdownloadDelegate,UIScrollViewDelegate>
@property (nonatomic,retain) UILabel *lbTime;
@property (nonatomic,retain) UILabel *lbYXTitle;
@property (nonatomic,retain) UILabel *lbYXSum;
@property (nonatomic,retain) UIScrollView *scrollview;



@property (nonatomic,retain) UIButton *btnBefore;
@property (nonatomic,retain) UIButton *btnNext;


@property (nonatomic,retain) FDGraphView *fdgcYXDis;
@property (nonatomic,retain) NSMutableArray *xlbArr;
@property (nonatomic,retain) NSMutableArray *ylbArr;

//net
@property (nonatomic,retain) HttpDownload *mHttpdownload;

//data
@property (nonatomic,retain) NSMutableArray *dataArr;
@property (nonatomic,assign) int yxSum;
@property (nonatomic,assign) int showType;
@property (nonatomic,retain) NSDate *usedate;



@property (nonatomic,assign) int maxY;

@property (nonatomic,retain) NSMutableArray *currentShowData;
@property (nonatomic,retain) NSMutableArray *xArr;
@property (nonatomic,retain) NSMutableArray *yArr;

//时间 周
@property (nonatomic,retain) NSString *openDate;
@property (nonatomic,retain) NSString *currentDate;


@property (nonatomic,retain) NSString *startDate;
@property (nonatomic,retain) NSString *endDate;

@property (nonatomic,assign) int currentYear;
@property (nonatomic,assign) int currentMonth;
@property (nonatomic,assign) int currentDaySum;


@end
